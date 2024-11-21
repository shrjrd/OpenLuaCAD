-- ROBLOX NOTE: no upstream
local JestGlobals = require("@DevPackages/JestGlobals")
local test, expect = JestGlobals.test, JestGlobals.expect

local create, flip
do
	local ref = require("./init")
	create, flip = ref.create, ref.flip
end
local compareVectors = require("../../../test/helpers/init").compareVectors
test("plane. flip() called with two parameters should update a plane with correct values", function()
	local org1 = create()
	local ret1 = flip(org1, { 0, 0, 0, 0 })
	expect(compareVectors(org1, { -0, -0, -0, -0 })).toBe(true)
	expect(compareVectors(ret1, { -0, -0, -0, -0 })).toBe(true)
	local org2 = create()
	local ret2 = flip(org2, { 1, 2, 3, 4 })
	expect(compareVectors(org2, { -1, -2, -3, -4 })).toBe(true)
	expect(compareVectors(ret2, { -1, -2, -3, -4 })).toBe(true)
	local org3 = create()
	local ret3 = flip(org3, { -1, -2, -3, -4 })
	expect(compareVectors(org3, { 1, 2, 3, 4 })).toBe(true)
	expect(compareVectors(ret3, { 1, 2, 3, 4 })).toBe(true)
	local org4 = create()
	local ret4 = flip(org4, { -1, 2, -3, 4 })
	expect(compareVectors(org4, { 1, -2, 3, -4 })).toBe(true)
	expect(compareVectors(ret4, { 1, -2, 3, -4 })).toBe(true)
end)
