-- ROBLOX NOTE: no upstream
local JestGlobals = require("@DevPackages/JestGlobals")
local test, expect = JestGlobals.test, JestGlobals.expect

local scale, fromValues
do
	local ref = require("./init")
	scale, fromValues = ref.scale, ref.fromValues
end
local compareVectors = require("../../../test/helpers/init").compareVectors
test("vec3. scale() called with three parameters should update a vec3 with correct values", function()
	local obs1 = fromValues(0, 0, 0)
	local ret1 = scale(obs1, { 0, 0, 0 }, 0)
	expect(compareVectors(obs1, { 0, 0, 0 })).toBe(true)
	expect(compareVectors(ret1, { 0, 0, 0 })).toBe(true)
	local obs2 = fromValues(0, 0, 0)
	local ret2 = scale(obs2, { 1, 2, 3 }, 0)
	expect(compareVectors(obs2, { 0, 0, 0 })).toBe(true)
	expect(compareVectors(ret2, { 0, 0, 0 })).toBe(true)
	local obs3 = fromValues(0, 0, 0)
	local ret3 = scale(obs3, { 1, 2, 3 }, 6)
	expect(compareVectors(obs3, { 6, 12, 18 })).toBe(true)
	expect(compareVectors(ret3, { 6, 12, 18 })).toBe(true)
	local obs4 = fromValues(0, 0, 0)
	local ret4 = scale(obs4, { 1, 2, 3 }, -6)
	expect(compareVectors(obs4, { -6, -12, -18 })).toBe(true)
	expect(compareVectors(ret4, { -6, -12, -18 })).toBe(true)
	local obs5 = fromValues(0, 0, 0)
	local ret5 = scale(obs5, { -1, -2, -3 }, 6)
	expect(compareVectors(obs5, { -6, -12, -18 })).toBe(true)
	expect(compareVectors(ret5, { -6, -12, -18 })).toBe(true)
	local obs6 = fromValues(0, 0, 0)
	local ret6 = scale(obs6, { -1, -2, -3 }, -6)
	expect(compareVectors(obs6, { 6, 12, 18 })).toBe(true)
	expect(compareVectors(ret6, { 6, 12, 18 })).toBe(true)
end)