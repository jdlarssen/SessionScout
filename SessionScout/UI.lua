local _, ns = ...
local M = ns.Model
local accent = { 0.32, 0.85, 0.73 }
local recurrenceNames = { once = "Once", daily = "Daily", weekly = "Weekly" }
local priorityNames = { "High", "Medium", "Low" }
local page, editID, taskFilter = 1, nil, "unfinished"
local form = { recurrence = "once", scope = "character", priority = 2 }

local function guideFor(task)
    local guides = ns.settings and ns.settings.taskGuides
    return task and type(guides) == "table" and guides[task.id] == "librarian-books"
end

local function openBookGuide()
    local guide = _G.Librarian
    if type(guide) ~= "table" or type(guide.OpenJournal) ~= "function"
        or type(guide.db) ~= "table" or type(guide.char) ~= "table" then
        ns.Message("Book guide needs Librarian Books Forever enabled. After a new installation, restart WoW if it is missing from AddOns.")
        return
    end
    local ok = pcall(guide.OpenJournal, guide)
    if not ok then ns.Message("Librarian could not open its book guide. Your task is unchanged.")
    elseif ns.window and ns.window:IsShown() then ns.window:Hide() end
end

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
    w.tasksView:SetShown(w.view ~= "session")
    w.taskList:SetShown(w.view == "choose" or not w.editorOpen)
    w.editor:SetShown(w.view == "tasks" and w.editorOpen == true)
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
    w.guide:SetText(form.guide and "Guide: Library books >" or "Guide: None >")
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
    form = { recurrence = task.recurrence, scope = task.scope, priority = task.priority, guide = guideFor(task) }
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
    if form.guide then
        if type(ns.settings.taskGuides) ~= "table" then ns.settings.taskGuides = {} end
        ns.settings.taskGuides[result.id] = "librarian-books"
    elseif type(ns.settings.taskGuides) == "table" then ns.settings.taskGuides[result.id] = nil end
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

local function chooseTask()
    page = 1; taskFilter = "unfinished"
    -- The picker leaves a parked editor draft intact and offers no editing actions.
    showView("choose")
end

local function pickTask(task)
    if not task then return end
    local ok, err = ns.ChooseTask(task.id)
    if ok then showView("session") else ns.Message(err or "Could not choose this task.") end
end

function ns.SaveNote()
    if ns.window and ns.settings then ns.settings.note = ns.window.note:GetText() end
end

local trackerAnchors = { TOPLEFT=true, TOP=true, TOPRIGHT=true, LEFT=true, CENTER=true,
    RIGHT=true, BOTTOMLEFT=true, BOTTOM=true, BOTTOMRIGHT=true }

local function validPosition(position)
    return type(position) == "table" and trackerAnchors[position.point] and trackerAnchors[position.relativePoint]
        and type(position.x) == "number" and position.x == position.x and math.abs(position.x) < 100000
        and type(position.y) == "number" and position.y == position.y and math.abs(position.y) < 100000
end

local function updateTrackerTicker(t)
    -- A recurring completion can expire while the planner is closed and no
    -- inventory event fires. Only its visible confirmation needs timed refresh.
    local needsRefresh = t:IsVisible() and t.completed and t.task and t.task.recurrence ~= "once"
    if needsRefresh and C_Timer and C_Timer.NewTicker then
        if not t.ticker then t.ticker = C_Timer.NewTicker(30, ns.Refresh) end
    elseif t.ticker then
        t.ticker:Cancel(); t.ticker = nil
    end
end

local function createTracker()
    local t = CreateFrame("Frame", "SessionScoutTracker", UIParent, "BackdropTemplate")
    ns.tracker = t; t:Hide(); t:SetSize(320, 160)
    t:SetScript("OnShow", updateTrackerTicker)
    t:SetScript("OnHide", function(self)
        if self.ticker then self.ticker:Cancel(); self.ticker = nil end
    end)
    t:SetClampedToScreen(true); t:SetMovable(true); t:EnableMouse(true); t:SetFrameStrata("MEDIUM")
    t:SetScale(math.min(1, (UIParent:GetHeight() - 40) / 160))
    local position = ns.settings.trackerPosition
    if validPosition(position) then
        t:SetPoint(position.point, UIParent, position.relativePoint, position.x, position.y)
    else t:SetPoint("TOPRIGHT", UIParent, "TOPRIGHT", -380, -260) end
    t:SetBackdrop({ bgFile="Interface\\Buttons\\WHITE8X8", edgeFile="Interface\\Buttons\\WHITE8X8", edgeSize=1 })
    t:SetBackdropColor(0.045, 0.065, 0.085, 0.94); t:SetBackdropBorderColor(0.2, 0.35, 0.39, 1)
    t:RegisterForDrag("LeftButton")
    t:SetScript("OnDragStart", t.StartMoving)
    t:SetScript("OnDragStop", function(self)
        self:StopMovingOrSizing()
        local point, relative, relativePoint, x, y = self:GetPoint(1)
        local saved = {point=point, relativePoint=relativePoint, x=x, y=y}
        if (relative == UIParent or relative == nil) and validPosition(saved) then ns.settings.trackerPosition = saved end
    end)
    t.heading = label(t, "Your chosen task", 12, -10, "GameFontNormal", 258)
    t.heading:SetTextColor(unpack(accent))
    t.text = boundedLabel(t, "", 12, -34, "GameFontHighlight", 296, 38, 2)
    t.detail = boundedLabel(t, "", 12, -79, "GameFontHighlightSmall", 296, 30, 2)
    t.open = button(t, "Open Scout", 12, -122, 142, function()
        local completed = ns.trackerCompletedID ~= nil and ns.GetChosenTask() == nil
        if not ns.window or not ns.window:IsShown() then ns.Toggle() end
        if ns.window and ns.window:IsShown() then
            if completed then
                local unfinished = false
                for _, task in ipairs(M.ListTasks(ns.db, ns.character, ns.Now())) do
                    if not task.completed then unfinished = true; break end
                end
                if unfinished then chooseTask() else newTask() end
            else showView("session") end
        end
    end)
    t.done = button(t, "Done", 166, -122, 142, function()
        if not t.task then return end
        if t.completed then
            local id = t.task.id
            local ok, err = M.ResetTask(ns.db, id, ns.character)
            if ok then ns.trackerCompletedID = nil; ns.ChooseTask(id)
            else ns.Message(err or "Could not undo this task.") end
        else
            local id = t.task.id
            if ns.Complete(id) then ns.trackerCompletedID = id; ns.Refresh() end
        end
    end)
    t.guide = button(t, "Book guide", 12, -112, 296, openBookGuide)
    t.close = button(t, "x", 284, -5, 24, function() ns.trackerCompletedID = nil; ns.Refresh() end)
    taskTooltip(t, t); taskTooltip(t.done, t); taskTooltip(t.open, t)
    return t
end

function ns.RenderTracker()
    local task = ns.GetChosenTask()
    local completed = false
    if task then ns.trackerCompletedID = nil
    elseif ns.db and ns.character and ns.trackerCompletedID then
        task = M.GetTask(ns.db, ns.trackerCompletedID)
        completed = task and M.IsCompleted(ns.db, task.id, ns.character, ns.Now()) == true
        if not completed then task = nil; ns.trackerCompletedID = nil end
    end
    if not task or (ns.window and ns.window:IsShown()) then
        if ns.tracker then ns.tracker.task = nil; ns.tracker:Hide() end
        return
    end
    local t = ns.tracker or createTracker()
    t.task, t.completed = task, completed
    t.heading:SetText(completed and "Task completed" or "Your chosen task")
    t.text:SetText(ns.SafeText(task.label))
    t.detail:SetText(completed and "Choose another task when you are ready."
        or (task.minutes .. " min estimated.\nMark Done when you have finished."))
    t.open:SetText(completed and "Choose next" or "Open Scout")
    t.done:SetText(completed and "Undo" or "Done")
    local hasGuide = guideFor(task) and not completed
    t.guide:SetShown(hasGuide)
    local controlsY = hasGuide and -148 or -122
    for _, control in ipairs({t.open, t.done}) do
        control:ClearAllPoints(); control:SetPoint("TOPLEFT", control == t.open and 12 or 166, controlsY)
    end
    t:SetHeight(hasGuide and 184 or 160)
    t:SetScale(math.min(1, (UIParent:GetHeight() - 40) / (hasGuide and 184 or 160)))
    if hasGuide then t.detail:SetText("Use Book guide to check what remains.\nMark Done when your own goal is reached.") end
    t.close:SetShown(completed); t:Show(); updateTrackerTicker(t)
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
    -- Refresh the planner only while visible; no per-frame work.
    w:SetScript("OnShow", function()
        w:Raise()
        if ns.tracker then ns.tracker:Hide() end
        if C_Timer and C_Timer.NewTicker then w.ticker = C_Timer.NewTicker(30, ns.Refresh) end
    end)
    w:HookScript("OnHide", function()
        if w.ticker then w.ticker:Cancel(); w.ticker = nil end
        clearFocus(); syncBudget(); w.budgetError = nil
        if w.pendingDelete then w.feedback:SetText("") end
        w.pendingDelete = nil; updateForm()
        ns.Refresh()
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
    w.planExplanation = label(session, "Suggestions based on estimates and priorities.", 22, -114, "GameFontDisableSmall", 296)
    w.showSuggestions = button(session, "Use suggestions", 326, -108, 144, function() ns.ClearChoice() end)
    w.chooseTask = button(session, "Choose myself", 480, -108, 154, chooseTask)
    w.planRows = {}
    for i = 1, 3 do
        local row = {}
        row.container = panel(session, 22, -134 - (i - 1) * 70, 612, 62, true)
        row.text = boundedLabel(row.container, "", 12, -9, "GameFontHighlight", 400, 20, 1)
        row.metadata = boundedLabel(row.container, "", 12, -36, "GameFontHighlightSmall", 400, 16, 1)
        row.choose = button(row.container, "Choose", 426, -19, 80, function() pickTask(row.task) end)
        row.done = button(row.container, "Done", 514, -19, 86, function() if row.task then ns.Complete(row.task.id) end end)
        row.guide = button(row.container, "Book guide", 418, -19, 92, openBookGuide)
        row.container:EnableMouse(true); taskTooltip(row.container, row); taskTooltip(row.done, row); taskTooltip(row.choose, row)
        w.planRows[i] = row
    end
    w.emptyPlan = panel(session, 22, -134, 612, 202, true)
    w.emptyTitle = boundedLabel(w.emptyPlan, "", 14, -14, "GameFontNormalLarge", 584, 24, 1)
    w.emptyTask = boundedLabel(w.emptyPlan, "", 14, -50, "GameFontHighlight", 584, 44, 2)
    w.emptyDetails = boundedLabel(w.emptyPlan, "", 14, -104, "GameFontHighlightSmall", 584, 38, 2)
    w.emptyPrimary = button(w.emptyPlan, "Add task", 14, -160, 148, function()
        if w.emptyMode == "empty" then newTask()
        elseif w.emptyMode == "no-fit" then chooseTask()
        else
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
    w.chooseBack = button(w.taskList, "Back", 492, -4, 142, function() showView("session") end)
    w.taskRows = {}
    for i = 1, 5 do
        local row = {}
        row.container = panel(w.taskList, 22, -50 - (i - 1) * 54, 612, 48, true)
        row.text = boundedLabel(row.container, "", 12, -7, "GameFontHighlight", 324, 18, 1)
        -- Separate lines avoid the Forever client's non-wrapping newline suppression.
        row.metadata = boundedLabel(row.container, "", 12, -28, "GameFontHighlightSmall", 324, 14, 1)
        row.choose = button(row.container, "Choose", 356, -12, 76, function() pickTask(row.task) end)
        row.toggle = button(row.container, "Done", 440, -12, 74, function()
            if not row.task then return end
            if row.task.completed then
                local ok, err = M.ResetTask(ns.db, row.task.id, ns.character)
                if not ok then ns.Message(err or "Could not undo completion.") end
                ns.Refresh()
            else ns.Complete(row.task.id) end
        end)
        row.edit = button(row.container, "Edit", 522, -12, 78, function() if row.task then editTask(row.task) end end)
        row.container:EnableMouse(true); taskTooltip(row.container, row); taskTooltip(row.edit, row); taskTooltip(row.choose, row)
        w.taskRows[i] = row
    end
    w.taskListEmpty = boundedLabel(w.taskList, "", 26, -64, "GameFontHighlight", 600, 60, 3)
    w.previousPage = button(w.taskList, "Previous", 22, -330, 96, function() page = math.max(1, page - 1); ns.Refresh() end)
    w.nextPage = button(w.taskList, "Next", 128, -330, 96, function() page = math.min(w.pageCount or 1, page + 1); ns.Refresh() end)
    w.pageText = label(w.taskList, "", 244, -336, "GameFontHighlightSmall", 390)
    w.taskListHelp = boundedLabel(w.taskList, "Task definitions are shared across characters. Completion follows each task's setting.", 22, -376, "GameFontHighlightSmall", 612, 36, 2)
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
    w.guide = button(w.editor, "Guide: None >", 22, -246, 282, function() form.guide = not form.guide; updateForm() end)
    boundedLabel(w.editor, "Book guide uses Librarian Books Forever. This link is saved for this character.", 318, -246, "GameFontDisableSmall", 294, 32, 2)
    boundedLabel(w.editor, "Task definitions are shared. Editing or deleting a task affects every character. Completion can be separate or shared.", 22, -282, "GameFontHighlightSmall", 612, 42, 3)
    w.feedback = boundedLabel(w.editor, "", 22, -336, "GameFontHighlight", 612, 38, 2)
    w.save = button(w.editor, "Add task", 22, -390, 154, saveTask)
    w.cancel = button(w.editor, "Cancel", 188, -390, 110, closeEditor)
    w.remove = button(w.editor, "Delete task", 494, -390, 140, function()
        if not editID then return end
        if w.pendingDelete == editID then
            local ok, err = M.DeleteTask(ns.db, editID)
            if not ok then w.feedback:SetText(ns.SafeText(err or "Could not delete this task.")); return end
            if type(ns.settings.taskGuides) == "table" then ns.settings.taskGuides[editID] = nil end
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
    local chosen = ns.GetChosenTask()
    if chosen then
        plan = {tasks={chosen}, totalMinutes=chosen.minutes, budgetMinutes=budget}
    end
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
    w.planExplanation:SetText(chosen and "Chosen by you. Mark Done when you finish." or "Suggestions based on estimates and priorities.")
    w.chooseTask:SetShown(unfinished > 0)
    w.chooseTask:SetText(chosen and "Change task" or "Choose myself")
    w.showSuggestions:SetShown(chosen ~= nil)
    if #tasks == 0 then
        w.emptyMode = "empty"
        w.planSummary:SetText("Start with one task for this session.")
        w.emptyTitle:SetText("What would make this session worthwhile?")
        w.emptyTask:SetText("Add an activity you want to do and an honest estimate of how long it takes.")
        w.emptyDetails:SetText("Get suggestions from your tasks, or choose one yourself. Activities are entered manually.")
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
        w.emptyDetails:SetText(shortest.minutes .. " min estimated. Your available time is still " .. budget .. " min.\nYou can choose a task yourself, even if its estimate is longer.")
        w.emptyPrimary:SetText("Choose a task"); w.emptySecondary:SetText("Change time"); w.emptySecondary:Show()
    else
        w.emptyMode = nil
        if chosen then
            local summary = "Your chosen task / " .. chosen.minutes .. " min estimated."
            if chosen.minutes > budget then
                summary = summary .. "\n" .. (chosen.minutes - budget) .. " min over your " .. budget .. "-minute budget."
            else summary = summary .. " Available time: " .. budget .. " min." end
            w.planSummary:SetText(summary)
        else
            w.planSummary:SetText(count .. (count == 1 and " suggestion / " or " suggestions / ") .. plan.totalMinutes .. " of " .. budget .. " min.")
        end
    end
    if count == 0 and w.editorOpen and w.emptyMode ~= "no-fit" then
        w.emptyPrimary:SetText("Resume draft")
        if w.emptyMode == "complete" then w.emptySecondary:Hide() end
    end
    if w.budgetError then w.planSummary:SetText(w.budgetError) end
    for i, row in ipairs(w.planRows) do
        local task = plan.tasks[i]; row.task = task
        row.container:SetShown(task ~= nil)
        row.text:SetText(task and ((chosen and "" or i .. ". ") .. ns.SafeText(task.label)) or "")
        row.metadata:SetText(task and (task.minutes .. " min estimated  /  " .. priorityNames[task.priority] .. " priority") or "")
        row.choose:SetShown(task ~= nil and not chosen)
        row.guide:SetShown(chosen ~= nil and guideFor(task) == true)
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
    local choosing = w.view == "choose"
    w.unfinishedFilter:SetText((taskFilter == "unfinished" and "|cff52d9bb" or "") .. (choosing and "Choose a task (" or "Unfinished (") .. unfinished .. ")" .. (taskFilter == "unfinished" and "|r" or ""))
    w.completedFilter:SetText((taskFilter == "completed" and "|cff52d9bb" or "") .. "Completed (" .. completed .. ")" .. (taskFilter == "completed" and "|r" or ""))
    w.completedFilter:SetShown(not choosing); w.newTask:SetShown(not choosing); w.chooseBack:SetShown(choosing)
    w.taskListHelp:SetText(choosing and "Choose any unfinished task. Your time budget, estimates and priorities stay as you set them. Your choice is saved for this character."
        or "Task definitions are shared across characters. Completion follows each task's setting.")
    w.pageCount = math.max(1, math.ceil(#filtered / 5)); page = math.min(page, w.pageCount)
    w.pageText:SetText("Page " .. page .. " / " .. w.pageCount .. "  (" .. #filtered .. " " .. taskFilter .. ")")
    w.previousPage:SetShown(page > 1); w.nextPage:SetShown(page < w.pageCount)
    w.taskListEmpty:SetShown(#filtered == 0)
    w.taskListEmpty:SetText(taskFilter == "completed" and "No completed tasks yet. Finish a task to find it here." or "No unfinished tasks. Add a task, or view completed tasks to undo one.")
    for i, row in ipairs(w.taskRows) do
        local task = filtered[(page - 1) * 5 + i]; row.task = task
        row.container:SetShown(task ~= nil)
        row.text:SetWidth(choosing and 480 or 324); row.metadata:SetWidth(choosing and 480 or 324)
        row.text:SetText(task and ns.SafeText(task.label) or "")
        row.metadata:SetText(task and (task.minutes .. " min / " .. priorityNames[task.priority] .. " / " .. recurrenceNames[task.recurrence] .. " / " .. (task.scope == "account" and "Shared completion" or "Per character")) or "")
        if task then row.toggle:SetText(task.completed and "Undo" or "Done") end
        row.choose:SetShown(task ~= nil and not task.completed)
        row.choose:SetText(task and chosen and task.id == chosen.id and "Chosen" or "Choose")
        row.choose:ClearAllPoints(); row.choose:SetPoint("TOPLEFT", choosing and 522 or 356, -12)
        row.toggle:SetShown(not choosing); row.edit:SetShown(not choosing)
    end
end
