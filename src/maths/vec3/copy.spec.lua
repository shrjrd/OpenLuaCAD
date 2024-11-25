-- ROBLOX NOTE: no upstream
local JestGlobals = require("@DevPackages/JestGlobals")
local test, expect = JestGlobals.test, JestGlobals.expect

local create, copy, fromValues
do
	local ref = require("./init")
	create, copy, fromValues = ref.create, ref.copy, ref.fromValues
end
local compareVectors = require("../../../test/helpers/init").compareVectors
test("vec3. copy() with two params should update a vec3 with same values", function()
	local vec1 = create()
	local org1 = fromValues(0, 0, 0)
	local ret1 = copy(vec1, org1)
	expect(compareVectors(vec1, { 0, 0, 0 })).toBe(true)
	expect(compareVectors(ret1, { 0, 0, 0 })).toBe(true)
	expect(ret1).never.toBe(org1)
	local vec2 = create()
	local org2 = fromValues(1, 2, 3)
	local ret2 = copy(vec2, org2)
	expect(compareVectors(vec2, { 1, 2, 3 })).toBe(true)
	expect(compareVectors(ret2, { 1, 2, 3 })).toBe(true)
	expect(ret2).never.toBe(org2)
	local vec3 = create()
	local org3 = fromValues(-1, -2, -3)
	local ret3 = copy(vec3, org3)
	expect(compareVectors(vec3, { -1, -2, -3 })).toBe(true)
	expect(compareVectors(ret3, { -1, -2, -3 })).toBe(true)
	expect(ret3).never.toBe(org3)
end)
