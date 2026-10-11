-- Run from repository root with Lua 5.1: lua tests/model_spec.lua
local ns = {}
assert(loadfile("SessionScout/Model.lua"))("SessionScout", ns)
local M, passed = ns.Model, 0
local function eq(actual, expected, message)
    assert(actual == expected, (message or "Values differ") .. ": expected " .. tostring(expected) .. ", got " .. tostring(actual))
end
local function test(name, callback)
    local ok, err = pcall(callback)
    if not ok then error("FAIL " .. name .. ": " .. tostring(err), 0) end
    passed = passed + 1
    print("PASS " .. name)
end
local function add(state, label, minutes, priority, scope, recurrence)
    return assert(M.AddTask(state, {label=label, minutes=minutes, priority=priority, scope=scope, recurrence=recurrence}))
end

test("new states contain no invented objectives", function()
    local state = M.NewState()
    eq(state.version, 1)
    eq(#state.tasks, 0)
    eq(#M.BuildPlan(state, "A", 100, 30).tasks, 0)
end)

test("task validation is atomic and strips control characters", function()
    local state = M.NewState()
    local task = add(state, "  My\ntask  ", 10)
    eq(task.label, "My task")
    eq(task.priority, 2)
    for _, bad in ipairs({0, -1, 241, 1.5, math.huge, "10"}) do
        eq(M.AddTask(state, {label="Bad", minutes=bad}), nil)
    end
    eq(M.AddTask(state, {label=" ", minutes=1}), nil)
    eq(M.UpdateTask(state, task.id, {scope="invalid"}), nil)
    eq(task.scope, "character")
    eq(#state.tasks, 1)
end)

test("character and account completions are separate", function()
    local state = M.NewState()
    local char = add(state, "Personal", 10, 1, "character")
    local account = add(state, "Shared", 10, 1, "account")
    assert(M.CompleteTask(state, char.id, "A", 100))
    assert(M.CompleteTask(state, account.id, "A", 100))
    eq(M.IsCompleted(state, char.id, "A", 100), true)
    eq(M.IsCompleted(state, char.id, "B", 100), false)
    eq(M.IsCompleted(state, account.id, "B", 100), true)
    eq(M.CompleteTask(state, char.id, "A", 101), false)
    eq(M.CompleteTask(state, char.id, "A", 99), false, "Clock rollback cannot re-complete a task")
    eq(M.CompleteTask(state, account.id, "B", 101), false)
    eq(M.ResetTask(state, char.id, "B"), false)
    assert(M.ResetTask(state, account.id, "B"))
    eq(M.IsCompleted(state, account.id, "A", 100), false)
end)

test("recurrence uses explicit reset timestamps and exact boundaries", function()
    local state = M.NewState()
    local daily = add(state, "Daily", 10, 1, "character", "daily")
    local weekly = add(state, "Weekly", 10, 1, "account", "weekly")
    eq(M.CompleteTask(state, daily.id, "A", 100), false)
    eq(M.CompleteTask(state, daily.id, "A", 100, {daily=100}), false)
    assert(M.CompleteTask(state, daily.id, "A", 100, {daily=200}))
    assert(M.CompleteTask(state, weekly.id, "A", 100, {weekly=900}))
    eq(M.IsCompleted(state, daily.id, "A", 199), true)
    eq(M.IsCompleted(state, daily.id, "A", 200), false)
    eq(M.IsCompleted(state, weekly.id, "B", 200), true)
    assert(M.CompleteTask(state, daily.id, "A", 200, {daily=300}))
    eq(M.Refresh(state, 300), 1)
    eq(M.IsCompleted(state, daily.id, "A", 300), false)
    eq(M.Refresh(state, 900), 1)
    eq(M.IsCompleted(state, weekly.id, "A", 900), false)
end)

test("invalid time and character inputs do not mutate progress", function()
    local state = M.NewState()
    local task = add(state, "Task", 5)
    eq(M.CompleteTask(state, task.id, "", 100), false)
    eq(M.CompleteTask(state, task.id, "A", 0/0), false)
    eq(M.CompleteTask(state, task.id, "A", -1), false)
    eq(M.BuildPlan(state, "A", math.huge, 30), nil)
    eq(next(state.progress.characters), nil)
end)

test("planner prioritizes high-priority work, fits budget, and caps at three", function()
    local state = M.NewState()
    local high = add(state, "High", 20, 1)
    add(state, "Medium", 15, 2)
    add(state, "Low", 10, 3)
    add(state, "Low two", 5, 3)
    add(state, "Low three", 5, 3)
    local plan = assert(M.BuildPlan(state, "A", 100, 30))
    eq(plan.tasks[1].id, high.id)
    eq(#plan.tasks, 3)
    eq(plan.totalMinutes, 30)
    eq(plan.remainingMinutes, 0)
    eq(plan.eligibleCount, 5)
    assert(M.CompleteTask(state, high.id, "A", 100))
    eq(M.BuildPlan(state, "A", 100, 30).tasks[1].label, "Medium")
    eq(#M.BuildPlan(state, "A", 100, 0).tasks, 0)
    eq(M.BuildPlan(state, "A", 100, -1), nil)
    eq(M.BuildPlan(state, "A", 100, 241), nil)
    eq(M.BuildPlan(state, "A", 100, 1.2), nil)
    eq(#M.BuildPlan(state, "A", 100, 30, 1).tasks, 1)
    eq(M.BuildPlan(state, "A", 100, 30, 4), nil)
end)

test("planner preserves partial states under its cardinality cap", function()
    local state = M.NewState()
    add(state, "Short high", 1, 1)
    add(state, "Long high", 4, 1)
    add(state, "Medium", 3, 2)
    add(state, "Low", 5, 3)
    local plan = assert(M.BuildPlan(state, "A", 100, 8, 2))
    eq(#plan.tasks, 2)
    eq(plan.tasks[1].priority, 1)
    eq(plan.tasks[2].priority, 1)
    eq(plan.totalMinutes, 5)
end)

test("planner maximizes used minutes after priority counts and is deterministic", function()
    local state = M.NewState()
    add(state, "Short", 8, 2)
    local a = add(state, "Exact", 10, 2)
    add(state, "Exact duplicate duration", 10, 2)
    for _ = 1, 10 do
        local plan = assert(M.BuildPlan(state, "A", 100, 10))
        eq(plan.tasks[1].id, a.id)
        eq(plan.totalMinutes, 10)
    end
    local rows = M.ListTasks(state, "A", 100)
    rows[1].label = "Changed externally"
    eq(state.tasks[1].label, "Short")
end)

test("scope and recurrence edits clear obsolete completions", function()
    local state = M.NewState()
    local task = add(state, "Task", 10)
    assert(M.CompleteTask(state, task.id, "A", 100))
    assert(M.UpdateTask(state, task.id, {label="Renamed"}))
    eq(M.IsCompleted(state, task.id, "A", 100), true)
    assert(M.UpdateTask(state, task.id, {scope="account"}))
    eq(M.IsCompleted(state, task.id, "A", 100), false)
    assert(M.CompleteTask(state, task.id, "A", 100))
    assert(M.UpdateTask(state, task.id, {recurrence="weekly"}))
    eq(M.IsCompleted(state, task.id, "A", 100), false)
    assert(M.CompleteTask(state, task.id, "A", 100, {weekly=300}))
    assert(M.DeleteTask(state, task.id))
    eq(next(state.progress.account), nil)
    eq(#state.tasks, 0)
    eq(M.DeleteTask(state, task.id), false)
end)

test("normalization migrates legacy data without guessing recurring resets", function()
    local state, report = M.Normalize({tasks={
        {id="task-8", title="Old title", duration=5, scope="account"},
        {id="daily", name="Old daily", durationMinutes=10, recurrence="daily"},
    }, completed={account={["task-8"]=true}, characters={A={daily=true}}}})
    eq(report.migratedFrom, 0)
    eq(report.discardedProgress, 1)
    eq(M.IsCompleted(state, "task-8", "A", 100), true)
    eq(M.IsCompleted(state, "daily", "A", 100), false)
    eq(add(state, "New", 10).id, "task-9")
end)

test("normalization validates sparse, duplicate, corrupt and wrong-scope data", function()
    local raw = {version=1, nextId=-1, tasks={
        [1]={id="good",label="Good",minutes=5,scope="account"},
        [3]={id="good",label="Duplicate",minutes=5},
        [4]={id="invalid",label="Bad",minutes=0/0},
        [5]={id="daily",label="Daily",minutes=5,recurrence="daily"},
        [6]={id="bad-priority",label="Bad",minutes=1,priority=9},
    }, progress={account={good={completedAt=10,resetAt=200},daily={completedAt=10,resetAt=20},ghost={completedAt=10}},
        characters={A={daily={completedAt=30,resetAt=20},good={completedAt=10}}}}}
    local state, report = M.Normalize(raw)
    eq(#state.tasks, 2)
    eq(report.discardedTasks, 3)
    eq(report.discardedProgress, 4)
    eq(state.progress.account.good.resetAt, nil)
    eq(M.IsCompleted(state, "good", "A", 10), true)
    eq(M.IsCompleted(state, "daily", "A", 10), false)
    eq(raw.progress.account.good.resetAt, 200, "Normalization does not mutate saved input")
    local again = M.Normalize(state)
    eq(#again.tasks, #state.tasks)
    eq(again.nextId, state.nextId)
    eq(M.IsCompleted(again, "good", "B", 10), true)
end)

test("repairing a missing id cannot take an existing task's completion", function()
    local state = M.Normalize({version=1,tasks={
        {label="Missing id",minutes=5,scope="account"},
        {id="task-1",label="Existing",minutes=5,scope="account"},
    },progress={account={["task-1"]={completedAt=50}}}})
    eq(#state.tasks, 2)
    eq(state.tasks[1].id, "task-2")
    eq(M.IsCompleted(state, "task-1", "A", 100), true)
    eq(M.IsCompleted(state, "task-2", "A", 100), false)
end)

test("planner agrees with exhaustive subset oracle", function()
    -- The oracle enumerates all subsets independently of the planner's DP.
    local seed = 37
    local function random(bound)
        seed = (seed * 16807) % 2147483647
        return seed % bound + 1
    end
    local function superior(a, b)
        for index = 1, 4 do
            if a[index] ~= b[index] then return a[index] > b[index] end
        end
        return false
    end
    for case = 1, 80 do
        local state = M.NewState()
        for index = 1, 7 do add(state, "Task " .. index, random(12), random(3)) end
        local budget, cap = random(24), random(3)
        local best = {0,0,0,0}
        for mask = 0, 127 do
            local count, score, remainder = 0, {0,0,0,0}, mask
            for _, task in ipairs(state.tasks) do
                if remainder % 2 == 1 then
                    count = count + 1
                    score[task.priority] = score[task.priority] + 1
                    score[4] = score[4] + task.minutes
                end
                remainder = math.floor(remainder / 2)
            end
            if count <= cap and score[4] <= budget and superior(score, best) then best = score end
        end
        local plan, score, seen = assert(M.BuildPlan(state, "A", 100, budget, cap)), {0,0,0,0}, {}
        for _, task in ipairs(plan.tasks) do
            assert(not seen[task.id], "Planner included the same task twice")
            seen[task.id] = true
            score[task.priority] = score[task.priority] + 1
            score[4] = score[4] + task.minutes
        end
        for index = 1, 4 do eq(score[index], best[index], "Oracle case " .. case) end
        eq(score[4], plan.totalMinutes)
        assert(#plan.tasks <= cap)
    end
end)

test("future schema cannot be silently downgraded", function()
    local state, report = M.Normalize({version=2, tasks={}})
    eq(state, nil)
    assert(report.error)
    eq(#M.Normalize("broken").tasks, 0)
end)

test("task and character limits are enforced", function()
    local state = M.NewState()
    for index = 1, M.MAX_TASKS do add(state, "Task " .. index, 1) end
    eq(M.AddTask(state, {label="Overflow",minutes=1}), nil)
    local id = state.tasks[1].id
    for index = 1, M.MAX_CHARACTERS do assert(M.CompleteTask(state, id, "C" .. index, 100)) end
    eq(M.CompleteTask(state, id, "Overflow", 100), false)
    assert(M.ResetTask(state, id, "C1"))
    assert(M.CompleteTask(state, id, "Replacement", 100))
    local plan = M.BuildPlan(state, "Other", 100, 240)
    eq(#plan.tasks, 3)
end)

print("All " .. passed .. " model tests passed (" .. _VERSION .. ").")
