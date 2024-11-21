-- ROBLOX NOTE: no upstream
local JestGlobals = require("@DevPackages/JestGlobals")
local test, expect = JestGlobals.test, JestGlobals.expect

local create, copy, fromValues
do
	local ref = require("./init")
	create, copy, fromValues = ref.create, ref.copy, ref.fromValues
end
local compareVectors = require("../../../test/helpers/init").compareVectors
test("line2. copy() with two params should update a line2 with same values", function()
	local line1 = create()
	local org1 = fromValues(0, 0, 0)
	local ret1 = copy(line1, org1)
	expect(compareVectors(line1, { 0, 0, 0 })).toBe(true)
	expect(compareVectors(ret1, { 0, 0, 0 })).toBe(true)
	expect(ret1)["not"].toBe(org1)
	local line2 = create()
	local org2 = fromValues(1, 2, 3)
	local ret2 = copy(line2, org2)
	expect(compareVectors(line2, { 1, 2, 3 })).toBe(true)
	expect(compareVectors(ret2, { 1, 2, 3 })).toBe(true)
	expect(ret2)["not"].toBe(org2)
	local line3 = create()
	local org3 = fromValues(-1, -2, -3)
	local ret3 = copy(line3, org3)
	expect(compareVectors(line3, { -1, -2, -3 })).toBe(true)
	expect(compareVectors(ret3, { -1, -2, -3 })).toBe(true)
	expect(ret3)["not"].toBe(org3)
end)
