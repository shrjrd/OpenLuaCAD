-- ROBLOX NOTE: no upstream
local JestGlobals = require("@DevPackages/JestGlobals")
local test, expect = JestGlobals.test, JestGlobals.expect

local clone, fromValues
do
	local ref = require("./init")
	clone, fromValues = ref.clone, ref.fromValues
end
local compareVectors = require("../../../test/helpers/init").compareVectors
test("mat4. clone() should return a new mat4 with same values", function()
	local org1 = fromValues(0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0)
	local obs1 = clone(org1)
	expect(compareVectors(obs1, { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 })).toBe(true)
	expect(obs1)["not"].toBe(org1)
	local org2 = fromValues(1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16)
	local obs2 = clone(org2)
	expect(compareVectors(obs2, { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16 })).toBe(true)
	expect(obs2)["not"].toBe(org2)
	local org3 = fromValues(-1, -2, -3, -4, -5, -6, -7, -8, -9, -10, -11, -12, -13, -14, -15, -16)
	local obs3 = clone(org3)
	expect(compareVectors(obs3, { -1, -2, -3, -4, -5, -6, -7, -8, -9, -10, -11, -12, -13, -14, -15, -16 })).toBe(true)
	expect(obs3)["not"].toBe(org3)
end)
