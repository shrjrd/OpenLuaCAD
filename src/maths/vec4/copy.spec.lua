-- ROBLOX NOTE: no upstream
local JestGlobals = require("@DevPackages/JestGlobals")
local test, expect = JestGlobals.test, JestGlobals.expect

local create, copy, fromValues
do
	local ref = require("./init")
	create, copy, fromValues = ref.create, ref.copy, ref.fromValues
end
local compareVectors = require("../../../test/helpers/init").compareVectors
test("vec4. copy() with two params should update a vec4 with same values", function()
	local org1 = create()
	local mat1 = fromValues(0, 0, 0, 0)
	local ret1 = copy(org1, mat1)
	expect(compareVectors(org1, { 0, 0, 0, 0 })).toBe(true)
	expect(compareVectors(ret1, { 0, 0, 0, 0 })).toBe(true)
	expect(ret1).never.toBe(mat1)
	expect(ret1).toBe(org1)
	local org2 = create()
	local mat2 = fromValues(1, 2, 3, 4)
	local ret2 = copy(org2, mat2)
	expect(compareVectors(org2, { 1, 2, 3, 4 })).toBe(true)
	expect(compareVectors(ret2, { 1, 2, 3, 4 })).toBe(true)
	expect(ret2).never.toBe(mat2)
	expect(ret2).toBe(org2)
	local org3 = create()
	local mat3 = fromValues(-1, -2, -3, -4)
	local ret3 = copy(org3, mat3)
	expect(compareVectors(org3, { -1, -2, -3, -4 })).toBe(true)
	expect(compareVectors(ret3, { -1, -2, -3, -4 })).toBe(true)
	expect(ret3).never.toBe(mat3)
	expect(ret3).toBe(org3)
end)
