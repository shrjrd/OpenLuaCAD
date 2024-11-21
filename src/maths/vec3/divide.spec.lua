-- ROBLOX NOTE: no upstream
local JestGlobals = require("@DevPackages/JestGlobals")
local test, expect = JestGlobals.test, JestGlobals.expect

local divide, fromValues
do
	local ref = require("./init")
	divide, fromValues = ref.divide, ref.fromValues
end
local compareVectors = require("../../../test/helpers/init").compareVectors
test("vec3. divide() called with three parameters should update a vec3 with correct values", function()
	local obs1 = fromValues(0, 0, 0)
	local ret1 = divide(obs1, { 0, 0, 0 }, { 0, 0, 0 })
	expect(compareVectors(obs1, { 0 / 0, 0 / 0, 0 / 0 })).toBe(true)
	expect(compareVectors(ret1, { 0 / 0, 0 / 0, 0 / 0 })).toBe(true)
	local obs2 = fromValues(0, 0, 0)
	local ret2 = divide(obs2, { 0, 0, 0 }, { 1, 2, 3 })
	expect(compareVectors(obs2, { 0, 0, 0 })).toBe(true)
	expect(compareVectors(ret2, { 0, 0, 0 })).toBe(true)
	local obs3 = fromValues(0, 0, 0)
	local ret3 = divide(obs3, { 6, 6, 6 }, { 1, 2, 3 })
	expect(compareVectors(obs3, { 6, 3, 2 })).toBe(true)
	expect(compareVectors(ret3, { 6, 3, 2 })).toBe(true)
	local obs4 = fromValues(0, 0, 0)
	local ret4 = divide(obs4, { -6, -6, -6 }, { 1, 2, 3 })
	expect(compareVectors(obs4, { -6, -3, -2 })).toBe(true)
	expect(compareVectors(ret4, { -6, -3, -2 })).toBe(true)
	local obs5 = fromValues(0, 0, 0)
	local ret5 = divide(obs5, { 6, 6, 6 }, { -1, -2, -3 })
	expect(compareVectors(obs5, { -6, -3, -2 })).toBe(true)
	expect(compareVectors(ret5, { -6, -3, -2 })).toBe(true)
	local obs6 = fromValues(0, 0, 0)
	local ret6 = divide(obs6, { -6, -6, -6 }, { -1, -2, -3 })
	expect(compareVectors(obs6, { 6, 3, 2 })).toBe(true)
	expect(compareVectors(ret6, { 6, 3, 2 })).toBe(true)
end)
