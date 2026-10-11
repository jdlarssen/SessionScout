-- Run from repository root using Lua 5.1:
-- lua experiments/GearEvidencePilot/tests/test_model.lua
local ns = {}
assert(loadfile("experiments/GearEvidencePilot/Data.lua"))("GearEvidencePilot", ns)
assert(loadfile("experiments/GearEvidencePilot/Model.lua"))("GearEvidencePilot", ns)
local compare, tests = ns.Model.Compare, 0

local function test(name, fn)
    local ok, reason = pcall(fn)
    if not ok then error(name .. ": " .. tostring(reason), 0) end
    tests = tests + 1
end
local function near(actual, expected)
    assert(type(actual) == "number" and math.abs(actual - expected) < 1e-9,
        "expected " .. tostring(expected) .. ", got " .. tostring(actual))
end
local function fails(result)
    assert(result.ok == false and type(result.reason) == "string" and #result.reason > 0)
    assert(type(result.unsupportedStats) == "table")
    assert(result.before == nil and result.after == nil and result.delta == nil)
end
local function copy(t)
    local out = {}
    for k, v in pairs(t) do out[k] = v end
    return out
end
local function equal(a, b)
    for k, v in pairs(a) do assert(v == b[k], "changed value: " .. tostring(k)) end
    for k, v in pairs(b) do assert(v == a[k], "changed key: " .. tostring(k)) end
end

test("both fixture swaps reproduce independently calculated model scores", function()
    local cases = {
        {5964, 6697, {{12.95, 15.44, 2.49}, {6.5062, 8.224, 1.7178}}},
        {252516, 6690, {{19.12, 39.80, 20.68}, {11.6005, 14.464, 2.8635}}},
    }
    for _, case in ipairs(cases) do
        for i, model in ipairs(ns.Data.models) do
            local r = compare(ns.Data.items[case[1]].stats, ns.Data.items[case[2]].stats, model.weights)
            assert(r.ok)
            near(r.before, case[3][i][1]); near(r.after, case[3][i][2]); near(r.delta, case[3][i][3])
            assert(#r.unsupportedStats == 0)
        end
    end
end)

test("raw stat differences include lost stats and unweighted armor", function()
    local r = compare(ns.Data.items[5964].stats, ns.Data.items[6697].stats, ns.Data.models[1].weights)
    assert(r.ok)
    near(r.deltaStats.armor, -38); near(r.deltaStats.str, -5)
    near(r.deltaStats.agi, -2); near(r.deltaStats.sta, -6)
    near(r.deltaStats.int, 11); near(r.deltaStats.sp, 6); near(r.deltaStats.mp5, 0)
end)

test("zero is an explicit weight and omitted zero stats need no weight", function()
    local r = compare({armor = 20, str = 0}, {armor = 100}, {armor = 0})
    assert(r.ok); near(r.delta, 0); near(r.deltaStats.armor, 80)
    assert(compare({}, {}, {}).ok)
end)

test("nonzero unknown stats fail even when the unknown stat has a weight", function()
    local r = compare({haste = 1}, {haste = 1, avoidance = 2}, {haste = 0, avoidance = 1})
    fails(r)
    assert(#r.unsupportedStats == 2 and r.unsupportedStats[1] == "avoidance" and r.unsupportedStats[2] == "haste")
    assert(compare({haste = 0}, {}, {}).ok)
end)

test("nonzero supported stats without weights fail even if swap delta is zero", function()
    local r = compare({crit = 2}, {crit = 2}, {str = 2})
    fails(r); assert(#r.unsupportedStats == 1 and r.unsupportedStats[1] == "crit")
    assert(compare({crit = 2}, {crit = 2}, {crit = 0}).ok)
end)

test("unknown nonzero coefficients cannot silently vanish", function()
    local r = compare({}, {}, {strenght = 2})
    fails(r); assert(r.unsupportedStats[1] == "strenght")
end)

test("missing tables and malformed keys fail", function()
    fails(compare(nil, {}, {})); fails(compare({}, false, {})); fails(compare({}, {}, nil))
    fails(compare({[1] = 2}, {}, {})); fails(compare({}, {}, {[false] = 1}))
end)

test("nonfinite and nonnumeric values fail in every input", function()
    local values = {"2", false, {}, math.huge, -math.huge, 0/0}
    for _, value in ipairs(values) do
        fails(compare({str = value}, {}, {str = 2}))
        fails(compare({}, {str = value}, {str = 2}))
        fails(compare({}, {}, {str = value}))
    end
end)

test("overflow is rejected rather than displayed as a score", function()
    fails(compare({str = 1e308}, {}, {str = 2}))
    fails(compare({str = -1e308}, {str = 1e308}, {str = 0}))
    fails(compare({str = 1e308, agi = 1e308}, {}, {str = 1, agi = 1}))
end)

test("all normalized keys and finite negative weights have defined arithmetic", function()
    local r = compare({hit = 2, crit = 3, expertise = 4, mp5 = 5, weaponDps = 6},
        {hit = 3, crit = 4, expertise = 5, mp5 = 6, weaponDps = 7},
        {hit = 1, crit = 2, expertise = 3, mp5 = 4, weaponDps = -1})
    assert(r.ok); near(r.before, 34); near(r.after, 43); near(r.delta, 9)
end)

test("success, failure and output edits never mutate input tables", function()
    local current, candidate, weights = {str = 4, armor = 9}, {int = 3, armor = 6}, {str = 2, int = 1, armor = 0}
    local a, b, c = copy(current), copy(candidate), copy(weights)
    local r = compare(current, candidate, weights)
    assert(r.ok); r.deltaStats.str = 100; r.unsupportedStats[1] = "anything"
    equal(current, a); equal(candidate, b); equal(weights, c)
    candidate.unknown = 3; b.unknown = 3
    fails(compare(current, candidate, weights))
    equal(current, a); equal(candidate, b); equal(weights, c)
end)

print("GearEvidencePilot model: " .. tests .. " tests passed (" .. _VERSION .. ")")
