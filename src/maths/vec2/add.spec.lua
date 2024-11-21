-- ROBLOX NOTE: no upstream
local JestGlobals = require("@DevPackages/JestGlobals")
local test, expect = JestGlobals.test, JestGlobals.expect

local add, fromValues
do
	local ref = require("./init")
	add, fromValues = ref.add, ref.fromValues
end
local compareVectors = require("../../../test/helpers/init").compareVectors
test("vec2. add() called with three parameters should update a vec2 with correct values", function()
	local obs1 = fromValues(0, 0)
	local ret1 = add(obs1, { 0, 0 }, { 0, 0 })
	expect(compareVectors(obs1, { 0, 0 })).toBe(true)
	expect(compareVectors(ret1, { 0, 0 })).toBe(true)
	local obs2 = fromValues(0, 0)
	local ret2 = add(obs2, { 1, 2 }, { 3, 2 })
	expect(compareVectors(obs2, { 4, 4 })).toBe(true)
	expect(compareVectors(ret2, { 4, 4 })).toBe(true)
	local obs3 = fromValues(0, 0)
	local ret3 = add(obs3, { 1, 2 }, { -1, -2 })
	expect(compareVectors(obs3, { 0, 0 })).toBe(true)
	expect(compareVectors(ret3, { 0, 0 })).toBe(true)
	local obs4 = fromValues(0, 0)
	local ret4 = add(obs4, { -1, -2 }, { -1, -2 })
	expect(compareVectors(obs4, { -2, -4 })).toBe(true)
	expect(compareVectors(ret4, { -2, -4 })).toBe(true)
end)
