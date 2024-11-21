-- ROBLOX NOTE: no upstream
local JestGlobals = require("@DevPackages/JestGlobals")
local test, expect = JestGlobals.test, JestGlobals.expect

local create, orthogonal
do
	local ref = require("./init")
	create, orthogonal = ref.create, ref.orthogonal
end
local compareVectors = require("../../../test/helpers/init").compareVectors
test("vec3. orthogonal() with two params should update a vec3 with correct values", function()
	local org1 = create()
	local ret1 = orthogonal(org1, { 0, 0, 0 })
	expect(compareVectors(org1, { 0, 0, 0 })).toBe(true)
	expect(compareVectors(ret1, { 0, 0, 0 })).toBe(true)
	expect(org1).toBe(ret1)
	local org2 = create()
	local ret2 = orthogonal(org2, { 3, 1, 3 })
	expect(compareVectors(org2, { -3, 0, 3 })).toBe(true)
	expect(compareVectors(ret2, { -3, 0, 3 })).toBe(true)
	expect(org2).toBe(ret2)
	local org3 = create()
	local ret3 = orthogonal(org3, { 3, 2, 1 })
	expect(compareVectors(org3, { 2, -3, 0 })).toBe(true)
	expect(compareVectors(ret3, { 2, -3, 0 })).toBe(true)
	expect(org3).toBe(ret3)
end)
