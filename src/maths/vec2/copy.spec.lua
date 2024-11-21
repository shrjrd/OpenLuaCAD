-- ROBLOX NOTE: no upstream
local JestGlobals = require("@DevPackages/JestGlobals")
local test, expect = JestGlobals.test, JestGlobals.expect

local copy, create, fromValues
do
	local ref = require("./init")
	copy, create, fromValues = ref.copy, ref.create, ref.fromValues
end
local compareVectors = require("../../../test/helpers/init").compareVectors
test("vec2. copy() with two params should update a vec2 with same values", function()
	local out1 = create()
	local org1 = fromValues(0, 0)
	local ret1 = copy(out1, org1)
	expect(compareVectors(out1, { 0, 0 })).toBe(true)
	expect(compareVectors(ret1, { 0, 0 })).toBe(true)
	expect(ret1)["not"].toBe(org1)
	expect(out1).toBe(ret1)
	local out2 = create()
	local org2 = fromValues(1, 2)
	local ret2 = copy(out2, org2)
	expect(compareVectors(out2, { 1, 2 })).toBe(true)
	expect(compareVectors(ret2, { 1, 2 })).toBe(true)
	expect(ret2)["not"].toBe(org2)
	expect(out2).toBe(ret2)
	local out3 = create()
	local org3 = fromValues(-1, -2)
	local ret3 = copy(out3, org3)
	expect(compareVectors(out3, { -1, -2 })).toBe(true)
	expect(compareVectors(ret3, { -1, -2 })).toBe(true)
	expect(ret3)["not"].toBe(org3)
	expect(out3).toBe(ret3)
end)
