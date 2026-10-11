-- Runtime boundary tests. No WoW process, installed addon, network or UI is used.
local base = "experiments/GearEvidencePilot/"
local tests = 0

local function test(name, fn)
    local ok, reason = pcall(fn)
    if not ok then error(name .. ": " .. tostring(reason), 0) end
    tests = tests + 1
end

local function clone(value)
    if type(value) ~= "table" then return value end
    local out = {}
    for key, child in pairs(value) do out[key] = clone(child) end
    return out
end

local function fixture()
    local f = {
        level = 30, class = "SHAMAN", combat = false, restricted = false, staged = false,
        configID = 41, configReads = 0, requests = {}, statsReads = {}, infoReads = {},
        timers = {}, frames = {}, secrets = {}, notifications = 0,
        groups = {
            {groupID = 100, skillLineID = 373, treeID = 1082},
            {groupID = 200, skillLineID = 375, treeID = 1082},
            {groupID = 300, skillLineID = 374, treeID = 1082},
        },
        nodes = {
            [1] = {activeRank = 5, groupIDs = {100, 9001}},
            [2] = {activeRank = 3, groupIDs = {100}},
            [3] = {activeRank = 2, groupIDs = {200}},
            [4] = {activeRank = 0, groupIDs = {300}},
        },
        equipped = {
            [3] = "item:5964:77:0:0:0:0:42:0:30:0:0:0:1:999",
            [7] = "item:252516:0:0:0:0:0:0:0:30:0:0:0:0",
        },
    }
    f.items = {
        [5964] = {name = "Current shoulders", loaded = true, equipLoc = "INVTYPE_SHOULDER",
            stats = {RESISTANCE0_NAME = 76, ITEM_MOD_STRENGTH_SHORT = 5,
                ITEM_MOD_AGILITY_SHORT = 5, ITEM_MOD_STAMINA_SHORT = 6}},
        [252516] = {name = "Current legs", loaded = true, equipLoc = "INVTYPE_LEGS",
            stats = {RESISTANCE0_NAME = 90, ITEM_MOD_STRENGTH_SHORT = 7,
                ITEM_MOD_AGILITY_SHORT = 9, ITEM_MOD_STAMINA_SHORT = 7, ITEM_MOD_SPIRIT_SHORT = 6}},
        [6697] = {name = "Candidate shoulders", loaded = true, equipLoc = "INVTYPE_SHOULDER",
            stats = {RESISTANCE0_NAME = 38, ITEM_MOD_INTELLECT_SHORT = 11,
                ITEM_MOD_AGILITY_SHORT = 3, ITEM_MOD_SPELL_POWER_SHORT = 6}},
        [6690] = {name = "Candidate legs", loaded = true, equipLoc = "INVTYPE_LEGS",
            stats = {RESISTANCE0_NAME = 96, ITEM_MOD_INTELLECT_SHORT = 12, ITEM_MOD_ATTACK_POWER_SHORT = 26}},
        [90001] = {name = "Newly equipped shoulders", loaded = true, equipLoc = "INVTYPE_SHOULDER",
            stats = {RESISTANCE0_NAME = 100, ITEM_MOD_STRENGTH_SHORT = 50}},
    }
    for id, item in pairs(f.items) do item.link = "item:" .. id .. ":0:0:0:0:0:0:0:30:0:0:0:0" end

    function f:emit(event, ...)
        for _, frame in ipairs(self.frames) do
            if frame.events[event] and frame.scripts.OnEvent then
                frame.scripts.OnEvent(frame, event, ...)
            end
        end
    end
    function f:drain()
        local count = 0
        while #self.timers > 0 do
            count = count + 1
            assert(count <= 30, "unbounded deferred callback/retry loop")
            table.remove(self.timers, 1)()
        end
    end
    function f:deliver(id, success)
        if success and self.items[id] then self.items[id].loaded = true end
        self:emit("ITEM_DATA_LOAD_RESULT", id, success)
    end
    function f:secret()
        local value = {}
        self.secrets[value] = true
        return value
    end

    _G.issecretvalue = function(value) return f.secrets[value] == true end
    _G.canaccessvalue = function(value) return f.secrets[value] ~= true end
    _G.InCombatLockdown = function() return f.combat end
    _G.C_Secrets = {ShouldUnitStatsBeSecret = function() return f.restricted end}
    _G.UnitLevel = function(unit) assert(unit == "player"); return f.level end
    _G.UnitClass = function(unit) assert(unit == "player"); return "Class name", f.class, f.class == "SHAMAN" and 7 or 8 end
    _G.GetBuildInfo = function() return "1.60.1", "70338", "test", 16001 end
    _G.GetTime = function() return 100 end
    _G.time = function() return 1791740000 end
    _G.date = function() return "2026-10-11 19:00" end
    _G.C_Timer = {After = function(_, callback) f.timers[#f.timers + 1] = callback end}
    _G.CreateFrame = function()
        local frame = {events = {}, scripts = {}}
        function frame:RegisterEvent(event) self.events[event] = true end
        function frame:UnregisterEvent(event) self.events[event] = nil end
        function frame:SetScript(event, callback) self.scripts[event] = callback end
        f.frames[#f.frames + 1] = frame
        return frame
    end
    _G.ItemLocation = {CreateFromEquipmentSlot = function(_, slot)
        assert(slot == 3 or slot == 7, "unexpected equipment access")
        return {slot = slot}
    end}
    local function idOf(query)
        if type(query) == "number" then return query end
        return type(query) == "string" and tonumber(query:match("item:(%d+)")) or nil
    end
    _G.C_Item = {
        DoesItemExist = function(location) return f.equipped[location.slot] ~= nil end,
        GetItemLink = function(location) return f.equipped[location.slot] end,
        GetItemInfo = function(query)
            f.infoReads[#f.infoReads + 1] = query
            local item = f.items[idOf(query)]
            if not item or not item.loaded then return nil end
            return item.name, item.link, 2, 30, 27, "Armor", "Leather", 1,
                item.equipLoc, 0, 1, 4, 2, 1, 0, item.setID
        end,
        GetItemStats = function(query)
            f.statsReads[#f.statsReads + 1] = query
            if f.statsOverride then
                local handled, stats = f.statsOverride(query)
                if handled then return stats end
            end
            local item = f.items[idOf(query)]
            if not item or not item.loaded then return nil end
            return item.stats
        end,
        RequestLoadItemDataByID = function(id)
            f.requests[id] = (f.requests[id] or 0) + 1
            if f.syncLoads then f:deliver(id, true) end
        end,
    }
    _G.C_ClassTalents = {GetActiveConfigID = function()
        f.configReads = f.configReads + 1
        if f.configFlipAt and f.configReads >= f.configFlipAt then return f.configID + 1 end
        return f.configID
    end}
    _G.C_Traits = {
        ConfigHasStagedChanges = function() return f.staged end,
        GetConfigInfo = function() return f.configInfo or {treeIDs = {1082}} end,
        GetGroupDisplayInfoByTreeID = function() return f.groups end,
        GetTreeNodes = function() return {1, 2, 3, 4} end,
        GetNodeInfo = function(_, id) return f.nodes[id] end,
    }
    _G.SlashCmdList = {}
    _G.DEFAULT_CHAT_FRAME = {AddMessage = function() end}
    local function forbidden() error("adapter called a game mutation or communication API", 0) end
    _G.EquipItemByName, _G.PickupInventoryItem, _G.UseContainerItem = forbidden, forbidden, forbidden
    _G.SendChatMessage, _G.SendAddonMessage = forbidden, forbidden

    f.ns = {}
    assert(loadfile(base .. "Data.lua"))("GearEvidencePilot", f.ns)
    assert(loadfile(base .. "Model.lua"))("GearEvidencePilot", f.ns)
    assert(loadfile(base .. "Core.lua"))("GearEvidencePilot", f.ns)
    f.ns.window = {shown = true}
    function f.ns.window:IsShown() return self.shown end
    function f.ns.window:Show() self.shown = true end
    function f.ns.window:Hide()
        self.shown = false
        if f.ns.OnWindowHidden then f.ns.OnWindowHidden() end
    end
    f.ns.Render = function() f.notifications = f.notifications + 1 end
    function f:refresh(index)
        if index then self.ns.SelectCandidate(index) else self.ns.Refresh() end
        return self.ns.state
    end
    return f
end

-- The assertions below exercise the adapter's public refresh result and events.
local function ready(f)
    assert(f.ns.state.status == "ready", tostring(f.ns.state.status) .. ": " .. tostring(f.ns.state.reason))
    assert(#f.ns.state.models == 2)
    for _, row in ipairs(f.ns.state.models) do assert(row.comparison.ok == true) end
end
local function blocked(f)
    assert(f.ns.state.status ~= "ready", "unverified client data produced a ready comparison")
    for _, row in ipairs(f.ns.state.models or {}) do
        assert(row.comparison.ok ~= true, "blocked comparison retained a successful model verdict")
    end
end
local function saw(list, wanted)
    for _, value in ipairs(list) do if value == wanted then return true end end
    return false
end

test("both supported slots score live stats and accept nested trait groups", function()
    local f = fixture()
    f:refresh(1); ready(f)
    assert(f.ns.state.current.itemID == 252516 and f.ns.state.proposed.itemID == 6690)
    f:refresh(2); ready(f)
    assert(f.ns.state.current.itemID == 5964 and f.ns.state.proposed.itemID == 6697)
    assert(f.ns.state.current.stats.armor == 76 and f.ns.state.rawDelta.armor == -38)
    assert(next(f.requests) == nil)
end)

test("class level and client version gates run before item reads", function()
    for _, change in ipairs({
        function(f) f.class = "MAGE" end,
        function(f) f.level = 29 end,
        function(f) f.level = 31 end,
        function(f) f.level = nil end,
        function(f) f.level = f:secret() end,
        function(f) f.class = f:secret() end,
        function() GetBuildInfo = function() return "other", "1", "test", 11509 end end,
    }) do
        local f = fixture(); change(f); f:refresh(); blocked(f)
        assert(#f.infoReads == 0 and #f.statsReads == 0)
    end
end)

test("Enhancement must be positive unique and actually resolved", function()
    for _, change in ipairs({
        function(f) f.nodes[1].activeRank = 0; f.nodes[2].activeRank = 0 end,
        function(f) f.nodes[3].activeRank = 8 end,
        function(f) for _, node in pairs(f.nodes) do node.activeRank = 0 end end,
        function(f) f.groups[3] = nil end,
        function(f) f.nodes[1].activeRank = nil end,
        function(f) f.nodes[1].activeRank = f:secret() end,
        function(f) f.groups[1].skillLineID = f:secret() end,
        function(f) f.nodes[2] = nil end,
        function() C_ClassTalents = nil end,
        function() C_Traits.GetTreeNodes = nil end,
    }) do
        local f = fixture(); change(f); f:refresh(); blocked(f)
        assert(#f.statsReads == 0)
    end
end)

test("a talent configuration changed during traversal is not scored", function()
    local f = fixture(); f.configFlipAt = 2
    f:refresh(); blocked(f)
end)

test("staged or unverified talent edits block before item access", function()
    for _, change in ipairs({
        function(f) f.staged = true end,
        function(f) f.staged = nil end,
        function(f) f.staged = 0 end,
        function(f) f.staged = f:secret() end,
        function() C_Traits.ConfigHasStagedChanges = nil end,
        function() C_Traits.ConfigHasStagedChanges = function() error("staged read failed") end end,
    }) do
        local f = fixture(); change(f); f:refresh(); blocked(f)
        assert(#f.infoReads == 0 and #f.statsReads == 0)
    end
end)

test("talent edits staged during traversal cannot produce a mixed snapshot", function()
    local f = fixture()
    local calls = 0
    C_Traits.ConfigHasStagedChanges = function()
        calls = calls + 1
        return calls >= 2
    end
    f:refresh(); blocked(f)
    assert(calls >= 2 and #f.infoReads == 0 and #f.statsReads == 0)
end)

test("uncached candidate never falls back to the research item fixture", function()
    local f = fixture(); f.items[6690].loaded = false
    f:refresh(); blocked(f)
    assert(f.ns.state.status == "pending" and f.requests[6690] == 1)
    f:deliver(6690, false); f:drain(); blocked(f)
    assert(f.ns.state.status == "missing" and f.requests[6690] == 1)
end)

test("named item with missing or empty stat table is never scored as zero", function()
    local f = fixture(); f.items[6690].stats = nil
    f:refresh(); blocked(f)
    assert(f.requests[6690] == 1)
    f:deliver(6690, true); f:drain(); blocked(f)
    assert(f.requests[6690] == 1, "load success caused an endless request cycle")
    local g = fixture(); g.items[6690].stats = {}
    g:refresh(); blocked(g)
end)

test("unknown or unweighted client stats suppress the fixed model verdict", function()
    for _, key in ipairs({"ITEM_MOD_HASTE_RATING_SHORT", "ITEM_MOD_SPELL_DAMAGE_DONE_SHORT", "ITEM_MOD_SPELL_HEALING_DONE_SHORT"}) do
        local f = fixture(); f.items[6690].stats[key] = 2
        f:refresh(); blocked(f)
    end
end)

test("owned suffix and enchant bearing link is preserved for stat reads", function()
    local f = fixture()
    local owned = f.equipped[3]
    local variantStats = clone(f.items[5964].stats)
    variantStats.ITEM_MOD_STRENGTH_SHORT = 9
    f.statsOverride = function(query)
        if query == owned then return true, variantStats end
        return false
    end
    f:refresh(2); ready(f)
    assert(f.ns.state.current.link == owned and f.ns.state.current.stats.str == 9)
    assert(saw(f.infoReads, owned) and saw(f.statsReads, owned))
    assert(not saw(f.statsReads, f.items[5964].link), "equipped variant reduced to its base item")
    assert(f.items[5964].stats.ITEM_MOD_STRENGTH_SHORT == 5, "adapter mutated source stats")
end)

test("synchronous item load event reaches ready through one deferred reread", function()
    local f = fixture(); f.items[6690].loaded = false; f.syncLoads = true
    f:refresh(); blocked(f)
    assert(f.requests[6690] == 1 and #f.timers == 1)
    f:drain(); ready(f)
    assert(f.requests[6690] == 1 and #f.timers == 0)
end)

test("equipment event invalidates an outstanding result and refresh reads new gear", function()
    local f = fixture(); f.items[6697].loaded = false
    f:refresh(2); blocked(f)
    f:deliver(6697, true)
    f.equipped[3] = f.items[90001].link
    f:emit("PLAYER_EQUIPMENT_CHANGED", 3, true)
    f:drain(); blocked(f)
    assert(f.ns.state.status == "stale")
    f:refresh(); ready(f)
    assert(f.ns.state.current.itemID == 90001 and f.ns.state.current.stats.str == 50)
end)

test("deferred load cannot silently score different gear before its change event", function()
    local f = fixture(); f.items[6697].loaded = false
    f:refresh(2); f:deliver(6697, true)
    f.equipped[3] = f.items[90001].link
    f:drain(); blocked(f)
    assert(f.ns.state.status == "stale")
    f:refresh(); ready(f)
    assert(f.ns.state.current.itemID == 90001)
end)

test("candidate switch cannot be overwritten by a previous deferred result", function()
    local f = fixture(); f.items[6690].loaded = false
    f:refresh(1); f:deliver(6690, true)
    f:refresh(2); ready(f)
    f:drain(); ready(f)
    assert(f.ns.state.candidate.itemID == 6697 and f.ns.state.proposed.itemID == 6697)
end)

test("changing equipment during a read prevents publishing a mixed snapshot", function()
    local f = fixture()
    local switched = false
    f.statsOverride = function(query)
        if not switched and query == f.items[6697].link then
            f.equipped[3] = f.items[90001].link; switched = true
        end
        return false
    end
    f:refresh(2); blocked(f)
    assert(f.ns.state.status == "stale")
end)

test("closing the pilot discards its deferred refresh", function()
    local f = fixture(); f.items[6690].loaded = false
    f:refresh(); f:deliver(6690, true)
    f.ns.window:Hide()
    local reads = #f.infoReads
    f:drain(); blocked(f)
    assert(#f.infoReads == reads)
end)

test("combat invalidates existing results and prevents pending item reads", function()
    local f = fixture(); f:refresh(); ready(f)
    f.combat = true; f:emit("PLAYER_REGEN_DISABLED")
    local reads = #f.infoReads
    f:refresh(); f:drain(); blocked(f)
    assert(not f.ns.window:IsShown() and #f.infoReads == reads)
    local g = fixture(); g.items[6690].loaded = false
    g:refresh(); g:deliver(6690, true)
    g.combat = true; g:emit("PLAYER_REGEN_DISABLED")
    local pendingReads = #g.infoReads
    g:drain(); blocked(g)
    assert(#g.infoReads == pendingReads)
end)

test("secret restriction predicate blocks before item access", function()
    local f = fixture(); f.restricted = true
    f:refresh(); blocked(f)
    assert(#f.infoReads == 0 and #f.statsReads == 0)
end)

test("restricted item values and keys are rejected without throwing", function()
    for _, change in ipairs({
        function(f) f.items[6690].stats = f:secret() end,
        function(f) f.items[6690].stats.ITEM_MOD_INTELLECT_SHORT = f:secret() end,
        function(f) f.items[6690].stats[f:secret()] = 2 end,
        function(f) f.items[6690].name = f:secret() end,
        function(f) f.equipped[7] = f:secret() end,
    }) do
        local f = fixture(); change(f); f:refresh(); blocked(f)
    end
end)

test("inaccessible values are rejected even when issecretvalue is false", function()
    local f = fixture()
    local inaccessible = f.items[6690].stats
    canaccessvalue = function(value) return value ~= inaccessible end
    f:refresh(); blocked(f)
end)

test("secret asynchronous event arguments do not consume a valid pending request", function()
    local f = fixture(); f.items[6690].loaded = false
    f:refresh()
    f:emit("ITEM_DATA_LOAD_RESULT", f:secret(), true)
    f:emit("ITEM_DATA_LOAD_RESULT", 6690, f:secret())
    assert(#f.timers == 0)
    f:deliver(6690, true); f:drain(); ready(f)
end)

test("missing API and thrown reads cannot produce a model result", function()
    for _, change in ipairs({
        function() C_Item.GetItemStats = nil end,
        function() C_Item.GetItemStats = function() error("read failed") end end,
        function(f) f.equipped[7] = nil end,
        function(f) f.items[6690].equipLoc = "INVTYPE_SHOULDER" end,
        function(f) f.items[6690].setID = 123 end,
    }) do
        local f = fixture(); change(f); f:refresh(); blocked(f)
    end
end)

print("GearEvidencePilot core: " .. tests .. " runtime boundary tests passed (" .. _VERSION .. ")")
