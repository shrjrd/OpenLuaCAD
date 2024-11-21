-- ROBLOX NOTE: no upstream
local JestGlobals = require("@DevPackages/JestGlobals")
local test, expect = JestGlobals.test, JestGlobals.expect

local lerp, fromValues
do
	local ref = require("./init")
	lerp, fromValues = ref.lerp, ref.fromValues
end
local compareVectors = require("../../../test/helpers/init").compareVectors
test("vec3. lerp() called with three parameters should update a vec3 with correct values", function()
	local obs1 = fromValues(0, 0, 0)
	local ret1 = lerp(obs1, { 0, 0, 0 }, { 0, 0, 0 }, 0)
	expect(compareVectors(obs1, { 0, 0, 0 })).toBe(true)
	expect(compareVectors(ret1, { 0, 0, 0 })).toBe(true)
	local obs2 = fromValues(0, 0, 0)
	local ret2 = lerp(obs2, { 1, 2, 3 }, { 5, 6, 7 }, 0.00)
	expect(compareVectors(obs2, { 1, 2, 3 })).toBe(true)
	expect(compareVectors(ret2, { 1, 2, 3 })).toBe(true)
	local obs3 = fromValues(0, 0, 0)
	local ret3 = lerp(obs3, { 1, 2, 3 }, { 5, 6, 7 }, 0.75)
	expect(compareVectors(obs3, { 4, 5, 6 })).toBe(true)
	expect(compareVectors(ret3, { 4, 5, 6 })).toBe(true)
	local obs4 = fromValues(0, 0, 0)
	local ret4 = lerp(obs4, { 1, 2, 3 }, { 5, 6, 7 }, 1.00)
	expect(compareVectors(obs4, { 5, 6, 7 })).toBe(true)
	expect(compareVectors(ret4, { 5, 6, 7 })).toBe(true)
end)
