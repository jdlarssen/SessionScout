local addonName, ns = ...
local M = ns.Model
ns.name = addonName
ns.version = "0.1.0-alpha.1"

function ns.Now()
    return GetServerTime and GetServerTime() or time()
end

function ns.SafeText(value)
    return tostring(value or ""):gsub("|", "||")
end

local function truncateLetters(value, maximum)
    local count = 0
    -- EditBox limits count UTF-8 characters; never cut a saved multibyte letter.
    for position in value:gmatch("()[^\128-\191]") do
        count = count + 1
        if count > maximum then return value:sub(1, position - 1) end
    end
    return value
end

function ns.Message(value)
    if DEFAULT_CHAT_FRAME then
        DEFAULT_CHAT_FRAME:AddMessage("|cff52d9bbSessionScout:|r " .. ns.SafeText(value))
    end
end

local function readable(value)
    return not (issecretvalue and issecretvalue(value))
end

local function finiteNumber(value)
    return readable(value) and type(value) == "number" and value == value
        and value > -math.huge and value < math.huge
end

local function characterKey()
    local guid = UnitGUID("player")
    if readable(guid) and type(guid) == "string" and guid ~= "" then return guid end
    local name, realm = UnitName("player"), GetRealmName()
    if readable(name) and readable(realm) and type(name) == "string" and name ~= ""
        and type(realm) == "string" and realm ~= "" then return name .. "-" .. realm end
end

local function secondsUntil(fn)
    if type(fn) ~= "function" then return nil end
    local ok, value = pcall(fn)
    if ok and finiteNumber(value) and value > 0 then return math.ceil(value) end
end

function ns.ResetTimes()
    local now = ns.Now()
    local api = C_DateAndTime or {}
    local daily = secondsUntil(api.GetSecondsUntilDailyReset) or secondsUntil(GetQuestResetTime)
    local weekly = secondsUntil(api.GetSecondsUntilWeeklyReset)
    return { daily = daily and now + daily, weekly = weekly and now + weekly }
end

function ns.Readiness()
    if InCombatLockdown and InCombatLockdown() then return "Readiness updates after combat." end
    local parts = {}
    if C_Container and C_Container.GetContainerNumFreeSlots then
        local free = 0
        for bag = 0, 4 do
            local slots, family = C_Container.GetContainerNumFreeSlots(bag)
            if finiteNumber(slots) and readable(family) and (family == 0 or family == nil) then free = free + slots end
        end
        parts[#parts + 1] = free .. " free general bag slots"
    end
    if GetInventoryItemDurability then
        local minimum
        for slot = 1, 19 do
            local current, maximum = GetInventoryItemDurability(slot)
            if finiteNumber(current) and finiteNumber(maximum) and maximum > 0 then
                local pct = math.floor(current / maximum * 100)
                minimum = math.min(minimum or 100, pct)
            end
        end
        if minimum then parts[#parts + 1] = "Lowest durability " .. minimum .. "%" end
    end
    return #parts > 0 and table.concat(parts, "  /  ") or "Readiness is unavailable on this client."
end

function ns.Complete(id)
    if not ns.db then return end
    if not ns.character then ns.Message("Character identity is not available yet. Try /scout again after combat."); return end
    local ok, err = M.CompleteTask(ns.db, id, ns.character, ns.Now(), ns.ResetTimes())
    if not ok then ns.Message(err or "Could not complete this task.") end
    ns.Refresh()
end

function ns.Refresh()
    if not ns.db then return end
    M.Refresh(ns.db, ns.Now())
    if ns.Render and ns.window and ns.window:IsShown() then ns.Render() end
end

function ns.Toggle()
    if not ns.db then ns.Message("Saved data could not be loaded; no data has been replaced."); return end
    ns.character = ns.character or characterKey()
    if not ns.character then ns.Message("Character identity is not available yet. Try /scout again after combat."); return end
    if not ns.window then ns.CreateWindow() end
    if ns.window:IsShown() then ns.window:Hide() else ns.window:Show(); ns.Refresh() end
end

local events = CreateFrame("Frame")
events:RegisterEvent("ADDON_LOADED")
events:RegisterEvent("PLAYER_LOGIN")
events:RegisterEvent("PLAYER_LOGOUT")
events:RegisterEvent("PLAYER_REGEN_ENABLED")
events:RegisterEvent("BAG_UPDATE_DELAYED")
events:RegisterEvent("UPDATE_INVENTORY_DURABILITY")
events:SetScript("OnEvent", function(_, event, loadedName)
    if event == "ADDON_LOADED" and loadedName == addonName then
        local state, report = M.Normalize(SessionScoutDB)
        if not state then ns.Message(report and report.error or "Unsupported saved data."); return end
        SessionScoutDB = state
        ns.db = state
        if type(SessionScoutCharDB) ~= "table" then SessionScoutCharDB = {} end
        ns.settings = SessionScoutCharDB
        if type(ns.settings.budget) ~= "number" or ns.settings.budget ~= ns.settings.budget or ns.settings.budget < 1 or ns.settings.budget > 240 then
            ns.settings.budget = 30
        end
        ns.settings.budget = math.floor(ns.settings.budget)
        if type(ns.settings.note) ~= "string" then ns.settings.note = "" end
        ns.settings.note = truncateLetters(ns.settings.note, 500)
    elseif event == "PLAYER_LOGIN" and ns.db then
        ns.character = characterKey()
        if not ns.settings.welcomed then
            ns.Message("Type /scout to plan your next 15, 30 or 60 minutes. Add your own tasks to start.")
            ns.settings.welcomed = true
        end
    elseif event == "PLAYER_LOGOUT" and ns.SaveNote then
        ns.SaveNote()
    elseif event == "PLAYER_REGEN_ENABLED" and ns.db then
        ns.character = ns.character or characterKey()
        ns.Refresh()
    elseif ns.character then
        ns.Refresh()
    end
end)

SLASH_SESSIONSCOUT1 = "/scout"
SLASH_SESSIONSCOUT2 = "/sessionscout"
SlashCmdList.SESSIONSCOUT = function(message)
    local budget = tonumber(message)
    if budget and budget == budget and ns.settings then
        ns.settings.budget = math.max(1, math.min(240, math.floor(budget)))
        if ns.window then ns.window:Hide() end
    end
    ns.Toggle()
end
ns.events = events
