-- ROBLOX NOTE: no upstream
local JestGlobals = require("@DevPackages/JestGlobals")
local test, expect = JestGlobals.test, JestGlobals.expect

local subtract, fromValues
do
	local ref = require("./init")
	subtract, fromValues = ref.subtract, ref.fromValues
end
local compareVectors = require("../../../test/helpers/init").compareVectors
test("vec2. subtract() called with three parameters should update a vec2 with correct values", function()
	local obs1 = fromValues(0, 0)
	local ret1 = subtract(obs1, { 0, 0 }, { 0, 0 })
	expect(compareVectors(obs1, { 0, 0 })).toBe(true)
	expect(compareVectors(ret1, { 0, 0 })).toBe(true)
	local obs2 = fromValues(0, 0)
	local ret2 = subtract(obs2, { 1, 2 }, { 3, 2 })
	expect(compareVectors(obs2, { -2, 0 })).toBe(true)
	expect(compareVectors(ret2, { -2, 0 })).toBe(true)
	local obs3 = fromValues(0, 0)
	local ret3 = subtract(obs3, { 1, 2 }, { -1, -2 })
	expect(compareVectors(obs3, { 2, 4 })).toBe(true)
	expect(compareVectors(ret3, { 2, 4 })).toBe(true)
	local obs4 = fromValues(0, 0)
	local ret4 = subtract(obs4, { -1, -2 }, { -1, -2 })
	expect(compareVectors(obs4, { 0, 0 })).toBe(true)
	expect(compareVectors(ret4, { 0, 0 })).toBe(true)
end)
