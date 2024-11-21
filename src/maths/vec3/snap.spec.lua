-- ROBLOX NOTE: no upstream
local JestGlobals = require("@DevPackages/JestGlobals")
local test, expect = JestGlobals.test, JestGlobals.expect

local snap, create
do
	local ref = require("./init")
	snap, create = ref.snap, ref.create
end
local compareVectors = require("../../../test/helpers/init").compareVectors
test("vec3. snap() should return vec3 with correct values", function()
	local output = create()
	local obs1 = snap(output, { 0, 0, 0 }, 0.1)
	expect(compareVectors(obs1, { 0, 0, 0 })).toBe(true)
	expect(compareVectors(output, { 0, 0, 0 })).toBe(true)
	local obs2 = snap(output, { 1, 2, 3 }, 0.1)
	expect(compareVectors(obs2, { 1, 2, 3 })).toBe(true)
	expect(compareVectors(output, { 1, 2, 3 })).toBe(true)
	local obs3 = snap(output, { -1, -2, -3 }, 0.01)
	expect(compareVectors(obs3, { -1, -2, -3 })).toBe(true)
	expect(compareVectors(output, { -1, -2, -3 })).toBe(true)
	local obs4 = snap(output, { -1.123456789, -2.123456789, -3.123456789 }, 0.01)
	expect(compareVectors(obs4, { -1.12, -2.12, -3.12 })).toBe(true)
	expect(compareVectors(output, { -1.12, -2.12, -3.12 })).toBe(true)
	local obs5 = snap(output, { -1.123456789, -2.123456789, -3.123456789 }, 0.0001)
	expect(compareVectors(obs5, { -1.1235, -2.1235, -3.1235 })).toBe(true)
	expect(compareVectors(output, { -1.1235, -2.1235, -3.1235 })).toBe(true)
	local obs6 = snap(output, { -1.123456789, -2.123456789, -3.123456789 }, 0.000001)
	expect(compareVectors(obs6, { -1.123457, -2.1234569999999997, -3.1234569999999997 })).toBe(true)
	expect(compareVectors(output, { -1.123457, -2.1234569999999997, -3.1234569999999997 })).toBe(true)
end)
