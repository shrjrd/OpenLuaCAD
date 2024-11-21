-- ROBLOX NOTE: no upstream
local JestGlobals = require("@DevPackages/JestGlobals")
local test, expect = JestGlobals.test, JestGlobals.expect

local transform, fromValues
do
	local ref = require("./init")
	transform, fromValues = ref.transform, ref.fromValues
end
local compareVectors = require("../../../test/helpers/init").compareVectors
test("vec4. transform() called with three parameters should update a vec4 with correct values", function()
	local identityMatrix = { 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1 }
	local out1 = fromValues(0, 0, 0, 0)
	local ret1 = transform(out1, { 0, 0, 0, 0 }, identityMatrix)
	expect(compareVectors(out1, { 0, 0, 0, 0 })).toBe(true)
	expect(compareVectors(ret1, { 0, 0, 0, 0 })).toBe(true)
	local out2 = fromValues(0, 0, 0, 0)
	local ret2 = transform(out2, { 3, 2, 1, 0 }, identityMatrix)
	expect(compareVectors(out2, { 3, 2, 1, 0 })).toBe(true)
	expect(compareVectors(ret2, { 3, 2, 1, 0 })).toBe(true)
	local x = 1
	local y = 5
	local z = 7
	local translationMatrix = { 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, x, y, z, 1 }
	local out3 = fromValues(0, 0, 0, 0)
	local ret3 = transform(out3, { -1, -2, -3, 1 }, translationMatrix)
	expect(compareVectors(out3, { 0, 3, 4, 1 })).toBe(true)
	expect(compareVectors(ret3, { 0, 3, 4, 1 })).toBe(true)
	local w = 1
	local h = 3
	local d = 5
	local scaleMatrix = { w, 0, 0, 0, 0, h, 0, 0, 0, 0, d, 0, 0, 0, 0, 1 }
	local out4 = fromValues(0, 0, 0, 0)
	local ret4 = transform(out4, { 1, 2, 3, 1 }, scaleMatrix)
	expect(compareVectors(out4, { 1, 6, 15, 1 })).toBe(true)
	expect(compareVectors(ret4, { 1, 6, 15, 1 })).toBe(true)
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
	local out5 = fromValues(0, 0, 0, 0)
	local ret5 = transform(out5, { 1, 2, 3, 1 }, rotateZMatrix)
	expect(compareVectors(out5, { 2, -1, 3, 1 })).toBe(true)
	expect(compareVectors(ret5, { 2, -1, 3, 1 })).toBe(true)
end)
