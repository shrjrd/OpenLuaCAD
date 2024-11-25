-- ROBLOX NOTE: no upstream
local JestGlobals = require("@DevPackages/JestGlobals")
local test, expect = JestGlobals.test, JestGlobals.expect

local clone, fromValues
do
	local ref = require("./init")
	clone, fromValues = ref.clone, ref.fromValues
end
local compareVectors = require("../../../test/helpers/init").compareVectors
test("vec4. clone() with one param should create a new vec4 with same values", function()
	local vec1 = fromValues(0, 0, 0, 0)
	local ret1 = clone(vec1)
	expect(ret1).never.toBe(vec1)
	expect(compareVectors(vec1, { 0, 0, 0, 0 })).toBe(true)
	expect(compareVectors(ret1, { 0, 0, 0, 0 })).toBe(true)
	local vec2 = fromValues(1, 2, 3, 4)
	local ret2 = clone(vec2)
	expect(ret2).never.toBe(vec2)
	expect(compareVectors(vec2, { 1, 2, 3, 4 })).toBe(true)
	expect(compareVectors(ret2, { 1, 2, 3, 4 })).toBe(true)
	local vec3 = fromValues(-1, -2, -3, -4)
	local ret3 = clone(vec3)
	expect(ret3).never.toBe(vec3)
	expect(compareVectors(vec3, { -1, -2, -3, -4 })).toBe(true)
	expect(compareVectors(ret3, { -1, -2, -3, -4 })).toBe(true)
end)
