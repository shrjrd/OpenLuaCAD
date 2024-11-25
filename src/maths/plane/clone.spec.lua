-- ROBLOX NOTE: no upstream
local JestGlobals = require("@DevPackages/JestGlobals")
local test, expect = JestGlobals.test, JestGlobals.expect

local clone, fromValues
do
	local ref = require("./init")
	clone, fromValues = ref.clone, ref.fromValues
end
local compareVectors = require("../../../test/helpers/init").compareVectors
test("plane. clone() with one param should update a new plane with same values", function()
	local plane1 = fromValues(0, 0, 0, 0)
	local ret1 = clone(plane1)
	expect(compareVectors(plane1, { 0, 0, 0, 0 })).toBe(true)
	expect(compareVectors(ret1, { 0, 0, 0, 0 })).toBe(true)
	expect(ret1).never.toBe(plane1)
	local plane2 = fromValues(1, 2, 3, 4)
	local ret2 = clone(plane2)
	expect(compareVectors(plane2, { 1, 2, 3, 4 })).toBe(true)
	expect(compareVectors(ret2, { 1, 2, 3, 4 })).toBe(true)
	expect(ret2).never.toBe(plane2)
	local plane3 = fromValues(-1, -2, -3, -4)
	local ret3 = clone(plane3)
	expect(compareVectors(plane3, { -1, -2, -3, -4 })).toBe(true)
	expect(compareVectors(ret3, { -1, -2, -3, -4 })).toBe(true)
	expect(ret3).never.toBe(plane3)
end)
