-- ROBLOX NOTE: no upstream
local JestGlobals = require("@DevPackages/JestGlobals")
local test, expect = JestGlobals.test, JestGlobals.expect

local create, copy, fromValues
do
	local ref = require("./init")
	create, copy, fromValues = ref.create, ref.copy, ref.fromValues
end
local compareVectors = require("../../../test/helpers/init").compareVectors
test("plane. copy() with two params should update a plane with same values", function()
	local org1 = create()
	local plane1 = fromValues(0, 0, 0, 0)
	local ret1 = copy(org1, plane1)
	expect(compareVectors(org1, { 0, 0, 0, 0 })).toBe(true)
	expect(compareVectors(ret1, { 0, 0, 0, 0 })).toBe(true)
	expect(ret1)["not"].toBe(plane1)
	expect(ret1).toBe(org1)
	local org2 = create()
	local plane2 = fromValues(1, 2, 3, 4)
	local ret2 = copy(org2, plane2)
	expect(compareVectors(org2, { 1, 2, 3, 4 })).toBe(true)
	expect(compareVectors(ret2, { 1, 2, 3, 4 })).toBe(true)
	expect(ret2)["not"].toBe(plane2)
	expect(ret2).toBe(org2)
	local org3 = create()
	local plane3 = fromValues(-1, -2, -3, -4)
	local ret3 = copy(org3, plane3)
	expect(compareVectors(org3, { -1, -2, -3, -4 })).toBe(true)
	expect(compareVectors(ret3, { -1, -2, -3, -4 })).toBe(true)
	expect(ret3)["not"].toBe(plane3)
	expect(ret3).toBe(org3)
end)
