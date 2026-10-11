local _, ns = ...
local statNames = { armor = "Armor", str = "Strength", agi = "Agility", sta = "Stamina", int = "Intellect",
    spi = "Spirit", ap = "Attack power", sp = "Spell power" }
local statOrder = { "armor", "str", "agi", "sta", "int", "spi", "ap", "sp" }
local shortStatNames = { armor = "Armor", str = "Str", agi = "Agi", sta = "Sta", int = "Int",
    spi = "Spi", ap = "AP", sp = "SP" }

local function text(parent, value, x, y, font, width)
    local label = parent:CreateFontString(nil, "OVERLAY", font or "GameFontHighlight")
    label:SetPoint("TOPLEFT", x, y)
    label:SetJustifyH("LEFT")
    if width then label:SetWidth(width) end
    label:SetText(value)
    return label
end
local function button(parent, value, x, y, width, callback)
    local control = CreateFrame("Button", nil, parent, "UIPanelButtonTemplate")
    control:SetSize(width, 26); control:SetPoint("TOPLEFT", x, y); control:SetText(value)
    control:SetScript("OnClick", callback)
    return control
end
local function number(value)
    if value == math.floor(value) then return string.format("%.0f", value) end
    return string.format("%.3f", value)
end
local function signed(value) return (value > 0 and "+" or "") .. number(value) end

local function contributions(deltaStats, weights)
    local terms = {}
    for key, difference in pairs(deltaStats) do
        local points = difference * (weights[key] or 0)
        if points ~= 0 then terms[#terms + 1] = { key = key, points = points } end
    end
    table.sort(terms, function(a, b)
        if math.abs(a.points) ~= math.abs(b.points) then return math.abs(a.points) > math.abs(b.points) end
        return a.key < b.key
    end)
    local display = {}
    for _, term in ipairs(terms) do
        display[#display + 1] = ns.SafeText(shortStatNames[term.key] or term.key) .. " " .. signed(term.points)
    end
    if #display == 0 then return "No nonzero weighted stat contributions." end
    return "Why (points): " .. table.concat(display, "; ")
end

local function coefficients(weights)
    local keys, included = {}, {}
    for _, key in ipairs(statOrder) do
        if weights[key] ~= nil then keys[#keys + 1], included[key] = key, true end
    end
    local extra = {}
    for key in pairs(weights) do if not included[key] then extra[#extra + 1] = key end end
    table.sort(extra)
    for _, key in ipairs(extra) do keys[#keys + 1] = key end
    local display = {}
    for _, key in ipairs(keys) do
        local value = weights[key]
        display[#display + 1] = ns.SafeText(shortStatNames[key] or key) .. "=" .. tostring(value)
            .. (value == 0 and " (ignored)" or "")
    end
    return table.concat(display, "; ")
end

function ns.FitWindow()
    local width = UIParent:GetWidth()
    local height = UIParent:GetHeight()
    ns.window:SetScale(math.max(0.1, math.min(1, (width - 40) / 720, (height - 40) / 720)))
end
function ns.CreateWindow()
    local w = CreateFrame("Frame", "GearEvidencePilotWindow", UIParent, "BackdropTemplate")
    ns.window = w
    w:Hide(); w:SetSize(720, 720); w:SetPoint("CENTER")
    w:SetClampedToScreen(true); w:SetMovable(true); w:EnableMouse(true); w:SetFrameStrata("DIALOG")
    w:SetToplevel(true)
    w:SetBackdrop({ bgFile = "Interface\\Buttons\\WHITE8X8", edgeFile = "Interface\\Buttons\\WHITE8X8", edgeSize = 1 })
    w:SetBackdropColor(0.045, 0.055, 0.075, 0.98); w:SetBackdropBorderColor(0.24, 0.42, 0.44, 1)
    w:RegisterForDrag("LeftButton"); w:SetScript("OnDragStart", w.StartMoving); w:SetScript("OnDragStop", w.StopMovingOrSizing)
    w:SetScript("OnHide", ns.OnWindowHidden)
    UISpecialFrames[#UISpecialFrames + 1] = "GearEvidencePilotWindow"
    text(w, "Gear Evidence / RFK pilot", 24, -22, "GameFontNormalLarge", 540)
    text(w, "Two candidates. Current client stats. Fixed models; no personal simulation.", 24, -49, "GameFontHighlightSmall", 660)
    button(w, "Close", 632, -18, 64, function() w:Hide() end)
    w.candidates = {}
    for index, candidate in ipairs(ns.Data.candidates) do
        local selected = index
        w.candidates[index] = button(w, candidate.name, 24 + (index - 1) * 238, -77, 230, function() ns.SelectCandidate(selected) end)
    end
    button(w, "Refresh client data", 508, -77, 188, function() ns.Refresh() end)
    w.status = text(w, "", 24, -118, "GameFontHighlight", 670)
    w.status:SetHeight(48)
    local currentTooltip = button(w, "Hover: current item", 24, -170, 210, function() end)
    local candidateTooltip = button(w, "Hover: candidate item", 244, -170, 210, function() end)
    currentTooltip:SetScript("OnEnter", function(self) ns.ShowItemTooltip(self, "current") end)
    candidateTooltip:SetScript("OnEnter", function(self) ns.ShowItemTooltip(self, "proposed") end)
    for _, control in ipairs({ currentTooltip, candidateTooltip }) do
        control:SetScript("OnLeave", function() if GameTooltip then GameTooltip:Hide() end end)
    end
    text(w, "Inspect client tooltips", 472, -177, "GameFontDisableSmall", 220)
    local scroll = CreateFrame("ScrollFrame", nil, w, "UIPanelScrollFrameTemplate")
    scroll:SetPoint("TOPLEFT", 24, -210); scroll:SetSize(650, 436)
    w.scroll = scroll
    local evidence = CreateFrame("EditBox", nil, scroll)
    evidence:SetMultiLine(true); evidence:SetAutoFocus(false); evidence:SetFontObject(GameFontHighlight)
    evidence:SetWidth(644); evidence:SetHeight(436); evidence:SetMaxLetters(30000)
    evidence:SetScript("OnEscapePressed", function(self) self:ClearFocus(); w:Hide() end)
    evidence:SetScript("OnTextChanged", function(self, userInput)
        if userInput then self:SetText(w.evidenceText or "") end
    end)
    scroll:SetScrollChild(evidence)
    local function onMouseWheel(_, delta)
        local range = math.max(0, scroll:GetVerticalScrollRange())
        local position = math.max(0, math.min(range, scroll:GetVerticalScroll() - delta * 36))
        scroll:SetVerticalScroll(position)
        if scroll.ScrollBar then
            scroll.ScrollBar:SetMinMaxValues(0, range)
            scroll.ScrollBar:SetValue(position)
        end
    end
    scroll:EnableMouseWheel(true); scroll:SetScript("OnMouseWheel", onMouseWheel)
    evidence:EnableMouseWheel(true); evidence:SetScript("OnMouseWheel", onMouseWheel)
    w.evidence = evidence
    text(w, "Click the evidence text; Ctrl+A, Ctrl+C copies stats, assumptions and source URLs.", 24, -665, "GameFontDisableSmall", 670)
    text(w, "Local prototype. Model points are not measured DPS, BiS or verified beta drop availability.", 24, -687, "GameFontDisableSmall", 670)
    ns.FitWindow()
end

function ns.Render()
    local w, state = ns.window, ns.state
    if not w then return end
    local candidate = state.candidate or ns.Data.candidates[state.selectedIndex]
    w.status:SetText(string.upper(state.status or "unknown") .. " / " .. ns.SafeText(state.reason or "No comparison available."))
    if state.status == "ready" then w.status:SetTextColor(0.65, 0.88, 0.77)
    else w.status:SetTextColor(1, 0.80, 0.50) end
    for index, control in ipairs(w.candidates) do
        control:SetText((index == state.selectedIndex and "> " or "") .. ns.Data.candidates[index].name)
    end
    local lines = { "SELECTED COMPARISON / " .. (candidate.slotID == 7 and "Legs" or "Shoulder") }
    lines[#lines + 1] = "Current: " .. (state.current and ns.SafeText(state.current.name) or "not read / unavailable")
    lines[#lines + 1] = "Candidate: " .. ns.SafeText(state.proposed and state.proposed.name or candidate.name) .. " (item " .. candidate.itemID .. ")"
    lines[#lines + 1] = "Stats source: client data only. Missing data blocks scoring."
    lines[#lines + 1] = ""
    lines[#lines + 1] = "RAW STAT CHANGE / current -> candidate (difference)"
    if state.rawDelta and state.current and state.proposed then
        local keys, included = {}, {}
        for _, key in ipairs(statOrder) do
            if state.rawDelta[key] ~= nil then keys[#keys + 1], included[key] = key, true end
        end
        local extra = {}
        for key in pairs(state.rawDelta) do if not included[key] then extra[#extra + 1] = key end end
        table.sort(extra)
        for _, key in ipairs(extra) do keys[#keys + 1] = key end
        for _, key in ipairs(keys) do
            lines[#lines + 1] = ns.SafeText(statNames[key] or key) .. ": " .. number(state.current.stats[key] or 0)
                .. " -> " .. number(state.proposed.stats[key] or 0) .. " (" .. signed(state.rawDelta[key]) .. ")"
        end
    else lines[#lines + 1] = "Unavailable until both complete client stat records pass the scope checks." end
    lines[#lines + 1] = ""
    lines[#lines + 1] = "FIXED MODELS / weighted points, not DPS"
    for index, model in ipairs(ns.Data.models) do
        lines[#lines + 1] = ns.SafeText(model.name)
        local result = state.models and state.models[index] and state.models[index].comparison
        if state.status == "ready" and result and result.ok then
            lines[#lines + 1] = "Current " .. number(result.before) .. " -> candidate " .. number(result.after)
                .. "; change " .. signed(result.delta) .. " weighted points, not DPS."
            lines[#lines + 1] = contributions(state.rawDelta, model.weights)
        else
            lines[#lines + 1] = "No score shown: " .. ns.SafeText(result and result.reason or state.reason or "data unavailable")
        end
        lines[#lines + 1] = ""
    end
    lines[#lines + 1] = "CONTEXT"
    lines[#lines + 1] = "Forever Interface 16001; level 30 Shaman; Enhancement must have a unique positive talent-rank lead."
    lines[#lines + 1] = "Weights stay fixed. They are not adapted to your talents, rotation or encounter."
    if state.context then lines[#lines + 1] = "Talent evidence: " .. ns.SafeText(state.context.label) end
    lines[#lines + 1] = ""
    lines[#lines + 1] = "MODEL SOURCES / fixed assumptions"
    for _, model in ipairs(ns.Data.models) do
        lines[#lines + 1] = ns.SafeText(model.name)
        lines[#lines + 1] = "Method: " .. ns.SafeText(model.method)
        lines[#lines + 1] = "Points per stat: " .. coefficients(model.weights)
        lines[#lines + 1] = "Each contribution is stat change x coefficient; displayed points are rounded."
        lines[#lines + 1] = "Inspected: " .. ns.SafeText(model.inspected)
        lines[#lines + 1] = "Source: " .. ns.SafeText(model.source)
        lines[#lines + 1] = ""
    end
    lines[#lines + 1] = "BOSS / DROP EVIDENCE"
    lines[#lines + 1] = "Boss source: Classic data; no beta drop verified."
    lines[#lines + 1] = ns.SafeText(candidate.dropEvidence)
    lines[#lines + 1] = "Inspected: " .. ns.SafeText(candidate.inspected or "date not recorded")
    lines[#lines + 1] = "Source: " .. ns.SafeText(candidate.source)
    lines[#lines + 1] = ""
    lines[#lines + 1] = "BOUNDARIES"
    lines[#lines + 1] = "Only reported item stats are scored. Proc, set, enchant, rotation and encounter effects are not evaluated."
    lines[#lines + 1] = "A higher score means more points under that model only. Scores use different scales; do not compare them across models."
    lines[#lines + 1] = "Candidates are analyst-selected RFK examples. This pilot does not establish your best item, hunt target or farm efficiency."
    lines[#lines + 1] = "Missing, pending, stale or unsupported evidence blocks scores. Refresh after equipment or talent changes."
    w.evidenceText = table.concat(lines, "\n")
    local visualLines = 0
    for _, line in ipairs(lines) do visualLines = visualLines + math.max(1, math.ceil(#line / 73)) end
    w.evidence:SetHeight(math.max(436, visualLines * 17 + 24))
    w.evidence:SetText(w.evidenceText)
    w.evidence:SetCursorPosition(0)
    w.evidence:ClearFocus()
    w.scroll:SetVerticalScroll(0)
end
