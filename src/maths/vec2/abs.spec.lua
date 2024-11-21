-- ROBLOX NOTE: no upstream
local JestGlobals = require("@DevPackages/JestGlobals")
local test, expect = JestGlobals.test, JestGlobals.expect

local abs, create
do
	local ref = require("./init")
	abs, create = ref.abs, ref.create
end
local compareVectors = require("../../../test/helpers/init").compareVectors
test("vec2. abs() with two params should update a vec2 with correct values", function()
	local vec1 = create()
	local ret1 = abs(vec1, { 0, 0 })
	expect(compareVectors(vec1, { 0, 0 })).toBe(true)
	expect(compareVectors(ret1, { 0, 0 })).toBe(true)
	expect(vec1).toBe(ret1)
	local vec2 = create()
	local ret2 = abs(vec2, { 1, 2 })
	expect(compareVectors(vec2, { 1, 2 })).toBe(true)
	expect(compareVectors(ret2, { 1, 2 })).toBe(true)
	expect(vec2).toBe(ret2)
	local vec3 = create()
	local ret3 = abs(vec3, { -1, -2 })
	expect(compareVectors(vec3, { 1, 2 })).toBe(true)
	expect(compareVectors(ret3, { 1, 2 })).toBe(true)
	expect(vec3).toBe(ret3)
end)
