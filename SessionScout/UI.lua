local _, ns = ...
local M = ns.Model
local accent = { 0.32, 0.85, 0.73 }
local recurrenceNames = { once = "Once", daily = "Daily", weekly = "Weekly" }
local priorityNames = { "High", "Medium", "Low" }
local page, editID, taskFilter = 1, nil, "unfinished"
local form = { recurrence = "once", scope = "character", priority = 2 }

local function label(parent, text, x, y, size, width)
    local f = parent:CreateFontString(nil, "OVERLAY", size or "GameFontNormal")
    f:SetPoint("TOPLEFT", x, y)
    if width then f:SetWidth(width); f:SetJustifyH("LEFT") end
    f:SetText(text)
    return f
end

local function boundedLabel(parent, text, x, y, size, width, height, lines)
    local f = label(parent, text, x, y, size, width)
    f:SetWordWrap(lines > 1); f:SetMaxLines(lines); f:SetHeight(height)
    return f
end

local function button(parent, text, x, y, width, callback)
    local b = CreateFrame("Button", nil, parent, "UIPanelButtonTemplate")
    b:SetSize(width, 24); b:SetPoint("TOPLEFT", x, y); b:SetText(text)
    b:SetScript("OnClick", callback)
    return b
end

local function entry(parent, x, y, width, limit)
    local e = CreateFrame("EditBox", nil, parent, "InputBoxTemplate")
    e:SetSize(width, 24); e:SetPoint("TOPLEFT", x, y)
    e:SetAutoFocus(false); e:SetMaxLetters(limit)
    e:SetScript("OnEscapePressed", function(self) self:ClearFocus() end)
    e:SetScript("OnEnterPressed", function(self) self:ClearFocus() end)
    return e
end

local function panel(parent, x, y, width, height, background)
    local f = CreateFrame("Frame", nil, parent, background and "BackdropTemplate" or nil)
    f:SetPoint("TOPLEFT", x, y); f:SetSize(width, height)
    if background then
        f:SetBackdrop({ bgFile = "Interface\\Buttons\\WHITE8X8", edgeFile = "Interface\\Buttons\\WHITE8X8", edgeSize = 1 })
        f:SetBackdropColor(0.075, 0.105, 0.125, 1); f:SetBackdropBorderColor(0.16, 0.27, 0.3, 1)
    end
    return f
end

local function taskTooltip(control, row)
    control:HookScript("OnEnter", function(self)
        if row.task and GameTooltip then
            GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
            GameTooltip:AddLine(ns.SafeText(row.task.label), 1, 1, 1, true)
            GameTooltip:Show()
        end
    end)
    control:HookScript("OnLeave", function() if GameTooltip then GameTooltip:Hide() end end)
end

local function clearFocus()
    local w = ns.window
    for _, name in ipairs({ "budgetInput", "taskLabel", "minutes", "note" }) do
        if w[name] then w[name]:ClearFocus() end
    end
    if GameTooltip then GameTooltip:Hide() end
end

local function updateViews()
    local w = ns.window
    w.sessionView:SetShown(w.view == "session")
    w.tasksView:SetShown(w.view == "tasks")
    w.taskList:SetShown(not w.editorOpen)
    w.editor:SetShown(w.editorOpen == true)
    w.sessionTab:SetText(w.view == "session" and "|cff52d9bbThis session|r" or "This session")
    w.tasksTab:SetText(w.view == "tasks" and "|cff52d9bbMy tasks|r" or "My tasks")
end

local updateForm

local function showView(view)
    clearFocus()
    local w = ns.window
    w.view = view
    if w.pendingDelete then w.feedback:SetText("") end
    w.pendingDelete = nil
    -- View changes retain an editor draft, but never retain an armed deletion.
    updateForm(); updateViews(); ns.Refresh()
end

updateForm = function()
    local w = ns.window
    w.editorTitle:SetText(editID and "Edit task" or "New task")
    w.recurrence:SetText(recurrenceNames[form.recurrence] .. " >")
    w.scope:SetText((form.scope == "account" and "Shared across characters" or "Separate for each character") .. " >")
    w.priority:SetText(priorityNames[form.priority] .. " >")
    w.save:SetText(editID and "Save changes" or "Add task")
    w.remove:SetShown(editID ~= nil)
    w.remove:SetText(w.pendingDelete == editID and editID and "Confirm delete" or "Delete task")
end

local function resetForm()
    local w = ns.window
    editID = nil; form = { recurrence = "once", scope = "character", priority = 2 }
    w.taskLabel:SetText(""); w.minutes:SetText("10")
    w.feedback:SetText(""); w.pendingDelete = nil; updateForm()
end

local function closeEditor()
    clearFocus(); resetForm()
    ns.window.editorOpen = false
    updateViews(); ns.Refresh()
end

local function newTask()
    clearFocus()
    local w = ns.window
    -- An empty-state shortcut must not replace an edit parked on the other view.
    if not w.editorOpen then resetForm() end
    w.view = "tasks"; w.editorOpen = true
    updateViews(); ns.Refresh(); w.taskLabel:SetFocus()
end

local function editTask(task)
    clearFocus()
    local w = ns.window
    editID = task.id
    form = { recurrence = task.recurrence, scope = task.scope, priority = task.priority }
    w.taskLabel:SetText(task.label); w.minutes:SetText(tostring(task.minutes))
    w.feedback:SetText(""); w.pendingDelete = nil; w.editorOpen = true
    updateForm(); updateViews(); w.taskLabel:SetFocus()
end

local function saveTask()
    local w = ns.window
    local task = { label = w.taskLabel:GetText(), minutes = tonumber(w.minutes:GetText()), priority = form.priority,
        recurrence = form.recurrence, scope = form.scope }
    local result, err
    if editID then result, err = M.UpdateTask(ns.db, editID, task) else result, err = M.AddTask(ns.db, task) end
    if not result then w.feedback:SetText(ns.SafeText(err or "Check the task fields.")); return end
    -- Reveal the saved task even when it belongs to another page or completion filter.
    w.revealTaskID = result.id
    closeEditor()
end

local function syncBudget()
    local w = ns.window
    w.syncingBudget = true; w.budgetInput:SetText(tostring(ns.settings.budget)); w.syncingBudget = nil
    w.budgetDirty = nil
end

local function setBudget(minutes)
    local w = ns.window
    ns.settings.budget = minutes
    w.budgetError = nil; w.budgetInput:ClearFocus(); syncBudget(); ns.Refresh()
end

local function applyBudget()
    local w = ns.window
    local minutes = tonumber(w.budgetInput:GetText())
    if not minutes or minutes ~= minutes or minutes < 1 or minutes > M.MAX_BUDGET_MINUTES
        or minutes ~= math.floor(minutes) then
        w.budgetError = "Enter 1-240 whole minutes. Current budget: " .. ns.settings.budget .. " min."
        w.budgetInput:SetFocus(); ns.Refresh(); return
    end
    setBudget(minutes)
end

local function selectFilter(value)
    if taskFilter ~= value then page = 1 end
    taskFilter = value; ns.window.pendingDelete = nil; ns.Refresh()
end

function ns.SaveNote()
    if ns.window and ns.settings then ns.settings.note = ns.window.note:GetText() end
end

function ns.CreateWindow()
    local w = CreateFrame("Frame", "SessionScoutWindow", UIParent, "BackdropTemplate")
    ns.window = w; w.view = "session"
    w:Hide(); w:SetSize(660, 620); w:SetPoint("CENTER")
    w:SetClampedToScreen(true); w:SetMovable(true); w:EnableMouse(true)
    w:SetFrameStrata("DIALOG"); w:SetToplevel(true)
    w:SetScale(math.min(1, (UIParent:GetHeight() - 40) / 620))
    w:SetBackdrop({ bgFile = "Interface\\Buttons\\WHITE8X8", edgeFile = "Interface\\Buttons\\WHITE8X8", edgeSize = 1 })
    w:SetBackdropColor(0.045, 0.065, 0.085, 0.98); w:SetBackdropBorderColor(0.2, 0.35, 0.39, 1)
    w:RegisterForDrag("LeftButton")
    w:SetScript("OnDragStart", w.StartMoving); w:SetScript("OnDragStop", w.StopMovingOrSizing)
    w:SetScript("OnHide", ns.SaveNote)
    -- Only a visible planner is refreshed; no background polling or per-frame work.
    w:SetScript("OnShow", function()
        w:Raise()
        if C_Timer and C_Timer.NewTicker then w.ticker = C_Timer.NewTicker(30, ns.Refresh) end
    end)
    w:HookScript("OnHide", function()
        if w.ticker then w.ticker:Cancel(); w.ticker = nil end
        clearFocus(); syncBudget(); w.budgetError = nil
        if w.pendingDelete then w.feedback:SetText("") end
        w.pendingDelete = nil; updateForm()
    end)
    UISpecialFrames[#UISpecialFrames + 1] = "SessionScoutWindow"
    local title = label(w, "SessionScout", 22, -20, "GameFontNormalLarge")
    title:SetTextColor(unpack(accent))
    label(w, "Choose your next activity from your own tasks.", 22, -46, "GameFontHighlight")
    button(w, "Close", 574, -18, 64, function() w:Hide() end)
    w.sessionTab = button(w, "This session", 22, -72, 142, function() showView("session") end)
    w.tasksTab = button(w, "My tasks", 174, -72, 142, function() showView("tasks") end)
    w.sessionView = panel(w, 0, -108, 660, 490)
    w.tasksView = panel(w, 0, -108, 660, 490)
    local session = w.sessionView
    label(session, "How much time do you have?", 22, -4)
    label(session, "Custom minutes", 424, -4, "GameFontHighlightSmall")
    w.budgets = {}
    for i, minutes in ipairs({ 15, 30, 60 }) do
        w.budgets[i] = button(session, minutes .. " min", 22 + (i - 1) * 86, -28, 78, function() setBudget(minutes) end)
    end
    w.budgetInput = entry(session, 430, -28, 70, 3); w.budgetInput:SetNumeric(true)
    w.budgetInput:SetText(tostring(ns.settings.budget))
    w.budgetInput:SetScript("OnTextChanged", function(self)
        if not w.syncingBudget then w.budgetDirty = self:GetText() ~= tostring(ns.settings.budget) end
    end)
    w.budgetInput:SetScript("OnEnterPressed", applyBudget)
    w.budgetInput:SetScript("OnEscapePressed", function(self)
        self:ClearFocus(); syncBudget(); w.budgetError = nil; ns.Refresh()
    end)
    w.applyBudget = button(session, "Apply", 514, -28, 120, applyBudget)
    w.planSummary = boundedLabel(session, "", 22, -72, "GameFontHighlight", 612, 32, 2)
    w.planExplanation = label(session, "Based on your saved estimates and priorities.", 22, -108, "GameFontDisableSmall", 612)
    w.planRows = {}
    for i = 1, 3 do
        local row = {}
        row.container = panel(session, 22, -134 - (i - 1) * 70, 612, 62, true)
        row.text = boundedLabel(row.container, "", 12, -9, "GameFontHighlight", 480, 20, 1)
        row.metadata = boundedLabel(row.container, "", 12, -36, "GameFontHighlightSmall", 480, 16, 1)
        row.done = button(row.container, "Done", 514, -19, 86, function() if row.task then ns.Complete(row.task.id) end end)
        row.container:EnableMouse(true); taskTooltip(row.container, row); taskTooltip(row.done, row)
        w.planRows[i] = row
    end
    w.emptyPlan = panel(session, 22, -134, 612, 202, true)
    w.emptyTitle = boundedLabel(w.emptyPlan, "", 14, -14, "GameFontNormalLarge", 584, 24, 1)
    w.emptyTask = boundedLabel(w.emptyPlan, "", 14, -50, "GameFontHighlight", 584, 44, 2)
    w.emptyDetails = boundedLabel(w.emptyPlan, "", 14, -104, "GameFontHighlightSmall", 584, 38, 2)
    w.emptyPrimary = button(w.emptyPlan, "Add task", 14, -160, 148, function()
        if w.emptyMode == "empty" then newTask()
        else
            if w.emptyMode == "no-fit" then w.revealTaskID = w.shortestTaskID end
            showView("tasks")
            selectFilter(w.emptyMode == "complete" and "completed" or "unfinished")
        end
    end)
    w.emptySecondary = button(w.emptyPlan, "Change time", 174, -160, 148, function()
        if w.emptyMode == "complete" then newTask() else w.budgetInput:SetFocus() end
    end)
    w.noteLabel = label(session, "Next time, remember...", 22, -360, "GameFontNormal")
    w.note = entry(session, 30, -384, 600, 500); w.note:SetText(ns.settings.note)
    w.note:SetScript("OnTextChanged", ns.SaveNote)
    w.noteHelp = label(session, "This reminder is saved for your current character.", 22, -416, "GameFontDisableSmall", 612)
    w.readiness = label(session, "", 22, -450, "GameFontHighlightSmall", 612)

    local tasks = w.tasksView
    w.taskList = panel(tasks, 0, 0, 660, 490)
    w.unfinishedFilter = button(w.taskList, "Unfinished", 22, -4, 160, function() selectFilter("unfinished") end)
    w.completedFilter = button(w.taskList, "Completed", 192, -4, 160, function() selectFilter("completed") end)
    w.newTask = button(w.taskList, "+ New task", 492, -4, 142, newTask)
    w.taskRows = {}
    for i = 1, 5 do
        local row = {}
        row.container = panel(w.taskList, 22, -50 - (i - 1) * 54, 612, 48, true)
        row.text = boundedLabel(row.container, "", 12, -7, "GameFontHighlight", 420, 18, 1)
        -- Separate lines avoid the Forever client's non-wrapping newline suppression.
        row.metadata = boundedLabel(row.container, "", 12, -28, "GameFontHighlightSmall", 420, 14, 1)
        row.toggle = button(row.container, "Done", 440, -12, 74, function()
            if not row.task then return end
            if row.task.completed then
                local ok, err = M.ResetTask(ns.db, row.task.id, ns.character)
                if not ok then ns.Message(err or "Could not undo completion.") end
                ns.Refresh()
            else ns.Complete(row.task.id) end
        end)
        row.edit = button(row.container, "Edit", 522, -12, 78, function() if row.task then editTask(row.task) end end)
        row.container:EnableMouse(true); taskTooltip(row.container, row); taskTooltip(row.edit, row)
        w.taskRows[i] = row
    end
    w.taskListEmpty = boundedLabel(w.taskList, "", 26, -64, "GameFontHighlight", 600, 60, 3)
    w.previousPage = button(w.taskList, "Previous", 22, -330, 96, function() page = math.max(1, page - 1); ns.Refresh() end)
    w.nextPage = button(w.taskList, "Next", 128, -330, 96, function() page = math.min(w.pageCount or 1, page + 1); ns.Refresh() end)
    w.pageText = label(w.taskList, "", 244, -336, "GameFontHighlightSmall", 390)
    boundedLabel(w.taskList, "Task definitions are shared across characters. Completion follows each task's setting.", 22, -376, "GameFontHighlightSmall", 612, 36, 2)
    boundedLabel(w.taskList, "Estimates and completion are manual. Daily and weekly tasks reset with the server.", 22, -436, "GameFontDisableSmall", 612, 36, 2)

    w.editor = panel(tasks, 0, 0, 660, 490)
    w.editorTitle = label(w.editor, "New task", 22, -4, "GameFontNormalLarge")
    label(w.editor, "Task name", 22, -46, "GameFontHighlight")
    w.taskLabel = entry(w.editor, 30, -70, 600, 120)
    label(w.editor, "Estimated minutes", 22, -112, "GameFontHighlight")
    w.minutes = entry(w.editor, 30, -136, 100, 3); w.minutes:SetNumeric(true); w.minutes:SetText("10")
    label(w.editor, "Priority", 190, -112, "GameFontHighlight")
    w.priority = button(w.editor, "Medium >", 190, -136, 144, function() form.priority = form.priority % 3 + 1; updateForm() end)
    label(w.editor, "Repeat", 364, -112, "GameFontHighlight")
    w.recurrence = button(w.editor, "Once >", 364, -136, 144, function()
        form.recurrence = ({ once = "daily", daily = "weekly", weekly = "once" })[form.recurrence]; updateForm()
    end)
    label(w.editor, "Completion", 22, -184, "GameFontHighlight")
    w.scope = button(w.editor, "Separate for each character >", 22, -208, 282, function()
        form.scope = form.scope == "character" and "account" or "character"; updateForm()
    end)
    label(w.editor, "Click a choice to cycle its options.", 22, -246, "GameFontDisableSmall", 612)
    boundedLabel(w.editor, "Task definitions are shared. Editing or deleting a task affects every character. Completion can be separate or shared.", 22, -282, "GameFontHighlightSmall", 612, 42, 3)
    w.feedback = boundedLabel(w.editor, "", 22, -336, "GameFontHighlight", 612, 38, 2)
    w.save = button(w.editor, "Add task", 22, -390, 154, saveTask)
    w.cancel = button(w.editor, "Cancel", 188, -390, 110, closeEditor)
    w.remove = button(w.editor, "Delete task", 494, -390, 140, function()
        if not editID then return end
        if w.pendingDelete == editID then
            local ok, err = M.DeleteTask(ns.db, editID)
            if not ok then w.feedback:SetText(ns.SafeText(err or "Could not delete this task.")); return end
            closeEditor()
        else
            w.pendingDelete = editID
            w.feedback:SetText("Delete this task for every character? Click Confirm delete, or Cancel to keep it.")
            updateForm()
        end
    end)
    w.taskLabel:SetScript("OnEnterPressed", function() w.taskLabel:ClearFocus(); w.minutes:SetFocus() end)
    w.minutes:SetScript("OnEnterPressed", saveTask)
    updateForm(); updateViews()
end

function ns.Render()
    local w = ns.window
    if not w or not ns.character then return end
    local budget = ns.settings.budget
    local plan, err = M.BuildPlan(ns.db, ns.character, ns.Now(), budget)
    local tasks = M.ListTasks(ns.db, ns.character, ns.Now())
    if not w.budgetDirty and not w.budgetInput:HasFocus() then syncBudget() end
    for i, minutes in ipairs({ 15, 30, 60 }) do
        w.budgets[i]:SetText((budget == minutes and "|cff52d9bb" or "") .. minutes .. " min" .. (budget == minutes and "|r" or ""))
    end
    if not plan then w.planSummary:SetText(ns.SafeText(err)); return end
    local count, shortest, unfinished, completed = math.min(3, #plan.tasks), nil, 0, 0
    for _, task in ipairs(tasks) do
        if task.completed then completed = completed + 1 else
            unfinished = unfinished + 1
            if not shortest or task.minutes < shortest.minutes then shortest = task end
        end
    end
    -- Keep a single recommendation close to its reminder instead of reserving two empty cards.
    local offset = count > 0 and (3 - count) * 70 or 0
    local height = w.view == "session" and 620 - offset or 620
    w:SetHeight(height); w:SetScale(math.min(1, (UIParent:GetHeight() - 40) / height))
    w.sessionView:SetHeight(490 - offset)
    for _, position in ipairs({
        {w.noteLabel, 22, -360}, {w.note, 30, -384},
        {w.noteHelp, 22, -416}, {w.readiness, 22, -450},
    }) do
        position[1]:ClearAllPoints(); position[1]:SetPoint("TOPLEFT", position[2], position[3] + offset)
    end
    w.shortestTaskID = shortest and shortest.id
    w.emptyPlan:SetShown(count == 0)
    w.planExplanation:SetShown(count > 0)
    if #tasks == 0 then
        w.emptyMode = "empty"
        w.planSummary:SetText("Start with one task for this session.")
        w.emptyTitle:SetText("What would make this session worthwhile?")
        w.emptyTask:SetText("Add an activity you want to do and an honest estimate of how long it takes.")
        w.emptyDetails:SetText("SessionScout chooses from your tasks. It does not discover quests or activities for you.")
        w.emptyPrimary:SetText("Add task"); w.emptySecondary:Hide()
    elseif not shortest then
        w.emptyMode = "complete"
        w.planSummary:SetText("All your tasks are complete.")
        w.emptyTitle:SetText("You're up to date")
        w.emptyTask:SetText("Add another task, or view completed tasks to undo a completion.")
        w.emptyDetails:SetText("Daily and weekly tasks become unfinished again at their recorded server reset.")
        w.emptyPrimary:SetText("View completed"); w.emptySecondary:SetText("Add task"); w.emptySecondary:Show()
    elseif count == 0 then
        w.emptyMode = "no-fit"
        w.planSummary:SetText("No task fits " .. budget .. " min. Shortest unfinished task: " .. shortest.minutes .. " min.")
        w.emptyTitle:SetText("Your shortest unfinished task")
        w.emptyTask:SetText(ns.SafeText(shortest.label))
        w.emptyDetails:SetText(shortest.minutes .. " min estimated. Your available time is still " .. budget .. " min.\nView your tasks, or change the time if you have longer.")
        w.emptyPrimary:SetText("View tasks"); w.emptySecondary:SetText("Change time"); w.emptySecondary:Show()
    else
        w.emptyMode = nil
        w.planSummary:SetText(count .. (count == 1 and " next action / " or " next actions / ") .. plan.totalMinutes .. " of " .. budget .. " min.")
    end
    if count == 0 and w.editorOpen then
        w.emptyPrimary:SetText("Resume draft")
        if w.emptyMode == "complete" then w.emptySecondary:Hide() end
    end
    if w.budgetError then w.planSummary:SetText(w.budgetError) end
    for i, row in ipairs(w.planRows) do
        local task = plan.tasks[i]; row.task = task
        row.container:SetShown(task ~= nil)
        row.text:SetText(task and (i .. ". " .. ns.SafeText(task.label)) or "")
        row.metadata:SetText(task and (task.minutes .. " min estimated  /  " .. priorityNames[task.priority] .. " priority") or "")
    end
    w.readiness:SetText(ns.Readiness())

    if w.revealTaskID then
        for _, task in ipairs(tasks) do
            if task.id == w.revealTaskID then taskFilter = task.completed and "completed" or "unfinished"; break end
        end
    end
    local filtered = {}
    for _, task in ipairs(tasks) do
        if task.completed == (taskFilter == "completed") then
            filtered[#filtered + 1] = task
            if task.id == w.revealTaskID then page = math.ceil(#filtered / 5) end
        end
    end
    w.revealTaskID = nil
    w.unfinishedFilter:SetText((taskFilter == "unfinished" and "|cff52d9bb" or "") .. "Unfinished (" .. unfinished .. ")" .. (taskFilter == "unfinished" and "|r" or ""))
    w.completedFilter:SetText((taskFilter == "completed" and "|cff52d9bb" or "") .. "Completed (" .. completed .. ")" .. (taskFilter == "completed" and "|r" or ""))
    w.pageCount = math.max(1, math.ceil(#filtered / 5)); page = math.min(page, w.pageCount)
    w.pageText:SetText("Page " .. page .. " / " .. w.pageCount .. "  (" .. #filtered .. " " .. taskFilter .. ")")
    w.previousPage:SetShown(page > 1); w.nextPage:SetShown(page < w.pageCount)
    w.taskListEmpty:SetShown(#filtered == 0)
    w.taskListEmpty:SetText(taskFilter == "completed" and "No completed tasks yet. Finish a task to find it here." or "No unfinished tasks. Add a task, or view completed tasks to undo one.")
    for i, row in ipairs(w.taskRows) do
        local task = filtered[(page - 1) * 5 + i]; row.task = task
        row.container:SetShown(task ~= nil)
        row.text:SetText(task and ns.SafeText(task.label) or "")
        row.metadata:SetText(task and (task.minutes .. " min / " .. priorityNames[task.priority] .. " / " .. recurrenceNames[task.recurrence] .. " / " .. (task.scope == "account" and "Shared completion" or "Per character")) or "")
        if task then row.toggle:SetText(task.completed and "Undo" or "Done") end
    end
end
