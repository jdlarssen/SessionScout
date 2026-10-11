local _, ns = ...
-- This table is exposed for local QA. It is not a stable public addon API.
_G.GearEvidencePilot = ns
ns.state = { status = "missing", reason = "Open the pilot to read this session's client data.", selectedIndex = 1 }
local generation, busy, asyncScheduled = 0, false, false
local requested, pending, failed = {}, {}, {}
local statMap = {
    ITEM_MOD_STRENGTH_SHORT = "str", ITEM_MOD_AGILITY_SHORT = "agi",
    ITEM_MOD_STAMINA_SHORT = "sta", ITEM_MOD_INTELLECT_SHORT = "int",
    ITEM_MOD_SPIRIT_SHORT = "spi", ITEM_MOD_ATTACK_POWER_SHORT = "ap",
    ITEM_MOD_SPELL_POWER_SHORT = "sp", RESISTANCE0_NAME = "armor",
}

local function secret(value)
    if type(canaccessvalue) == "function" then
        local ok, accessible = pcall(canaccessvalue, value)
        if not ok or type(accessible) ~= "boolean" or not accessible then return true end
    end
    if type(issecretvalue) == "function" then
        local ok, result = pcall(issecretvalue, value)
        return not ok or type(result) ~= "boolean" or result == true
    end
    return false
end
local function finite(value)
    return not secret(value) and type(value) == "number" and value == value and value ~= math.huge and value ~= -math.huge
end
local function plain(value) return not secret(value) and type(value) == "string" end
local function ordinaryTable(value) return not secret(value) and type(value) == "table" end
local function combat()
    if type(InCombatLockdown) ~= "function" then return true end
    local ok, active = pcall(InCombatLockdown)
    return not ok or secret(active) or type(active) ~= "boolean" or active
end
local function statsRestricted()
    if not C_Secrets or type(C_Secrets.ShouldUnitStatsBeSecret) ~= "function" then return true end
    local ok, restricted = pcall(C_Secrets.ShouldUnitStatsBeSecret)
    return not ok or secret(restricted) or type(restricted) ~= "boolean" or restricted
end
local function visible() return ns.window and ns.window:IsShown() end
function ns.SafeText(value)
    if not plain(value) then return "unavailable" end
    return value:gsub("|", "||"):gsub("[%z\1-\8\11\12\14-\31]", "")
end
local function mark(status, reason)
    ns.state.status, ns.state.reason = status, reason
    ns.state.models = nil
end
local function render() if visible() and ns.Render then ns.Render() end end

local function call(fn, ...)
    if type(fn) ~= "function" then return false end
    return pcall(fn, ...)
end

local function equippedLink(slotID)
    if combat() then return nil, "unsupported", "Item reads are blocked during combat." end
    if statsRestricted() then return nil, "unsupported", "Client stat restrictions are active or unknown." end
    if ItemLocation and type(ItemLocation.CreateFromEquipmentSlot) == "function" and C_Item
        and type(C_Item.DoesItemExist) == "function" and type(C_Item.GetItemLink) == "function" then
        local ok, location = call(ItemLocation.CreateFromEquipmentSlot, ItemLocation, slotID)
        if not ok or not ordinaryTable(location) then return nil, "unsupported", "Equipment location is unavailable." end
        local existsOK, exists = call(C_Item.DoesItemExist, location)
        if not existsOK or secret(exists) or type(exists) ~= "boolean" then return nil, "unsupported", "Equipment presence is unavailable." end
        if not exists then return nil, "missing", "The selected equipment slot is empty; no comparison is available." end
        local linkOK, link = call(C_Item.GetItemLink, location)
        if linkOK and plain(link) and link ~= "" then return link end
        return nil, "pending", "The equipped item's full link is unavailable. Refresh after it loads."
    end
    local ok, link = call(GetInventoryItemLink, "player", slotID)
    if not ok or secret(link) then return nil, "unsupported", "The equipped item link cannot be read safely." end
    if link == nil then return nil, "missing", "The selected equipment slot is empty; no comparison is available." end
    if not plain(link) or link == "" then return nil, "unsupported", "The equipped item link is unavailable." end
    return link
end

local function itemID(link)
    if not plain(link) then return nil end
    local value = tonumber(link:match("item:(%d+)"))
    if finite(value) and value > 0 then return value end
end

local function request(id)
    if not finite(id) or id <= 0 or requested[id] or combat() then return end
    requested[id], pending[id] = true, true
    -- Set pending before calling: clients/mocks may deliver a synchronous event.
    local ok = C_Item and call(C_Item.RequestLoadItemDataByID, id)
    if not ok then pending[id], failed[id] = nil, true end
end

local function normalize(raw)
    if not ordinaryTable(raw) then return nil, "Client item stats are unavailable or restricted." end
    local result, count = {}, 0
    for key, value in pairs(raw) do
        if not plain(key) or not finite(value) then return nil, "Client item stats contain a restricted or invalid value." end
        if value ~= 0 then
            local normalized = statMap[key] or ("unsupported:" .. key)
            if result[normalized] ~= nil then return nil, "Client item stats have an ambiguous repeated mapping." end
            result[normalized], count = value, count + 1
        end
    end
    if count == 0 then return nil, "The client returned no nonzero armor/item stats; no zero-stat fallback is allowed." end
    return result
end

local function readItem(reference, expectedID, expectedSlot, level)
    if combat() then return nil, "unsupported", "Item reads are blocked during combat." end
    if statsRestricted() then return nil, "unsupported", "Client stat restrictions are active or unknown." end
    if failed[expectedID] then return nil, "missing", "The client could not load this item; availability is unknown. Refresh to retry." end
    if not C_Item or type(C_Item.GetItemInfo) ~= "function" or type(C_Item.GetItemStats) ~= "function" then
        return nil, "unsupported", "Required client item APIs are unavailable."
    end
    local ok, name, link, quality, itemLevel, requiredLevel, itemType, subtype, stackCount, equipLoc,
        texture, sellPrice, classID, subclassID, bindType, expansionID, setID = call(C_Item.GetItemInfo, reference)
    if not ok then return nil, "unsupported", "The client item information call failed." end
    if secret(name) or secret(link) then return nil, "unsupported", "The item name or full link is restricted." end
    if name == nil or link == nil then
        if failed[expectedID] then return nil, "missing", "The client could not load this item; availability is unknown. Refresh to retry." end
        request(expectedID)
        if failed[expectedID] then return nil, "missing", "The client could not request this item. Refresh to retry." end
        return nil, "pending", "Waiting for client item data; no database stats are substituted."
    end
    if not plain(name) or not plain(link) or itemID(link) ~= expectedID then
        return nil, "unsupported", "The client item identity is unavailable or does not match the requested item."
    end
    if not plain(equipLoc) or not finite(requiredLevel) or not finite(classID) or not finite(subclassID) or secret(setID) then
        return nil, "unsupported", "The client has not supplied complete, unrestricted armor requirements."
    end
    local expectedLocation = expectedSlot == 7 and "INVTYPE_LEGS" or "INVTYPE_SHOULDER"
    if equipLoc ~= expectedLocation or classID ~= 4 or (subclassID ~= 1 and subclassID ~= 2) or requiredLevel > level then
        return nil, "unsupported", "This pilot only compares wearable cloth/leather in the selected shoulder or leg slot."
    end
    if setID ~= nil and (not finite(setID) or setID ~= 0) then
        return nil, "unsupported", "Set effects are outside this pilot; no model result is shown for this item."
    end
    -- For owned gear, preserve its exact suffix/enchant/bonus-bearing full link.
    local statsLink = type(reference) == "string" and reference or link
    local statsOK, raw = call(C_Item.GetItemStats, statsLink)
    if not statsOK then return nil, "unsupported", "The client item stats call failed." end
    if not secret(raw) and raw == nil then
        if failed[expectedID] then return nil, "missing", "Client item stats remain unavailable. Refresh to retry." end
        request(expectedID)
        if failed[expectedID] then return nil, "missing", "The client could not request this item's stats. Refresh to retry." end
        return nil, "pending", "Waiting for client item stats; no database stats are substituted."
    end
    local stats, reason = normalize(raw)
    if not stats then return nil, "unsupported", reason end
    return { name = name, link = statsLink, itemID = expectedID, stats = stats, slotID = expectedSlot }
end

function ns.ReadEnhancementContext()
    if combat() then return nil, "Talent reads are blocked during combat." end
    if statsRestricted() then return nil, "Client stat restrictions are active or unknown." end
    if not C_ClassTalents or not C_Traits then return nil, "Current trait APIs are unavailable." end
    local ok, configID = call(C_ClassTalents.GetActiveConfigID)
    if not ok or not finite(configID) or configID <= 0 then return nil, "The active talent configuration is unavailable." end
    local stagedOK, staged = call(C_Traits.ConfigHasStagedChanges, configID)
    if not stagedOK or secret(staged) or type(staged) ~= "boolean" or staged then
        return nil, "Apply or discard pending talent changes, then refresh. Committed talent state must be available."
    end
    local infoOK, info = call(C_Traits.GetConfigInfo, configID)
    if not infoOK or not ordinaryTable(info) or not ordinaryTable(info.treeIDs) or not finite(info.treeIDs[1]) then
        return nil, "The active talent tree is unavailable."
    end
    local treeID = info.treeIDs[1]
    local groupsOK, groups = call(C_Traits.GetGroupDisplayInfoByTreeID, treeID)
    if not groupsOK or not ordinaryTable(groups) then return nil, "Talent group evidence is unavailable." end
    local bySkill = { [373] = "enhancement", [375] = "elemental", [374] = "restoration" }
    local mapped, found = {}, {}
    for _, group in ipairs(groups) do
        if not ordinaryTable(group) or not finite(group.groupID) or not finite(group.skillLineID) then
            return nil, "Talent group evidence contains restricted or incomplete fields."
        end
        local branch = bySkill[group.skillLineID]
        if branch then
            if found[branch] or mapped[group.groupID] then return nil, "Talent group mapping is ambiguous." end
            mapped[group.groupID], found[branch] = branch, true
        end
    end
    if not found.enhancement or not found.elemental or not found.restoration then
        return nil, "All three Shaman talent groups must be identifiable before comparison."
    end
    local nodesOK, nodes = call(C_Traits.GetTreeNodes, treeID)
    if not nodesOK or not ordinaryTable(nodes) or #nodes == 0 then return nil, "The active talent nodes are unavailable." end
    local totals, seen, fingerprint = { enhancement = 0, elemental = 0, restoration = 0 }, {}, {}
    for _, nodeID in ipairs(nodes) do
        if not finite(nodeID) or nodeID <= 0 or seen[nodeID] then return nil, "Talent node identities are restricted or ambiguous." end
        seen[nodeID] = true
        local nodeOK, node = call(C_Traits.GetNodeInfo, configID, nodeID)
        if not nodeOK or not ordinaryTable(node) or not finite(node.activeRank) or node.activeRank < 0
            or node.activeRank ~= math.floor(node.activeRank) or not ordinaryTable(node.groupIDs) then
            return nil, "Current talent ranks or group membership are unavailable."
        end
        local matched
        for _, groupID in ipairs(node.groupIDs) do
            if not finite(groupID) then return nil, "Talent group membership is restricted." end
            local branch = mapped[groupID]
            if branch then
                if matched and matched ~= branch then return nil, "A talent node maps to multiple Shaman branches." end
                matched = branch
            end
        end
        -- Nested groups are normal; only the three identified branch groups count.
        if matched then totals[matched] = totals[matched] + node.activeRank end
        fingerprint[#fingerprint + 1] = nodeID .. ":" .. node.activeRank .. ":" .. (matched or "nested")
    end
    local latestOK, latestID = call(C_ClassTalents.GetActiveConfigID)
    if not latestOK or not finite(latestID) or latestID ~= configID then return nil, "Talent configuration changed during the read. Refresh again." end
    local finalStagedOK, finalStaged = call(C_Traits.ConfigHasStagedChanges, configID)
    if not finalStagedOK or secret(finalStaged) or type(finalStaged) ~= "boolean" or finalStaged then
        return nil, "Apply or discard pending talent changes, then refresh. Committed talent state must be available."
    end
    if totals.enhancement <= 0 or totals.enhancement <= totals.elemental or totals.enhancement <= totals.restoration then
        return nil, "Enhancement must have a unique positive talent-rank lead; ties and other builds are outside this pilot."
    end
    table.sort(fingerprint)
    return {
        configID = configID, treeID = treeID, totals = totals,
        signature = configID .. "/" .. treeID .. "/" .. table.concat(fingerprint, ";"),
        label = "Enhancement " .. totals.enhancement .. ", Elemental " .. totals.elemental .. ", Restoration " .. totals.restoration .. " active ranks",
    }
end

local function readContext()
    if combat() then return nil, "The pilot is unavailable during combat." end
    if statsRestricted() then return nil, "Client stat restrictions are active or unknown; no comparison is available." end
    local buildOK, version, build, date, interface = call(GetBuildInfo)
    if not buildOK or not finite(interface) or interface ~= 16001 then return nil, "This local pilot targets Forever Interface 16001 only." end
    local levelOK, level = call(UnitLevel, "player")
    local classOK, localizedClass, class = call(UnitClass, "player")
    if not levelOK or not finite(level) or level ~= 30 or not classOK or not plain(class) or class ~= "SHAMAN" then
        return nil, "This bounded pilot requires a level 30 Shaman."
    end
    if not ns.ReadEnhancementContext then return nil, "Enhancement talent evidence is unavailable." end
    local talents, reason = ns.ReadEnhancementContext()
    if not talents then return nil, reason end
    talents.level = level
    return talents
end

local function refreshRead()
    local state = ns.state
    local candidate = ns.Data.candidates[state.selectedIndex]
    state.candidate = candidate
    state.current, state.proposed, state.context, state.models, state.rawDelta, state.equipmentLink = nil, nil, nil, nil, nil, nil
    local context, contextReason = readContext()
    if not context then mark("unsupported", contextReason); return end
    state.context = context
    if not candidate or (candidate.itemID ~= 6690 and candidate.itemID ~= 6697)
        or (candidate.itemID == 6690 and candidate.slotID ~= 7) or (candidate.itemID == 6697 and candidate.slotID ~= 3) then
        mark("unsupported", "The requested candidate is outside the two-item RFK pilot."); return
    end
    local currentLink, linkStatus, linkReason = equippedLink(candidate.slotID)
    if not currentLink then mark(linkStatus, linkReason); return end
    local currentID = itemID(currentLink)
    if not currentID then mark("unsupported", "The equipped full link has no usable item identity."); return end
    state.equipmentLink = currentLink
    local current, currentStatus, currentReason = readItem(currentLink, currentID, candidate.slotID, context.level)
    local proposed, proposedStatus, proposedReason = readItem(candidate.itemID, candidate.itemID, candidate.slotID, context.level)
    state.current, state.proposed = current, proposed
    if not current or not proposed then
        if currentStatus == "unsupported" or proposedStatus == "unsupported" then
            mark("unsupported", currentStatus == "unsupported" and currentReason or proposedReason)
        elseif currentStatus == "missing" or proposedStatus == "missing" then
            mark("missing", currentStatus == "missing" and currentReason or proposedReason)
        else mark("pending", currentReason or proposedReason) end
        return
    end
    local latestLink = equippedLink(candidate.slotID)
    local latestContext = readContext()
    if latestLink ~= currentLink or not latestContext or latestContext.signature ~= context.signature then
        mark("stale", "Equipment or talent context changed while reading. Refresh to take a new snapshot."); return
    end
    local results, keys, delta = {}, {}, {}
    for key in pairs(current.stats) do keys[key] = true end
    for key in pairs(proposed.stats) do keys[key] = true end
    for key in pairs(keys) do
        local change = (proposed.stats[key] or 0) - (current.stats[key] or 0)
        if not finite(change) then mark("unsupported", "A raw stat delta is outside the supported numeric range."); return end
        delta[key] = change
    end
    state.rawDelta = delta
    local unsupported
    for _, model in ipairs(ns.Data.models) do
        local ok, comparison = call(ns.Model.Compare, current.stats, proposed.stats, model.weights)
        if not ok or type(comparison) ~= "table" then
            comparison = { ok = false, reason = "The fixed model could not evaluate these stats." }
        end
        results[#results + 1] = { model = model, comparison = comparison }
        if not comparison.ok then unsupported = unsupported or comparison.reason end
    end
    state.models = results
    if unsupported then
        state.status, state.reason = "unsupported", "No model verdict: " .. ns.SafeText(unsupported)
    else
        state.status, state.reason = "ready", "Client snapshot ready. Weighted points describe these fixed models, not DPS or BiS."
    end
end

local function runRefresh()
    if busy or not visible() or combat() then return end
    busy = true
    local ok = pcall(refreshRead)
    busy = false
    if not ok then mark("unsupported", "The client returned data this pilot cannot safely interpret. No result is shown.") end
    render()
end

function ns.Refresh()
    if busy or not visible() or combat() then return end
    generation = generation + 1
    requested, pending, failed, asyncScheduled = {}, {}, {}, false
    runRefresh()
end
function ns.SelectCandidate(index)
    if not finite(index) or (index ~= 1 and index ~= 2) then return end
    ns.state.selectedIndex = index
    ns.Refresh()
end
function ns.Invalidate(reason)
    generation = generation + 1
    requested, pending, failed, asyncScheduled = {}, {}, {}, false
    mark("stale", reason or "This snapshot is stale. Refresh to read current client data.")
    ns.state.rawDelta, ns.state.current, ns.state.proposed, ns.state.context, ns.state.equipmentLink = nil, nil, nil, nil, nil
    if GameTooltip then GameTooltip:Hide() end
    render()
end
function ns.ShowItemTooltip(owner, role)
    if combat() or statsRestricted() or not visible() or not GameTooltip then return end
    local item = role == "current" and ns.state.current or ns.state.proposed
    if not item or not plain(item.link) then return end
    local ok = pcall(function()
        GameTooltip:SetOwner(owner, "ANCHOR_RIGHT")
        GameTooltip:SetHyperlink(item.link)
        GameTooltip:Show()
    end)
    if not ok then GameTooltip:Hide() end
end
function ns.OnWindowHidden()
    ns.Invalidate("The previous snapshot was closed. Reopen to read fresh client data.")
end
function ns.Open()
    if combat() then
        if DEFAULT_CHAT_FRAME then DEFAULT_CHAT_FRAME:AddMessage("GearEvidencePilot: open the pilot outside combat.") end
        return
    end
    if not ns.window then ns.CreateWindow() end
    ns.window:Show()
    if ns.FitWindow then ns.FitWindow() end
    ns.Refresh()
end

local events = CreateFrame("Frame")
for _, event in ipairs({ "PLAYER_REGEN_DISABLED", "PLAYER_EQUIPMENT_CHANGED", "TRAIT_CONFIG_UPDATED", "UNIT_LEVEL", "ITEM_DATA_LOAD_RESULT", "ADDON_RESTRICTION_STATE_CHANGED" }) do
    events:RegisterEvent(event)
end
events:SetScript("OnEvent", function(_, event, first, second)
    if event == "PLAYER_REGEN_DISABLED" then
        if ns.window then ns.window:Hide() end
        ns.Invalidate("Combat invalidated this snapshot. Reopen outside combat.")
    elseif event == "PLAYER_EQUIPMENT_CHANGED" then
        if not finite(first) or first == 3 or first == 7 then ns.Invalidate("Equipment changed. Refresh to compare the current items.") end
    elseif event == "TRAIT_CONFIG_UPDATED" then
        ns.Invalidate("Talents changed. Refresh to verify the Enhancement context.")
    elseif event == "ADDON_RESTRICTION_STATE_CHANGED" then
        ns.Invalidate("Client restrictions changed. Refresh after unrestricted data is available.")
    elseif event == "UNIT_LEVEL" then
        if not plain(first) or first == "player" then ns.Invalidate("Player level changed. Refresh to verify the pilot's scope.") end
    elseif event == "ITEM_DATA_LOAD_RESULT" then
        if not finite(first) or secret(second) or type(second) ~= "boolean" or not visible() or combat() or not pending[first] then return end
        pending[first] = nil
        if not second then failed[first] = true end
        if asyncScheduled then return end
        if not C_Timer or type(C_Timer.After) ~= "function" then
            ns.Invalidate("Item data changed. Refresh to read it."); return
        end
        local expectedGeneration = generation
        asyncScheduled = true
        C_Timer.After(0, function()
            if generation ~= expectedGeneration then return end
            asyncScheduled = false
            if not visible() or combat() then return end
            if busy then
                mark("pending", "Item data arrived during a read. Refresh to read the loaded data."); render(); return
            end
            local latestLink = equippedLink(ns.state.candidate.slotID)
            local latestContext = readContext()
            if latestLink ~= ns.state.equipmentLink or not latestContext or not ns.state.context
                or latestContext.signature ~= ns.state.context.signature then
                ns.Invalidate("Equipment or talents changed while item data loaded. Refresh for a new comparison.")
                return
            end
            runRefresh()
        end)
    end
end)
ns.eventFrame = events
SLASH_GEAREVIDENCEPILOT1 = "/gearevidence"
SlashCmdList.GEAREVIDENCEPILOT = function() ns.Open() end
