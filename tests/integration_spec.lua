-- Run from repository root with Lua 5.1: lua tests/integration_spec.lua
-- Real Model/Core/UI, mocked WoW lifecycle. Does not establish in-game compatibility.
local root = "."
local passed, failed = 0, 0

local function eq(actual, expected, message)
    if actual ~= expected then
        error((message or "values differ") .. ": expected " .. tostring(expected) .. ", got " .. tostring(actual), 2)
    end
end
local function ok(value, message) if not value then error(message or "assertion failed", 2) end end
local function contains(value, expected, message)
    ok(type(value) == "string" and value:find(expected, 1, true), message or (tostring(value) .. " does not contain " .. expected))
end
local function test(name, callback)
    local success, err = pcall(callback)
    if success then passed = passed + 1; print("PASS " .. name)
    else failed = failed + 1; print("FAIL " .. name .. ": " .. tostring(err)) end
end

local function secretMarker(env)
    local function reject() error("attempted to inspect or operate on a secret marker") end
    local marker = setmetatable({}, {__tostring=reject, __concat=reject, __add=reject, __sub=reject,
        __mul=reject, __div=reject, __lt=reject, __le=reject})
    env.issecretvalue = function(value) return rawequal(value, marker) end
    return marker
end

local function world(saved, characterSaved, options)
    options = options or {}
    local env = setmetatable({}, {__index = _G})
    env._G = env
    local ns = {}
    local state = {now=1000000, frames={}, messages={}, timers={}, bagCalls=0, durabilityCalls=0, combat=false}
    env.SessionScoutDB, env.SessionScoutCharDB = saved, characterSaved
    env.SlashCmdList, env.UISpecialFrames = {}, {}
    local methods = {}
    local function fire(frame, name, ...)
        if frame.scripts[name] then frame.scripts[name](frame, ...) end
        for _, hook in ipairs(frame.hooks[name] or {}) do hook(frame, ...) end
    end
    local function frame(kind, name, parent)
        local f = setmetatable({kind=kind, name=name, parent=parent, shown=true, scripts={}, hooks={}, text=""}, {__index=methods})
        state.frames[#state.frames + 1] = f
        if name then env[name] = f end
        return f
    end
    for _, method in ipairs({"SetPoint", "SetJustifyH", "SetTextColor", "SetClampedToScreen", "SetMovable", "EnableMouse",
        "SetFrameStrata", "SetBackdrop", "SetBackdropColor", "SetBackdropBorderColor", "RegisterForDrag", "SetAutoFocus",
        "SetNumeric", "StartMoving", "StopMovingOrSizing", "SetToplevel", "Raise"}) do
        methods[method] = function() end
    end
    function methods:SetSize(width, height) self.width, self.height = width, height end
    function methods:SetWidth(width) self.width = width end
    function methods:SetHeight(height) self.height = height end
    function methods:SetWordWrap(wrap) self.wordWrap = wrap end
    function methods:SetMaxLines(lines) self.maxLines = lines end
    function methods:GetHeight() return self.height or 1080 end
    function methods:SetScale(scale) self.scale = scale end
    function methods:SetMaxLetters(limit) self.maxLetters = limit end
    function methods:SetFocus() self.focus = true end
    function methods:ClearFocus() self.focus = false end
    function methods:HasFocus() return self.focus == true end
    function methods:SetText(text) self.text = text; fire(self, "OnTextChanged", false) end
    function methods:GetText() return self.text end
    function methods:SetScript(name, callback) self.scripts[name] = callback end
    function methods:HookScript(name, callback)
        self.hooks[name] = self.hooks[name] or {}; table.insert(self.hooks[name], callback)
    end
    function methods:RegisterEvent(event) self.events = self.events or {}; self.events[event] = true end
    function methods:IsShown() return self.shown end
    function methods:Show() if not self.shown then self.shown = true; fire(self, "OnShow") end end
    function methods:Hide() if self.shown then self.shown = false; fire(self, "OnHide") end end
    function methods:SetShown(shown) if shown then self:Show() else self:Hide() end end
    function methods:CreateFontString(name) return frame("FontString", name, self) end
    function methods:Click() fire(self, "OnClick", "LeftButton") end
    function methods:PressEnter() fire(self, "OnEnterPressed") end
    function methods:MouseEnter() fire(self, "OnEnter") end
    function methods:MouseLeave() fire(self, "OnLeave") end
    env.CreateFrame = function(kind, name, parent) return frame(kind, name, parent) end
    env.UIParent = frame("Frame", "UIParent"); env.UIParent.height = 1080
    env.GameTooltip = frame("GameTooltip", "GameTooltip"); env.GameTooltip:Hide()
    function env.GameTooltip:SetOwner(owner, anchor) self.owner, self.anchor, self.lines = owner, anchor, {} end
    function env.GameTooltip:AddLine(text, red, green, blue, wrap)
        self.lines[#self.lines + 1] = {text=text, red=red, green=green, blue=blue, wrap=wrap}
    end
    env.DEFAULT_CHAT_FRAME = {AddMessage=function(_, message) state.messages[#state.messages + 1] = message end}
    env.GetServerTime = function() return state.now end
    env.time = env.GetServerTime
    env.UnitGUID = function() if options.guid == false then return nil end; return options.guid or "Player-1-TEST" end
    env.UnitName = function() return "Tester" end
    env.GetRealmName = function() return "TestRealm" end
    env.InCombatLockdown = function() return state.combat end
    env.C_DateAndTime = {
        GetSecondsUntilDailyReset=function() return 100 end,
        GetSecondsUntilWeeklyReset=function() return 1000 end,
    }
    env.C_Container = {GetContainerNumFreeSlots=function(bag)
        state.bagCalls = state.bagCalls + 1
        local data = ({[0]={3,0}, [1]={10,64}, [2]={2}, [3]={0,0}, [4]={1,0}, [5]={20,0}})[bag]
        if data then return data[1], data[2] end
    end}
    env.GetInventoryItemDurability = function(slot)
        state.durabilityCalls = state.durabilityCalls + 1
        if slot == 1 then return 25,100 elseif slot == 2 then return nil,nil elseif slot == 3 then return 0,0
        elseif slot == 4 then return 99,100 end
    end
    env.C_Timer = {NewTicker=function(interval, callback)
        local timer = {interval=interval, callback=callback, cancelled=false}
        function timer:Cancel() self.cancelled = true end
        state.timers[#state.timers + 1] = timer
        return timer
    end}
    for _, file in ipairs({"Model.lua", "Core.lua", "UI.lua"}) do
        local chunk = assert(loadfile(root .. "/SessionScout/" .. file)); setfenv(chunk, env); chunk("SessionScout", ns)
    end
    function state:event(name, arg) fire(ns.events, "OnEvent", name, arg) end
    function state:login() self:event("ADDON_LOADED", "SessionScout"); self:event("PLAYER_LOGIN") end
    function state:open() env.SlashCmdList.SESSIONSCOUT("") end
    function state:activeTimers()
        local count = 0; for _, timer in ipairs(self.timers) do if not timer.cancelled then count = count + 1 end end
        return count
    end
    function state:add(label, minutes)
        ns.window.taskLabel:SetText(label); ns.window.minutes:SetText(tostring(minutes)); ns.window.save:Click()
    end
    function state:row(label)
        for _, row in ipairs(ns.window.taskRows) do if row.task and row.task.label == label then return row end end
        error("visible row not found: " .. label)
    end
    return ns, env, state
end

test("only own ADDON_LOADED initializes; login establishes character and welcome", function()
    local ns, env, s = world(nil, {budget=60, note="Next quest"})
    s:event("ADDON_LOADED", "AnotherAddon"); eq(ns.db, nil)
    s:login(); eq(ns.character, "Player-1-TEST"); eq(ns.settings.budget, 60); eq(ns.settings.note, "Next quest")
    eq(env.SessionScoutDB, ns.db); eq(env.SessionScoutCharDB, ns.settings); eq(#s.messages, 1)
    s:event("PLAYER_LOGIN"); eq(#s.messages, 1, "welcome should not repeat")
end)

test("secret GUID uses a readable name-realm fallback", function()
    local ns, env, s = world(); local secret = secretMarker(env)
    env.UnitGUID = function() return secret end
    s:login(); eq(ns.character, "Tester-TestRealm"); s:open(); ok(ns.window:IsShown())
end)

test("unreadable identity defers UI and completion until combat recovery", function()
    local ns, env, s = world(); local secret = secretMarker(env)
    env.UnitGUID = function() return secret end
    env.UnitName = function() return secret end
    env.GetRealmName = function() return secret end
    s:login(); eq(ns.character, nil)
    local personal = assert(ns.Model.AddTask(ns.db, {label="Deferred personal", minutes=10}))
    local shared = assert(ns.Model.AddTask(ns.db, {label="Deferred shared", minutes=10, scope="account"}))
    s:open(); eq(ns.window, nil); eq(s:activeTimers(), 0)
    contains(s.messages[#s.messages], "identity is not available")
    ns.Complete(personal.id); ns.Complete(shared.id)
    eq(next(ns.db.progress.characters), nil, "deferred identity must not create character progress")
    eq(next(ns.db.progress.account), nil, "deferred identity must not mark shared tasks complete")
    env.UnitGUID = function() return "Player-1-RECOVERED" end
    s:event("PLAYER_REGEN_ENABLED"); eq(ns.character, "Player-1-RECOVERED")
    s:open(); ok(ns.window:IsShown()); eq(s:activeTimers(), 1)
    ns.Complete(personal.id); ok(ns.Model.IsCompleted(ns.db, personal.id, ns.character, s.now))
end)

test("unsupported future schema preserves both original saved tables", function()
    local future = {version=999, secret="preserve", tasks={{label="future data"}}}
    local char = {budget=75, note="do not mutate", welcomed=false}
    local ns, env, s = world(future, char)
    s:login(); s:open(); s:event("PLAYER_LOGOUT")
    eq(ns.db, nil); eq(env.SessionScoutDB, future); eq(future.secret, "preserve")
    eq(env.SessionScoutCharDB, char); eq(char.budget, 75); eq(char.welcomed, false); eq(ns.window, nil)
    contains(table.concat(s.messages, "\n"), "newer SessionScout version")
end)

test("malformed character settings recover and long notes are bounded", function()
    local ns, _, s = world(nil, {budget="30", note=string.rep("x", 600)})
    s:login(); eq(ns.settings.budget, 30); eq(#ns.settings.note, 500)
    local ns2, _, s2 = world(nil, false); s2:login(); eq(ns2.settings.budget, 30); eq(ns2.settings.note, "")
end)

test("UTF-8 saved notes preserve characters and truncate only at complete letters", function()
    local letter = "å"
    local note = string.rep(letter, 300)
    local ns, env, s = world(nil, {note=note}); s:login(); s:open()
    eq(ns.settings.note, note, "300 Norwegian letters must survive login")
    eq(ns.window.note:GetText(), note)
    s:event("PLAYER_LOGOUT")
    local ns2, _, s2 = world(env.SessionScoutDB, env.SessionScoutCharDB); s2:login()
    eq(ns2.settings.note, note, "reloading must preserve UTF-8 notes")
    local ns3, _, s3 = world(nil, {note=string.rep(letter, 501)}); s3:login()
    eq(ns3.settings.note, string.rep(letter, 500), "limit counts characters, not bytes")
    local ns4, _, s4 = world(nil, {note="x" .. string.rep(letter, 500)}); s4:login()
    eq(ns4.settings.note, "x" .. string.rep(letter, 499), "mixed-width boundary must preserve complete codepoints")
end)

test("fractional and NaN saved budgets recover to usable whole-minute defaults", function()
    for _, value in ipairs({30.5, 0/0}) do
        local ns, _, s = world(nil, {budget=value})
        s:login(); eq(ns.settings.budget, 30, "invalid budget must normalize before rendering")
    end
end)

test("slash commands clamp budgets, toggle visibility and cancel every ticker", function()
    local ns, env, s = world(); s:login()
    eq(env.SLASH_SESSIONSCOUT1, "/scout"); eq(env.SLASH_SESSIONSCOUT2, "/sessionscout")
    env.SlashCmdList.SESSIONSCOUT("60"); eq(ns.settings.budget, 60); ok(ns.window:IsShown()); eq(s:activeTimers(), 1)
    env.SlashCmdList.SESSIONSCOUT("999"); eq(ns.settings.budget, 240); eq(s:activeTimers(), 1)
    env.SlashCmdList.SESSIONSCOUT("-2"); eq(ns.settings.budget, 1); eq(s:activeTimers(), 1)
    s:open(); eq(ns.window:IsShown(), false); eq(s:activeTimers(), 0)
    for _ = 1, 10 do s:open(); eq(s:activeTimers(), 1); s:open(); eq(s:activeTimers(), 0) end
    eq(#env.UISpecialFrames, 1, "one window should be registered")
end)

test("custom session minutes make a two-hour task actionable without exceeding the chosen budget", function()
    local ns, _, s = world(nil, {budget=60}); s:login(); s:open()
    s:add("Completed short task", 30); s:row("Completed short task").toggle:Click()
    s:add("RFK equipment run", 120); s:add("Scarlet Monastery run", 120)
    eq(ns.window.budgetInput:GetText(), "60")
    eq(ns.window.planRows[1].task, nil)
    contains(ns.window.planSummary:GetText(), "Shortest unfinished task: 120 min.")

    ns.window.budgetInput:SetText("120"); ns.window.applyBudget:Click()
    eq(ns.settings.budget, 120)
    eq(ns.window.planRows[1].task.label, "RFK equipment run")
    eq(ns.window.planRows[1].task.minutes, 120)
    eq(ns.window.planRows[2].task, nil, "two 120-minute tasks must not fit a 120-minute session")
    contains(ns.window.planSummary:GetText(), "120 of 120 min")

    ns.window.budgetInput:SetText("90"); ns.window.budgetInput:PressEnter()
    eq(ns.settings.budget, 90); eq(ns.window.planRows[1].task, nil)
    contains(ns.window.planSummary:GetText(), "Shortest unfinished task: 120 min.")
    ns.window.budgets[3]:Click()
    eq(ns.settings.budget, 60); eq(ns.window.planRows[1].task, nil)
    eq(ns.db.tasks[2].minutes, 120, "choosing a session must not silently shorten a task estimate")
end)

test("invalid session input explains the accepted range and preserves the committed plan", function()
    local ns, _, s = world(nil, {budget=120}); s:login(); s:open(); s:add("Long run", 120)
    local taskID = ns.window.planRows[1].task.id
    for _, invalid in ipairs({"", "0", "241", "abc", "1.5", "-1"}) do
        ns.window.budgetInput:SetFocus(); ns.window.budgetInput:SetText(invalid)
        ns.window.applyBudget:Click()
        eq(ns.settings.budget, 120, "invalid input must not change the committed session")
        eq(ns.window.planRows[1].task.id, taskID, "invalid input must preserve the current recommendation")
        contains(ns.window.planSummary:GetText(), "1-240 whole minutes")
        contains(ns.window.planSummary:GetText(), "Current budget: 120 min.")
        ns.Refresh()
        contains(ns.window.planSummary:GetText(), "1-240 whole minutes", "refresh must not hide the validation feedback")
    end
    ns.window.budgetInput:SetText("120"); ns.window.budgetInput:PressEnter()
    contains(ns.window.planSummary:GetText(), "120 of 120 min")
    eq(ns.window.budgetInput:HasFocus(), false)
end)

test("visible refresh preserves a session draft until the player applies it", function()
    local ns, _, s = world(nil, {budget=60}); s:login(); s:open(); s:add("Long run", 120)
    ns.window.budgetInput:SetFocus(); ns.window.budgetInput:SetText("120")
    s.timers[#s.timers].callback()
    eq(ns.window.budgetInput:GetText(), "120", "timer refresh must not overwrite a focused draft")
    eq(ns.settings.budget, 60, "typing alone must not change the committed budget")
    eq(ns.window.planRows[1].task, nil)
    s:event("BAG_UPDATE_DELAYED")
    eq(ns.window.budgetInput:GetText(), "120", "inventory refresh must not overwrite a focused draft")
    ns.window.budgetInput:PressEnter()
    eq(ns.settings.budget, 120); eq(ns.window.planRows[1].task.label, "Long run")
end)

test("presets and reopening synchronize the custom field and clear obsolete feedback", function()
    local ns, env, s = world(nil, {budget=60}); s:login(); s:open(); s:add("Long run", 120)
    ns.window.budgetInput:SetFocus(); ns.window.budgetInput:SetText("0"); ns.window.applyBudget:Click()
    contains(ns.window.planSummary:GetText(), "1-240 whole minutes")
    ns.window.budgets[2]:Click()
    eq(ns.settings.budget, 30); eq(ns.window.budgetInput:GetText(), "30")
    eq(ns.window.budgetInput:HasFocus(), false)
    contains(ns.window.planSummary:GetText(), "Shortest unfinished task: 120 min.")
    ns.window.budgetInput:SetFocus(); ns.window.budgetInput:SetText("180")
    s:open(); s:open()
    eq(ns.settings.budget, 30); eq(ns.window.budgetInput:GetText(), "30", "reopening must show the saved budget")
    eq(ns.window.budgetInput:HasFocus(), false)
    env.SlashCmdList.SESSIONSCOUT("120")
    eq(ns.window.budgetInput:GetText(), "120", "legacy slash budgets must remain visible in the new field")
    eq(ns.window.planRows[1].task.label, "Long run")
end)

test("custom session boundaries persist across login without inventing task changes", function()
    local ns, env, s = world(); s:login(); s:open(); s:add("Four-hour task", 240)
    ns.window.budgetInput:SetText("1"); ns.window.budgetInput:PressEnter()
    eq(ns.settings.budget, 1); eq(ns.window.planRows[1].task, nil)
    ns.window.budgetInput:SetText("240"); ns.window.applyBudget:Click()
    eq(ns.settings.budget, 240); eq(ns.window.planRows[1].task.minutes, 240)
    s:event("PLAYER_LOGOUT")
    local ns2, _, s2 = world(env.SessionScoutDB, env.SessionScoutCharDB); s2:login(); s2:open()
    eq(ns2.settings.budget, 240); eq(ns2.window.budgetInput:GetText(), "240")
    eq(ns2.window.planRows[1].task.label, "Four-hour task")
    eq(#ns2.db.tasks, 1)
end)

test("empty completed and too-long tasks give distinct useful plan guidance", function()
    local ns, _, s = world(nil, {budget=60}); s:login(); s:open()
    contains(ns.window.planSummary:GetText(), "Start with one task")
    s:add("Completed short task", 30); s:row("Completed short task").toggle:Click()
    contains(ns.window.planSummary:GetText(), "All your tasks are complete")
    s:add("Long run", 120)
    contains(ns.window.planSummary:GetText(), "Shortest unfinished task: 120 min.")
    s:row("Long run").toggle:Click()
    contains(ns.window.planSummary:GetText(), "All your tasks are complete")
    eq(ns.window.planRows[1].task, nil)
    s:row("Completed short task").toggle:Click()
    eq(ns.window.planRows[1].task.label, "Completed short task")
end)

test("UI add and edit preserve raw pipe text while rendered labels escape markup", function()
    local ns, _, s = world(); s:login(); s:open()
    local literal = "Collect |cffff0000red|r |Hitem:123|hitem|h"
    s:add(literal, 10); eq(#ns.db.tasks, 1); eq(ns.db.tasks[1].label, literal)
    local row = s:row(literal); contains(row.text:GetText(), "||cffff0000red||r")
    contains(ns.window.planRows[1].text:GetText(), "||Hitem:123||hitem||h")
    local id = row.task.id; row.edit:Click(); eq(ns.window.taskLabel:GetText(), literal)
    ns.window.taskLabel:SetText("Edited | task"); ns.window.minutes:SetText("15"); ns.window.save:Click()
    eq(#ns.db.tasks, 1); eq(ns.db.tasks[1].id, id); eq(ns.db.tasks[1].label, "Edited | task")
    eq(ns.db.tasks[1].minutes, 15); contains(s:row("Edited | task").text:GetText(), "Edited || task")
end)

test("invalid UI task shows feedback and leaves existing tasks unchanged", function()
    local ns, _, s = world(); s:login(); s:open(); s:add("Valid", 10)
    s:add("   ", 10); eq(#ns.db.tasks, 1); ok(#ns.window.feedback:GetText() > 0)
    s:add("Invalid minutes", 0); eq(#ns.db.tasks, 1); contains(ns.window.feedback:GetText(), "Duration")
end)

test("long task labels use bounded rows and full escaped hover tooltips", function()
    local ns, env, s = world(); s:login(); s:open()
    local longLabel = string.rep("Long task ", 9) .. "|cffff0000literal|r"
    s:add(longLabel, 10)
    for _, row in ipairs(ns.window.planRows) do
        eq(row.text.wordWrap, false, "plan label must not wrap into the next row")
        eq(row.text.maxLines, 1); eq(row.text.height, 20)
    end
    for _, row in ipairs(ns.window.taskRows) do
        eq(row.text.wordWrap, false, "task name must not create extra visual lines")
        eq(row.text.maxLines, 1); eq(row.text.height, 14)
        eq(row.metadata.wordWrap, false); eq(row.metadata.maxLines, 1); eq(row.metadata.height, 14)
    end
    local planRow, taskRow = ns.window.planRows[1], s:row(longLabel)
    eq(taskRow.text:GetText():find("\n", 1, true), nil, "a non-wrapping title must not contain newline metadata")
    contains(taskRow.metadata:GetText(), "10m / Medium / Once / Character")
    local escaped = longLabel:gsub("|", "||")
    for _, control in ipairs({planRow.done, taskRow.edit}) do
        control:MouseEnter()
        ok(env.GameTooltip:IsShown()); eq(env.GameTooltip.owner, control)
        eq(env.GameTooltip.lines[1].text, escaped, "tooltip must retain the entire task label literally")
        eq(env.GameTooltip.lines[1].wrap, true, "full tooltip may wrap")
        control:MouseLeave(); eq(env.GameTooltip:IsShown(), false)
    end
    -- The mock records layout limits; actual glyph clipping still requires in-client visual QA.
    eq(ns.db.tasks[1].label, longLabel, "display limits must not truncate saved task names")
    ns.window.planRows[2].done:MouseEnter(); eq(env.GameTooltip:IsShown(), false)
end)

test("UI completion and undo alter the current character only", function()
    local ns, _, s = world(); s:login(); s:open(); s:add("Personal task", 10)
    local row = s:row("Personal task"); local id = row.task.id
    row.toggle:Click(); eq(s:row("Personal task").toggle:GetText(), "Undo")
    ok(ns.Model.IsCompleted(ns.db, id, ns.character, s.now)); eq(ns.Model.IsCompleted(ns.db, id, "Other-Player", s.now), false)
    eq(ns.window.planRows[1].task, nil)
    s:row("Personal task").toggle:Click(); eq(ns.Model.IsCompleted(ns.db, id, ns.character, s.now), false)
    eq(ns.window.planRows[1].task.id, id)
end)

test("shared scope completes across characters and delete requires two clicks", function()
    local ns, _, s = world(); s:login(); s:open(); ns.window.scope:Click(); s:add("Shared task", 10)
    eq(ns.db.tasks[1].scope, "account"); s:row("Shared task").toggle:Click()
    ok(ns.Model.IsCompleted(ns.db, ns.db.tasks[1].id, "Other-Player", s.now))
    local row = s:row("Shared task"); row.remove:Click(); eq(#ns.db.tasks, 1); eq(row.remove:GetText(), "Confirm?")
    row.remove:Click(); eq(#ns.db.tasks, 0); eq(ns.window.taskRows[1].task, nil)
    eq(ns.window.taskRows[1].metadata:GetText(), "", "deleted rows must clear their details")
end)

test("character note persists through typing, hiding, logout and a fresh login", function()
    local ns, env, s = world(); s:login(); s:open(); ns.window.note:SetText("Return to | unusual place")
    eq(ns.settings.note, "Return to | unusual place"); s:open(); s:event("PLAYER_LOGOUT")
    local ns2, _, s2 = world(env.SessionScoutDB, env.SessionScoutCharDB); s2:login(); s2:open()
    eq(ns2.window.note:GetText(), "Return to | unusual place"); eq(#s2.messages, 0)
end)

test("readiness excludes specialty and reagent bags and ignores absent durability", function()
    local ns, env, s = world(); s:login()
    local message = ns.Readiness(); contains(message, "6 free general bag slots"); contains(message, "Lowest durability 25%")
    eq(s.bagCalls, 5); eq(s.durabilityCalls, 19)
    s.combat = true; ns.Readiness(); eq(s.bagCalls, 5); eq(s.durabilityCalls, 19)
    s.combat = false; env.C_Container = false; env.GetInventoryItemDurability = false
    contains(ns.Readiness(), "unavailable")
end)

test("secret and nonfinite readiness values are skipped without arithmetic", function()
    local ns, env, s = world(); local secret = secretMarker(env); s:login()
    env.C_Container.GetContainerNumFreeSlots = function(bag)
        if bag == 0 then return secret, 0 elseif bag == 1 then return 99, secret
        elseif bag == 2 then return math.huge, 0 elseif bag == 3 then return 0/0, 0
        else return 4, 0 end
    end
    env.GetInventoryItemDurability = function(slot)
        if slot == 1 then return secret, 100 elseif slot == 2 then return 50, secret
        elseif slot == 3 then return math.huge, 100 elseif slot == 4 then return 0/0, 100
        elseif slot == 5 then return 20, 100 end
    end
    local message = ns.Readiness()
    contains(message, "4 free general bag slots"); contains(message, "Lowest durability 20%")
end)

test("missing and failing reset APIs do not invent reset timestamps", function()
    local ns, env, s = world(); s:login()
    local resets = ns.ResetTimes(); eq(resets.daily, s.now + 100); eq(resets.weekly, s.now + 1000)
    env.C_DateAndTime = {}; env.GetQuestResetTime = function() return 50 end
    eq(ns.ResetTimes().daily, s.now + 50); eq(ns.ResetTimes().weekly, nil)
    env.GetQuestResetTime = nil; env.C_DateAndTime = {GetSecondsUntilDailyReset=function() error("temporarily unavailable") end,
        GetSecondsUntilWeeklyReset=function() return 0 end}
    eq(ns.ResetTimes().daily, nil); eq(ns.ResetTimes().weekly, nil)
end)

test("invalid primary daily reset uses a validated legacy fallback", function()
    local ns, env, s = world(); local secret = secretMarker(env); s:login()
    local invalid = {0, -1, 0/0, math.huge, -math.huge, secret}
    env.GetQuestResetTime = function() return 50.2 end
    for _, value in ipairs(invalid) do
        env.C_DateAndTime.GetSecondsUntilDailyReset = function() return value end
        local resets = ns.ResetTimes()
        eq(resets.daily, s.now + 51, "invalid primary must allow validated fallback")
    end
    env.C_DateAndTime.GetSecondsUntilDailyReset = function() error("API unavailable") end
    eq(ns.ResetTimes().daily, s.now + 51)
end)

test("secret NaN and infinite resets never create guessed deadlines", function()
    local ns, env, s = world(); local secret = secretMarker(env); s:login()
    env.GetQuestResetTime = nil
    for _, value in ipairs({0/0, math.huge, -math.huge, secret}) do
        env.C_DateAndTime.GetSecondsUntilDailyReset = function() return value end
        env.C_DateAndTime.GetSecondsUntilWeeklyReset = function() return value end
        local resets = ns.ResetTimes(); eq(resets.daily, nil); eq(resets.weekly, nil)
    end
    env.C_DateAndTime.GetSecondsUntilDailyReset = function() return 0 end
    env.GetQuestResetTime = function() return math.huge end
    eq(ns.ResetTimes().daily, nil, "legacy fallback must also reject nonfinite values")
end)

test("legacy daily reset works without C_DateAndTime and never invents a weekly reset", function()
    local ns, env, s = world(); s:login(); s:open()
    env.C_DateAndTime = nil
    env.GetQuestResetTime = function() return 50 end
    local resets = ns.ResetTimes(); eq(resets.daily, s.now + 50); eq(resets.weekly, nil)
    ns.window.recurrence:Click(); s:add("Legacy daily task", 10)
    local dailyID = ns.db.tasks[1].id; s:row("Legacy daily task").toggle:Click()
    ok(ns.Model.IsCompleted(ns.db, dailyID, ns.character, s.now))
    s.now = s.now + 50; ns.Refresh(); eq(ns.Model.IsCompleted(ns.db, dailyID, ns.character, s.now), false)
    ns.window.recurrence:Click(); ns.window.recurrence:Click(); s:add("Unavailable weekly task", 10)
    local weeklyID = ns.db.tasks[2].id; eq(ns.db.tasks[2].recurrence, "weekly")
    s:row("Unavailable weekly task").toggle:Click()
    eq(ns.Model.IsCompleted(ns.db, weeklyID, ns.character, s.now), false)
    contains(s.messages[#s.messages], "reset")
end)

test("unavailable recurrence reset surfaces failure without completing or losing task", function()
    local ns, env, s = world(); s:login(); s:open(); ns.window.recurrence:Click(); s:add("Daily task", 10)
    local id = ns.db.tasks[1].id; eq(ns.db.tasks[1].recurrence, "daily")
    env.C_DateAndTime = {}; env.GetQuestResetTime = nil; s:row("Daily task").toggle:Click()
    eq(ns.Model.IsCompleted(ns.db, id, ns.character, s.now), false); eq(#ns.db.tasks, 1)
    ok(#s.messages > 1, "reset failure must reach user"); contains(s.messages[#s.messages], "reset")
end)

test("daily completion expires at the server boundary during visible refresh", function()
    local ns, _, s = world(); s:login(); s:open(); ns.window.recurrence:Click(); s:add("Daily task", 10)
    local id = ns.db.tasks[1].id; s:row("Daily task").toggle:Click()
    s.now = s.now + 99; s.timers[#s.timers].callback(); ok(ns.Model.IsCompleted(ns.db, id, ns.character, s.now))
    s.now = s.now + 1; s.timers[#s.timers].callback(); eq(ns.Model.IsCompleted(ns.db, id, ns.character, s.now), false)
    eq(ns.window.planRows[1].task.id, id)
end)

print(string.format("Integration: %d passed, %d failed", passed, failed))
if failed > 0 then error("Integration tests failed: " .. failed) end
