-- ROBLOX NOTE: no upstream
local JestGlobals = require("@DevPackages/JestGlobals")
local test, expect = JestGlobals.test, JestGlobals.expect

local multiply, fromValues
do
	local ref = require("./init")
	multiply, fromValues = ref.multiply, ref.fromValues
end
local compareVectors = require("../../../test/helpers/init").compareVectors
test("vec2. multiply() called with three parameters should update a vec2 with correct values", function()
	local obs1 = fromValues(0, 0)
	local ret1 = multiply(obs1, { 0, 0 }, { 0, 0 })
	expect(compareVectors(obs1, { 0, 0 })).toBe(true)
	expect(compareVectors(ret1, { 0, 0 })).toBe(true)
	local obs2 = fromValues(0, 0)
	local ret2 = multiply(obs2, { 0, 0 }, { 1, 2 })
	expect(compareVectors(obs2, { 0, 0 })).toBe(true)
	expect(compareVectors(ret2, { 0, 0 })).toBe(true)
	local obs3 = fromValues(0, 0)
	local ret3 = multiply(obs3, { 6, 6 }, { 1, 2 })
	expect(compareVectors(obs3, { 6, 12 })).toBe(true)
	expect(compareVectors(ret3, { 6, 12 })).toBe(true)
	local obs4 = fromValues(0, 0)
	local ret4 = multiply(obs4, { -6, -6 }, { 1, 2 })
	expect(compareVectors(obs4, { -6, -12 })).toBe(true)
	expect(compareVectors(ret4, { -6, -12 })).toBe(true)
	local obs5 = fromValues(0, 0)
	local ret5 = multiply(obs5, { 6, 6 }, { -1, -2 })
	expect(compareVectors(obs5, { -6, -12 })).toBe(true)
	expect(compareVectors(ret5, { -6, -12 })).toBe(true)
	local obs6 = fromValues(0, 0)
	local ret6 = multiply(obs6, { -6, -6 }, { -1, -2 })
	expect(compareVectors(obs6, { 6, 12 })).toBe(true)
	expect(compareVectors(ret6, { 6, 12 })).toBe(true)
end)