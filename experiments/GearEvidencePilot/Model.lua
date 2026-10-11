-- Pure Lua 5.1; no game APIs or SavedVariables.
-- Compare(currentStats, candidateStats, weights) returns ONE result table:
--   success: {ok=true, before=number, after=number, delta=number,
--             deltaStats={[normalizedKey]=number}, unsupportedStats={}}
--   failure: {ok=false, reason=string, unsupportedStats={sorted key names}}
-- Supported normalized keys: armor,str,agi,sta,int,spi,ap,sp,hit,crit,
-- expertise,mp5,weaponDps. Absent item stats mean zero, not unknown data.
-- The caller must first establish complete item data. A nonzero item stat
-- needs an explicit weight; zero weights are valid. Unknown nonzero stats or
-- weights fail. Every supplied value must be a finite number. No input is
-- mutated. Scores are linear model points, never measured DPS or a BiS claim.
local _, ns = ...
local Model = {}
ns.Model = Model

local statKeys = {
    "armor", "str", "agi", "sta", "int", "spi", "ap", "sp",
    "hit", "crit", "expertise", "mp5", "weaponDps",
}
local supported = {}
for _, key in ipairs(statKeys) do supported[key] = true end

local function finite(value)
    return type(value) == "number" and value == value
        and value ~= math.huge and value ~= -math.huge
end

local function failure(reason, unsupportedStats)
    return { ok = false, reason = reason, unsupportedStats = unsupportedStats or {} }
end

local function validate(input, label)
    if type(input) ~= "table" then return label .. " must be a table" end
    for key, value in pairs(input) do
        if type(key) ~= "string" then
            return label .. " contains a non-string stat key"
        end
        if not finite(value) then
            return label .. "." .. key .. " must be a finite number"
        end
    end
end

function Model.Compare(currentStats, candidateStats, weights)
    local reason = validate(currentStats, "currentStats")
        or validate(candidateStats, "candidateStats") or validate(weights, "weights")
    if reason then return failure(reason) end

    local unsupportedSet = {}
    local hasUnknown, hasMissingWeight = false, false
    for _, stats in ipairs({ currentStats, candidateStats }) do
        for key, value in pairs(stats) do
            if value ~= 0 then
                if not supported[key] then
                    unsupportedSet[key], hasUnknown = true, true
                elseif weights[key] == nil then
                    unsupportedSet[key], hasMissingWeight = true, true
                end
            end
        end
    end
    for key, value in pairs(weights) do
        if not supported[key] and value ~= 0 then
            unsupportedSet[key], hasUnknown = true, true
        end
    end
    local unsupportedStats = {}
    for key in pairs(unsupportedSet) do unsupportedStats[#unsupportedStats + 1] = key end
    table.sort(unsupportedStats)
    if #unsupportedStats > 0 then
        local detail = hasUnknown and "Unsupported nonzero stat or weight" or "Missing explicit weight"
        if hasUnknown and hasMissingWeight then detail = detail .. "; missing explicit weight" end
        return failure(detail .. ": " .. table.concat(unsupportedStats, ", "), unsupportedStats)
    end

    local before, after, deltaStats = 0, 0, {}
    for _, key in ipairs(statKeys) do
        local current = currentStats[key] or 0
        local candidate = candidateStats[key] or 0
        local weight = weights[key] or 0
        local difference = candidate - current
        local currentPoints, candidatePoints = current * weight, candidate * weight
        if not finite(difference) or not finite(currentPoints) or not finite(candidatePoints) then
            return failure("Numeric overflow for stat: " .. key)
        end
        deltaStats[key] = difference
        before, after = before + currentPoints, after + candidatePoints
        if not finite(before) or not finite(after) then
            return failure("Numeric overflow in model score")
        end
    end
    local delta = after - before
    if not finite(delta) then return failure("Numeric overflow in score difference") end
    return {
        ok = true, before = before, after = after, delta = delta,
        deltaStats = deltaStats, unsupportedStats = {},
    }
end
