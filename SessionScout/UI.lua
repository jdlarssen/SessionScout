local _, ns = ...
local M = ns.Model
local accent = { 0.32, 0.85, 0.73 }
local recurrenceNames = { once = "Once", daily = "Daily", weekly = "Weekly" }
local priorityNames = { "High", "Medium", "Low" }
local page, editID = 1, nil
local form = { recurrence = "once", scope = "character", priority = 2 }

local function label(parent, text, x, y, size, width)
    local f = parent:CreateFontString(nil, "OVERLAY", size or "GameFontNormal")
    f:SetPoint("TOPLEFT", x, y)
    if width then f:SetWidth(width); f:SetJustifyH("LEFT") end
    f:SetText(text)
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

local function updateForm()
    local w = ns.window
    w.recurrence:SetText(recurrenceNames[form.recurrence])
    w.scope:SetText(form.scope == "account" and "Shared completion" or "Per character")
    w.priority:SetText(priorityNames[form.priority])
    w.save:SetText(editID and "Save changes" or "Add task")
    w.cancel:SetShown(editID ~= nil)
end

local function resetForm()
    editID = nil; form = { recurrence = "once", scope = "character", priority = 2 }
    ns.window.taskLabel:SetText(""); ns.window.minutes:SetText("10")
    ns.window.feedback:SetText(""); updateForm()
end

local function editTask(task)
    editID = task.id
    form = { recurrence = task.recurrence, scope = task.scope, priority = task.priority }
    ns.window.taskLabel:SetText(task.label); ns.window.minutes:SetText(tostring(task.minutes))
    ns.window.feedback:SetText("Editing a task changes its definition for every character.")
    updateForm(); ns.window.taskLabel:SetFocus()
end

function ns.SaveNote()
    if ns.window and ns.settings then ns.settings.note = ns.window.note:GetText() end
end

function ns.CreateWindow()
    local w = CreateFrame("Frame", "SessionScoutWindow", UIParent, "BackdropTemplate")
    ns.window = w
    w:Hide(); w:SetSize(660, 700); w:SetPoint("CENTER")
    w:SetClampedToScreen(true); w:SetMovable(true); w:EnableMouse(true)
    w:SetFrameStrata("DIALOG")
    w:SetScale(math.min(1, (UIParent:GetHeight() - 40) / 700))
    w:SetBackdrop({ bgFile = "Interface\\Buttons\\WHITE8X8", edgeFile = "Interface\\Buttons\\WHITE8X8", edgeSize = 1 })
    w:SetBackdropColor(0.045, 0.065, 0.085, 0.98); w:SetBackdropBorderColor(0.2, 0.35, 0.39, 1)
    w:RegisterForDrag("LeftButton")
    w:SetScript("OnDragStart", w.StartMoving); w:SetScript("OnDragStop", w.StopMovingOrSizing)
    w:SetScript("OnHide", ns.SaveNote)
    -- Only a visible planner is refreshed; no background polling or per-frame work.
    w:SetScript("OnShow", function()
        if C_Timer and C_Timer.NewTicker then w.ticker = C_Timer.NewTicker(30, ns.Refresh) end
    end)
    w:HookScript("OnHide", function() if w.ticker then w.ticker:Cancel(); w.ticker = nil end end)
    UISpecialFrames[#UISpecialFrames + 1] = "SessionScoutWindow"
    local title = label(w, "SessionScout", 22, -20, "GameFontNormalLarge")
    title:SetTextColor(unpack(accent))
    label(w, "A little time. A clear next step.", 22, -46, "GameFontHighlight")
    button(w, "Close", 574, -18, 64, function() w:Hide() end)
    label(w, "How long do you have?", 22, -78)
    w.budgets = {}
    for i, minutes in ipairs({ 15, 30, 60 }) do
        w.budgets[i] = button(w, minutes .. " min", 208 + (i - 1) * 86, -70, 78, function()
            ns.settings.budget = minutes; ns.Refresh()
        end)
    end
    w.planSummary = label(w, "", 22, -108, "GameFontHighlight", 612)
    w.planRows = {}
    for i = 1, 3 do
        local y = -140 - (i - 1) * 34
        local row = {}
        row.text = label(w, "", 28, y, "GameFontHighlight", 490)
        row.text:SetWordWrap(false); row.text:SetMaxLines(1); row.text:SetHeight(20)
        row.done = button(w, "Done", 557, y + 5, 76, function() if row.task then ns.Complete(row.task.id) end end)
        taskTooltip(row.done, row)
        w.planRows[i] = row
    end
    w.readiness = label(w, "", 22, -245, "GameFontDisableSmall", 612)
    label(w, "Your tasks", 22, -277, "GameFontNormalLarge")
    w.pageText = label(w, "", 403, -283, "GameFontHighlightSmall", 108)
    button(w, "<", 553, -276, 34, function() page = math.max(1, page - 1); ns.Refresh() end)
    button(w, ">", 600, -276, 34, function() page = math.min(w.pageCount or 1, page + 1); ns.Refresh() end)
    w.taskRows = {}
    for i = 1, 5 do
        local y = -312 - (i - 1) * 33
        local row = {}
        row.text = label(w, "", 24, y, "GameFontHighlightSmall", 377)
        row.text:SetWordWrap(false); row.text:SetMaxLines(2); row.text:SetHeight(28)
        row.toggle = button(w, "Done", 413, y + 5, 63, function()
            if not row.task then return end
            if row.task.completed then M.ResetTask(ns.db, row.task.id, ns.character); ns.Refresh()
            else ns.Complete(row.task.id) end
        end)
        row.edit = button(w, "Edit", 482, y + 5, 62, function() if row.task then editTask(row.task) end end)
        taskTooltip(row.edit, row)
        row.remove = button(w, "Delete", 550, y + 5, 84, function()
            if not row.task then return end
            -- Two clicks protect against an accidental click; the task label identifies what is being removed.
            if w.pendingDelete == row.task.id then
                M.DeleteTask(ns.db, row.task.id)
                if editID == row.task.id then resetForm() end
                w.pendingDelete = nil; ns.Refresh()
            else w.pendingDelete = row.task.id; row.remove:SetText("Confirm?") end
        end)
        w.taskRows[i] = row
    end
    label(w, "Task", 24, -485, "GameFontHighlightSmall")
    label(w, "Minutes", 396, -485, "GameFontHighlightSmall")
    w.taskLabel = entry(w, 30, -505, 350, 120)
    w.minutes = entry(w, 402, -505, 58, 3); w.minutes:SetNumeric(true); w.minutes:SetText("10")
    w.save = button(w, "Add task", 480, -505, 154, function()
        local task = { label = w.taskLabel:GetText(), minutes = tonumber(w.minutes:GetText()), priority = form.priority,
            recurrence = form.recurrence, scope = form.scope }
        local result, err
        if editID then result, err = M.UpdateTask(ns.db, editID, task) else result, err = M.AddTask(ns.db, task) end
        if not result then w.feedback:SetText(ns.SafeText(err or "Check the task fields.")); return end
        w.taskLabel:ClearFocus(); w.minutes:ClearFocus(); resetForm(); ns.Refresh()
    end)
    w.priority = button(w, "Medium", 24, -538, 94, function() form.priority = form.priority % 3 + 1; updateForm() end)
    w.recurrence = button(w, "Once", 127, -538, 94, function()
        form.recurrence = ({ once = "daily", daily = "weekly", weekly = "once" })[form.recurrence]; updateForm()
    end)
    w.scope = button(w, "Per character", 230, -538, 165, function()
        form.scope = form.scope == "character" and "account" or "character"; updateForm()
    end)
    w.cancel = button(w, "Cancel edit", 480, -538, 154, resetForm); w.cancel:Hide()
    w.feedback = label(w, "", 24, -571, "GameFontHighlightSmall", 610)
    label(w, "Next time, remember... (saved for this character)", 24, -609, "GameFontNormal")
    w.note = entry(w, 30, -631, 600, 500); w.note:SetText(ns.settings.note)
    w.note:SetScript("OnTextChanged", ns.SaveNote)
    label(w, "Manual tasks. Daily / weekly completion follows the server reset.", 24, -672, "GameFontDisableSmall", 612)
end

function ns.Render()
    local w = ns.window
    if not w or not ns.character then return end
    local budget = ns.settings.budget
    local plan, err = M.BuildPlan(ns.db, ns.character, ns.Now(), budget)
    local tasks = M.ListTasks(ns.db, ns.character, ns.Now())
    for i, minutes in ipairs({ 15, 30, 60 }) do
        w.budgets[i]:SetText((budget == minutes and "|cff52d9bb" or "") .. minutes .. " min" .. (budget == minutes and "|r" or ""))
    end
    if not plan then w.planSummary:SetText(ns.SafeText(err)); return end
    local count = math.min(3, #plan.tasks)
    if #tasks == 0 then
        w.planSummary:SetText("Start with one task below: what would make this session worthwhile?")
    elseif count == 0 then
        w.planSummary:SetText("No unfinished task fits " .. budget .. " min. Try a larger budget or a smaller task.")
    else
        w.planSummary:SetText(count .. " next actions / " .. plan.totalMinutes .. " of " .. budget .. " min. High priority first.")
    end
    for i, row in ipairs(w.planRows) do
        local task = plan.tasks[i]; row.task = task
        row.text:SetText(task and (i .. ". " .. ns.SafeText(task.label) .. "  |cff52d9bb" .. task.minutes .. " min|r") or "")
        row.done:SetShown(task ~= nil)
    end
    w.readiness:SetText(ns.Readiness())
    w.pageCount = math.max(1, math.ceil(#tasks / 5)); page = math.min(page, w.pageCount)
    w.pageText:SetText(page .. " / " .. w.pageCount .. "  (" .. #tasks .. " tasks)")
    for i, row in ipairs(w.taskRows) do
        local task = tasks[(page - 1) * 5 + i]; row.task = task
        local color = task and task.completed and "|cff7d9393" or "|cffe6ecec"
        row.text:SetText(task and (color .. ns.SafeText(task.label) .. "|r\n" .. task.minutes .. "m / " .. priorityNames[task.priority] .. " / " .. recurrenceNames[task.recurrence] .. " / " .. (task.scope == "account" and "Shared" or "Character")) or "")
        row.toggle:SetShown(task ~= nil); row.edit:SetShown(task ~= nil); row.remove:SetShown(task ~= nil)
        if task then row.toggle:SetText(task.completed and "Undo" or "Done"); row.remove:SetText("Delete") end
    end
    w.pendingDelete = nil
end
