-- ROBLOX NOTE: no upstream
local JestGlobals = require("@DevPackages/JestGlobals")
local test, expect = JestGlobals.test, JestGlobals.expect

local create, copy, fromValues
do
	local ref = require("./init")
	create, copy, fromValues = ref.create, ref.copy, ref.fromValues
end
local compareVectors = require("../../../test/helpers/init").compareVectors
test("mat4. copy() with two params should update a mat4 with same values", function()
	local org1 = create()
	local mat1 = fromValues(0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0)
	local ret1 = copy(org1, mat1)
	expect(compareVectors(org1, { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 })).toBe(true)
	expect(compareVectors(ret1, { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 })).toBe(true)
	expect(ret1).toBe(org1)
	expect(mat1)["not"].toBe(org1)
	local org2 = create()
	local mat2 = fromValues(1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16)
	local ret2 = copy(org2, mat2)
	expect(compareVectors(org2, { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16 })).toBe(true)
	expect(compareVectors(ret2, { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16 })).toBe(true)
	expect(ret2).toBe(org2)
	expect(mat2)["not"].toBe(org2)
	local org3 = create()
	local mat3 = fromValues(-1, -2, -3, -4, -5, -6, -7, -8, -9, -10, -11, -12, -13, -14, -15, -16)
	local ret3 = copy(org3, mat3)
	expect(compareVectors(org3, { -1, -2, -3, -4, -5, -6, -7, -8, -9, -10, -11, -12, -13, -14, -15, -16 })).toBe(true)
	expect(compareVectors(ret3, { -1, -2, -3, -4, -5, -6, -7, -8, -9, -10, -11, -12, -13, -14, -15, -16 })).toBe(true)
	expect(ret3).toBe(org3)
	expect(mat3)["not"].toBe(org3)
end)
