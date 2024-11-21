-- ROBLOX NOTE: no upstream
local JestGlobals = require("@DevPackages/JestGlobals")
local test, expect = JestGlobals.test, JestGlobals.expect

local abs, create
do
	local ref = require("./init")
	abs, create = ref.abs, ref.create
end
local compareVectors = require("../../../test/helpers/init").compareVectors
test("vec3. abs() with two params should update a vec3 with correct values", function()
	local org1 = create()
	local ret1 = abs(org1, { 0, 0, 0 })
	expect(compareVectors(org1, { 0, 0, 0 })).toBe(true)
	expect(compareVectors(ret1, { 0, 0, 0 })).toBe(true)
	expect(org1).toBe(ret1)
	local org2 = create()
	local ret2 = abs(org2, { 1, 2, 3 })
	expect(compareVectors(org2, { 1, 2, 3 })).toBe(true)
	expect(compareVectors(ret2, { 1, 2, 3 })).toBe(true)
	expect(org2).toBe(ret2)
	local org3 = create()
	local ret3 = abs(org3, { -1, -2, -3 })
	expect(compareVectors(org3, { 1, 2, 3 })).toBe(true)
	expect(compareVectors(ret3, { 1, 2, 3 })).toBe(true)
	expect(org3).toBe(ret3)
end)
