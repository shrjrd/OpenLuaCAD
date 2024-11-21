-- ROBLOX NOTE: no upstream
local JestGlobals = require("@DevPackages/JestGlobals")
local test, expect = JestGlobals.test, JestGlobals.expect

local negate, fromValues
do
	local ref = require("./init")
	negate, fromValues = ref.negate, ref.fromValues
end
local compareVectors = require("../../../test/helpers/init").compareVectors
test("vec2. negate() called with two parameters should update a vec2 with correct values", function()
	local obs1 = fromValues(0, 0)
	local ret1 = negate(obs1, { 0, 0 })
	expect(compareVectors(obs1, { 0, 0 })).toBe(true)
	expect(compareVectors(ret1, { 0, 0 })).toBe(true)
	local obs2 = fromValues(0, 0)
	local ret2 = negate(obs2, { 1, 2 })
	expect(compareVectors(obs2, { -1, -2 })).toBe(true)
	expect(compareVectors(ret2, { -1, -2 })).toBe(true)
	local obs3 = fromValues(0, 0)
	local ret3 = negate(obs3, { -1, -2 })
	expect(compareVectors(obs3, { 1, 2 })).toBe(true)
	expect(compareVectors(ret3, { 1, 2 })).toBe(true)
	local obs4 = fromValues(0, 0)
	local ret4 = negate(obs4, { -1, 2 })
	expect(compareVectors(obs4, { 1, -2 })).toBe(true)
	expect(compareVectors(ret4, { 1, -2 })).toBe(true)
end)
