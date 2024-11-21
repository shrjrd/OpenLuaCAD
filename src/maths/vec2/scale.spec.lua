-- ROBLOX NOTE: no upstream
local JestGlobals = require("@DevPackages/JestGlobals")
local test, expect = JestGlobals.test, JestGlobals.expect

local scale, create
do
	local ref = require("./init")
	scale, create = ref.scale, ref.create
end
local compareVectors = require("../../../test/helpers/init").compareVectors
test("vec2. scale() with two params should update a vec2 with positive values", function()
	local vec1 = create()
	local ret1 = scale(vec1, { 0, 0 }, 0)
	expect(compareVectors(vec1, { 0, 0 })).toBe(true)
	expect(compareVectors(ret1, { 0, 0 })).toBe(true)
	expect(vec1).toBe(ret1)
	local vec2 = create()
	local ret2 = scale(vec2, { 1, 2 }, 3)
	expect(compareVectors(vec2, { 3, 6 })).toBe(true)
	expect(compareVectors(ret2, { 3, 6 })).toBe(true)
	expect(vec2).toBe(ret2)
	local vec3 = create()
	local ret3 = scale(vec3, { -1, -2 }, 3)
	expect(compareVectors(vec3, { -3, -6 })).toBe(true)
	expect(compareVectors(ret3, { -3, -6 })).toBe(true)
	expect(vec3).toBe(ret3)
end)
