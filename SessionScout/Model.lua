-- SessionScout's pure Lua 5.1 model. No game APIs are called here.
-- All public functions expect a state returned by NewState/Normalize.
-- Normalize(saved) -> state, report. Returns nil, report for a future schema;
-- never overwrite SavedVariables when report.error is present.
-- AddTask(state, {label,minutes,priority?,scope?,recurrence?}) -> task | nil,error.
-- UpdateTask(state,id,patch) -> task | nil,error. DeleteTask -> boolean,error.
-- GetTask(state,id) -> task | nil (treat returned definitions as read-only).
-- ListTasks(state,characterKey,now) -> copied rows with completed/resetAt fields.
-- IsCompleted(state,id,characterKey,now) -> boolean,error.
-- CompleteTask(state,id,characterKey,now,{daily=timestamp,weekly=timestamp})
--   -> boolean,error. Recurring completion requires its next future reset.
-- ResetTask(state,id,characterKey) -> boolean,error (manual undo completion).
-- Refresh(state,now) -> count of expired completion records removed, or nil,error.
-- BuildPlan(state,characterKey,now,budgetMinutes,maxTasks?) -> plan | nil,error.
--   plan={tasks,totalMinutes,remainingMinutes,budgetMinutes,eligibleCount}.
--   Chooses at most maxTasks (default 3, maximum 3), maximizing high-priority
--   task count, then medium, then low, then used minutes. Ties are resolved by
--   stable iteration in priority, duration, id order. Budgets may be 0..240.
-- Definitions are shared; completion is account-wide or per characterKey.
-- Use a stable character identifier. All timestamps are caller-supplied UTC
-- epoch seconds. At exactly resetAt a recurring task becomes incomplete.
-- New states are empty; the addon invents no game objectives or reset rules.

local _, ns = ...
local Model = {
    VERSION = 1,
    MAX_TASKS = 200,
    MAX_BUDGET_MINUTES = 240,
    MAX_PLAN_TASKS = 3,
    MAX_CHARACTERS = 128,
}
ns.Model = Model

local function integer(value, low, high)
    return type(value) == "number" and value == value and value >= low
        and value <= high and value == math.floor(value)
end

local function timestamp(value)
    return integer(value, 0, 253402300799)
end

local function characterValid(key)
    return type(key) == "string" and #key > 0 and #key <= 200
        and not key:find("%c")
end

local function copyTask(task)
    return {
        id = task.id, label = task.label, minutes = task.minutes,
        priority = task.priority, scope = task.scope, recurrence = task.recurrence,
    }
end

local function taskFields(input)
    if type(input) ~= "table" then return nil, "Task must be a table." end
    if type(input.label) ~= "string" then return nil, "Enter a task name." end
    local label = input.label:gsub("%c", " "):match("^%s*(.-)%s*$")
    if #label == 0 then return nil, "Enter a task name." end
    if #label > 160 then return nil, "Task names must be at most 160 bytes." end
    if not integer(input.minutes, 1, Model.MAX_BUDGET_MINUTES) then
        return nil, "Duration must be a whole number from 1 to 240 minutes."
    end
    local priority = input.priority == nil and 2 or input.priority
    local scope = input.scope == nil and "character" or input.scope
    local recurrence = input.recurrence == nil and "once" or input.recurrence
    if not integer(priority, 1, 3) then return nil, "Priority must be 1, 2, or 3." end
    if scope ~= "character" and scope ~= "account" then return nil, "Invalid task scope." end
    if recurrence ~= "once" and recurrence ~= "daily" and recurrence ~= "weekly" then
        return nil, "Invalid task recurrence."
    end
    return {label=label, minutes=input.minutes, priority=priority, scope=scope, recurrence=recurrence}
end

function Model.NewState()
    return {version=Model.VERSION, nextId=1, tasks={}, progress={account={}, characters={}}}
end

function Model.GetTask(state, id)
    for _, task in ipairs(state.tasks) do
        if task.id == id then return task end
    end
end

local function nextId(state)
    local id = "task-" .. state.nextId
    while Model.GetTask(state, id) do
        state.nextId = state.nextId + 1
        id = "task-" .. state.nextId
    end
    state.nextId = state.nextId + 1
    return id
end

function Model.AddTask(state, input)
    if #state.tasks >= Model.MAX_TASKS then return nil, "The task limit is 200." end
    local task, err = taskFields(input)
    if not task then return nil, err end
    task.id = nextId(state)
    state.tasks[#state.tasks + 1] = task
    return task
end

local function clearTaskProgress(state, id)
    state.progress.account[id] = nil
    for key, records in pairs(state.progress.characters) do
        records[id] = nil
        if next(records) == nil then state.progress.characters[key] = nil end
    end
end

function Model.UpdateTask(state, id, patch)
    local old = Model.GetTask(state, id)
    if not old then return nil, "Task not found." end
    if type(patch) ~= "table" then return nil, "Changes must be a table." end
    local input = copyTask(old)
    for _, field in ipairs({"label", "minutes", "priority", "scope", "recurrence"}) do
        if patch[field] ~= nil then input[field] = patch[field] end
    end
    local task, err = taskFields(input)
    if not task then return nil, err end
    if old.scope ~= task.scope or old.recurrence ~= task.recurrence then
        clearTaskProgress(state, id)
    end
    for field, value in pairs(task) do old[field] = value end
    return old
end

function Model.DeleteTask(state, id)
    for index, task in ipairs(state.tasks) do
        if task.id == id then
            table.remove(state.tasks, index)
            clearTaskProgress(state, id)
            return true
        end
    end
    return false, "Task not found."
end

local function recordsFor(state, task, characterKey, create)
    if task.scope == "account" then return state.progress.account end
    if not characterValid(characterKey) then return nil, "A character identifier is required." end
    local records = state.progress.characters[characterKey]
    if not records and create then
        local count = 0
        for _ in pairs(state.progress.characters) do count = count + 1 end
        if count >= Model.MAX_CHARACTERS then return nil, "The character limit is 128." end
        records = {}
        state.progress.characters[characterKey] = records
    end
    return records
end

local function completed(task, record, now)
    if not record then return false end
    return task.recurrence == "once" or record.resetAt > now
end

function Model.IsCompleted(state, id, characterKey, now)
    if not timestamp(now) then return false, "Invalid current time." end
    local task = Model.GetTask(state, id)
    if not task then return false, "Task not found." end
    local records, err = recordsFor(state, task, characterKey)
    if err then return false, err end
    return completed(task, records and records[id], now)
end

function Model.ListTasks(state, characterKey, now)
    if not timestamp(now) then return nil, "Invalid current time." end
    if not characterValid(characterKey) then return nil, "A character identifier is required." end
    local rows = {}
    for _, task in ipairs(state.tasks) do
        local row = copyTask(task)
        local records = recordsFor(state, task, characterKey)
        local record = records and records[task.id]
        row.completed = completed(task, record, now)
        if row.completed then
            row.completedAt = record.completedAt
            row.resetAt = record.resetAt
        end
        rows[#rows + 1] = row
    end
    return rows
end

function Model.CompleteTask(state, id, characterKey, now, resets)
    if not timestamp(now) then return false, "Invalid current time." end
    local task = Model.GetTask(state, id)
    if not task then return false, "Task not found." end
    local records, err = recordsFor(state, task, characterKey)
    if err then return false, err end
    if completed(task, records and records[id], now) then return false, "Task is already complete." end
    local resetAt
    if task.recurrence ~= "once" then
        resetAt = type(resets) == "table" and resets[task.recurrence] or nil
        if not timestamp(resetAt) or resetAt <= now then
            return false, "The next " .. task.recurrence .. " reset is unavailable."
        end
    end
    records, err = recordsFor(state, task, characterKey, true)
    if err then return false, err end
    records[id] = {completedAt=now, resetAt=resetAt}
    return true
end

function Model.ResetTask(state, id, characterKey)
    local task = Model.GetTask(state, id)
    if not task then return false, "Task not found." end
    local records, err = recordsFor(state, task, characterKey)
    if err then return false, err end
    if not records or not records[id] then return false, "Task is not complete." end
    records[id] = nil
    if task.scope == "character" and next(records) == nil then
        state.progress.characters[characterKey] = nil
    end
    return true
end

function Model.Refresh(state, now)
    if not timestamp(now) then return nil, "Invalid current time." end
    local removed = 0
    local function expire(records)
        for id, record in pairs(records) do
            if record.resetAt and record.resetAt <= now then
                records[id] = nil
                removed = removed + 1
            end
        end
    end
    expire(state.progress.account)
    for key, records in pairs(state.progress.characters) do
        expire(records)
        if next(records) == nil then state.progress.characters[key] = nil end
    end
    return removed
end

local function better(a, b)
    if not b then return true end
    if a.high ~= b.high then return a.high > b.high end
    if a.medium ~= b.medium then return a.medium > b.medium end
    return a.low > b.low
end

local function sortedBefore(a, b)
    if a.priority ~= b.priority then return a.priority < b.priority end
    if a.minutes ~= b.minutes then return a.minutes < b.minutes end
    return a.id < b.id
end

function Model.BuildPlan(state, characterKey, now, budgetMinutes, maxTasks)
    if not integer(budgetMinutes, 0, Model.MAX_BUDGET_MINUTES) then
        return nil, "Budget must be a whole number from 0 to 240 minutes."
    end
    maxTasks = maxTasks == nil and Model.MAX_PLAN_TASKS or maxTasks
    if not integer(maxTasks, 1, Model.MAX_PLAN_TASKS) then return nil, "Plan size must be 1, 2, or 3." end
    local rows, err = Model.ListTasks(state, characterKey, now)
    if not rows then return nil, err end
    local eligible = {}
    for _, task in ipairs(rows) do
        if not task.completed and task.minutes <= budgetMinutes then eligible[#eligible + 1] = task end
    end
    table.sort(eligible, sortedBefore)
    -- Keep distinct task-count states: a higher-count partial plan must never
    -- erase a shorter partial plan that can still accept a high-priority task.
    local dp = {[0] = {[0] = {high=0, medium=0, low=0}}}
    for count = 1, maxTasks do dp[count] = {} end
    for _, task in ipairs(eligible) do
        for count = maxTasks, 1, -1 do
            for used = budgetMinutes, task.minutes, -1 do
                local previous = dp[count - 1][used - task.minutes]
                if previous then
                    local candidate = {
                        high=previous.high + (task.priority == 1 and 1 or 0),
                        medium=previous.medium + (task.priority == 2 and 1 or 0),
                        low=previous.low + (task.priority == 3 and 1 or 0),
                        task=task, previous=previous,
                    }
                    if better(candidate, dp[count][used]) then dp[count][used] = candidate end
                end
            end
        end
    end
    local best, usedMinutes = dp[0][0], 0
    for count = 1, maxTasks do
        for used = 0, budgetMinutes do
            local candidate = dp[count][used]
            if candidate and (better(candidate, best)
                or (not better(best, candidate) and used > usedMinutes)) then
                best, usedMinutes = candidate, used
            end
        end
    end
    local tasks = {}
    while best and best.task do
        tasks[#tasks + 1] = best.task
        best = best.previous
    end
    table.sort(tasks, sortedBefore)
    return {
        tasks=tasks, totalMinutes=usedMinutes, remainingMinutes=budgetMinutes-usedMinutes,
        budgetMinutes=budgetMinutes, eligibleCount=#eligible,
    }
end

function Model.Normalize(saved)
    local state = Model.NewState()
    local report = {discardedTasks=0, discardedProgress=0, migratedFrom=nil}
    if type(saved) ~= "table" then return state, report end
    if type(saved.version) == "number" and saved.version > Model.VERSION then
        report.error = "Saved data uses a newer SessionScout version."
        return nil, report
    end
    local legacy = saved.version == nil or saved.version == 0
    if legacy then report.migratedFrom = 0 end
    if integer(saved.nextId, 1, 2147483647) then state.nextId = saved.nextId end
    local byId, indices = {}, {}
    if type(saved.tasks) == "table" then
        for index in pairs(saved.tasks) do
            if integer(index, 1, 2147483647) then indices[#indices + 1] = index end
        end
    end
    table.sort(indices)
    -- Reserve existing generated IDs before repairing missing IDs, so an
    -- earlier malformed definition cannot steal a later valid task's progress.
    for _, index in ipairs(indices) do
        local source = saved.tasks[index]
        if type(source) == "table" and type(source.id) == "string" then
            local suffix = tonumber(source.id:match("^task%-(%d+)$"))
            if suffix and integer(suffix, 1, 2147483646) and suffix >= state.nextId then
                state.nextId = suffix + 1
            end
        end
    end
    for _, index in ipairs(indices) do
        local source = saved.tasks[index]
        local input = source
        if legacy and type(source) == "table" then
            input = {
                label=source.label or source.title or source.name,
                minutes=source.minutes or source.durationMinutes or source.duration,
                priority=source.priority, scope=source.scope, recurrence=source.recurrence,
            }
        end
        local task = taskFields(input)
        if task and #state.tasks < Model.MAX_TASKS then
            local id = source.id
            if type(id) ~= "string" or #id == 0 or #id > 80 or not id:match("^[%w_-]+$") then
                id = nextId(state)
            end
            if not byId[id] then
                task.id = id
                byId[id] = task
                state.tasks[#state.tasks + 1] = task
                local suffix = tonumber(id:match("^task%-(%d+)$"))
                if suffix and integer(suffix, 1, 2147483646) and suffix >= state.nextId then
                    state.nextId = suffix + 1
                end
            else report.discardedTasks = report.discardedTasks + 1 end
        else report.discardedTasks = report.discardedTasks + 1 end
    end
    local rawProgress = saved.progress
    if legacy and type(rawProgress) ~= "table" then rawProgress = saved.completed end
    if type(rawProgress) ~= "table" then return state, report end
    local function normalizeRecords(raw, destination, scope)
        if type(raw) ~= "table" then return end
        for id, value in pairs(raw) do
            local task = byId[id]
            local record = value
            -- Version 0 permitted boolean/epoch completion for one-time tasks.
            if legacy and task and task.recurrence == "once" then
                if value == true then record = {completedAt=0}
                elseif timestamp(value) then record = {completedAt=value} end
            end
            local valid = task and task.scope == scope and type(record) == "table"
                and timestamp(record.completedAt)
            if valid and task.recurrence ~= "once" then
                valid = timestamp(record.resetAt) and record.resetAt > record.completedAt
            end
            if valid then
                destination[id] = {completedAt=record.completedAt,
                    resetAt=task.recurrence ~= "once" and record.resetAt or nil}
            else report.discardedProgress = report.discardedProgress + 1 end
        end
    end
    normalizeRecords(rawProgress.account, state.progress.account, "account")
    if type(rawProgress.characters) == "table" then
        local keys = {}
        for key in pairs(rawProgress.characters) do
            if characterValid(key) then keys[#keys + 1] = key end
        end
        table.sort(keys)
        local count = 0
        for _, key in ipairs(keys) do
            local destination = {}
            normalizeRecords(rawProgress.characters[key], destination, "character")
            if next(destination) ~= nil and count < Model.MAX_CHARACTERS then
                state.progress.characters[key] = destination
                count = count + 1
            end
        end
    end
    return state, report
end
