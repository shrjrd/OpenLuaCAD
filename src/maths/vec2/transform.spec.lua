-- ROBLOX NOTE: no upstream
local JestGlobals = require("@DevPackages/JestGlobals")
local test, expect = JestGlobals.test, JestGlobals.expect

local transform, fromValues
do
	local ref = require("./init")
	transform, fromValues = ref.transform, ref.fromValues
end
local compareVectors = require("../../../test/helpers/init").compareVectors
test("vec2. transform() called with three parameters should update a vec2 with correct values", function()
	local identityMatrix = { 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1 }
	local obs1 = fromValues(0, 0)
	local ret1 = transform(obs1, { 0, 0 }, identityMatrix)
	expect(compareVectors(obs1, { 0, 0 })).toBe(true)
	expect(compareVectors(ret1, { 0, 0 })).toBe(true)
	local obs2 = fromValues(0, 0)
	local ret2 = transform(obs2, { 3, 2 }, identityMatrix)
	expect(compareVectors(obs2, { 3, 2 })).toBe(true)
	expect(compareVectors(ret2, { 3, 2 })).toBe(true)
	local x = 1
	local y = 5
	local z = 7
	local translationMatrix = { 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, x, y, z, 1 }
	local obs3 = fromValues(0, 0)
	local ret3 = transform(obs3, { -1, -2 }, translationMatrix)
	expect(compareVectors(obs3, { 0, 3 })).toBe(true)
	expect(compareVectors(ret3, { 0, 3 })).toBe(true)
	local w = 1
	local h = 3
	local d = 5
	local scaleMatrix = { w, 0, 0, 0, 0, h, 0, 0, 0, 0, d, 0, 0, 0, 0, 1 }
	local obs4 = fromValues(0, 0)
	local ret4 = transform(obs4, { 1, 2 }, scaleMatrix)
	expect(compareVectors(obs4, { 1, 6 })).toBe(true)
	expect(compareVectors(ret4, { 1, 6 })).toBe(true)
	local r = 90 * 0.017453292519943295
	local rotateZMatrix = {
		math.cos(r),
		-math.sin(r),
		0,
		0,
		math.sin(r),
		math.cos(r),
		0,
		0,
		0,
		0,
		1,
		0,
		0,
		0,
		0,
		1,
	}
	local obs5 = fromValues(0, 0)
	local ret5 = transform(obs5, { 1, 2 }, rotateZMatrix)
	expect(compareVectors(obs5, { 2, -1 })).toBe(true)
	expect(compareVectors(ret5, { 2, -1 })).toBe(true)
end)
