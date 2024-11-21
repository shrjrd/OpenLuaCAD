-- ROBLOX NOTE: no upstream
local JestGlobals = require("@DevPackages/JestGlobals")
local test, expect = JestGlobals.test, JestGlobals.expect

local transform, create, fromPoints
do
	local ref = require("./init")
	transform, create, fromPoints = ref.transform, ref.create, ref.fromPoints
end
local compareVectors = require("../../../test/helpers/init").compareVectors
test("line2. transform() called with three parameters should update a line2 with correct values", function()
	local line1 = create()
	local line2 = fromPoints(create(), { 0, 0 }, { 0, 1 })
	local line3 = fromPoints(create(), { -3, -3 }, { 3, 3 })
	local identityMatrix = { 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1 }
	local obs1 = create()
	local ret1 = transform(obs1, line1, identityMatrix)
	expect(compareVectors(ret1, { 0, 1, 0 })).toBe(true)
	expect(compareVectors(obs1, { 0, 1, 0 })).toBe(true)
	ret1 = transform(obs1, line2, identityMatrix)
	expect(compareVectors(ret1, { -1, 0, 0 })).toBe(true)
	expect(compareVectors(obs1, { -1, 0, 0 })).toBe(true)
	ret1 = transform(obs1, line3, identityMatrix)
	expect(compareVectors(ret1, { -0.7071067811865476, 0.7071067811865476, 0 })).toBe(true)
	expect(compareVectors(obs1, { -0.7071067811865476, 0.7071067811865476, 0 })).toBe(true)
	local x = 1
	local y = 5
	local z = 7
	local translationMatrix = { 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, x, y, z, 1 }
	local obs2 = create()
	local ret2 = transform(obs2, line1, translationMatrix)
	expect(compareVectors(ret2, { 0, 1, 5 })).toBe(true)
	expect(compareVectors(obs2, { 0, 1, 5 })).toBe(true)
	ret2 = transform(obs2, line2, translationMatrix)
	expect(compareVectors(ret2, { -1, 0, -1 })).toBe(true)
	expect(compareVectors(obs2, { -1, 0, -1 })).toBe(true)
	ret2 = transform(obs2, line3, translationMatrix)
	expect(compareVectors(ret2, { -0.7071067811865478, 0.7071067811865474, 2.828427124746189 })).toBe(true)
	expect(compareVectors(obs2, { -0.7071067811865478, 0.7071067811865474, 2.828427124746189 })).toBe(true)
	local w = 1
	local h = 3
	local d = 5
	local scaleMatrix = { w, 0, 0, 0, 0, h, 0, 0, 0, 0, d, 0, 0, 0, 0, 1 }
	local obs3 = create()
	local ret3 = transform(obs3, line1, scaleMatrix)
	expect(compareVectors(ret3, { 0, 1, 0 })).toBe(true)
	expect(compareVectors(obs3, { 0, 1, 0 })).toBe(true)
	ret3 = transform(obs3, line2, scaleMatrix)
	expect(compareVectors(ret3, { -1, 0, 0 })).toBe(true)
	expect(compareVectors(obs3, { -1, 0, 0 })).toBe(true)
	ret3 = transform(obs3, line3, scaleMatrix)
	expect(compareVectors(ret3, { -0.9486832980505139, 0.316227766016838, 0 })).toBe(true)
	expect(compareVectors(obs3, { -0.9486832980505139, 0.316227766016838, 0 })).toBe(true)
	local r = 90 * 0.017453292519943295
	local rotateZMatrix = {
		math.cos(r),
		math.sin(r),
		0,
		0,
		-math.sin(r),
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
	local obs4 = create()
	local ret4 = transform(obs4, line1, rotateZMatrix)
	expect(compareVectors(ret4, { -1, 0, 0 })).toBe(true)
	expect(compareVectors(obs4, { -1, 0, 0 })).toBe(true)
	ret4 = transform(obs4, line2, rotateZMatrix)
	expect(compareVectors(ret4, { 0, -1, 0 })).toBe(true)
	expect(compareVectors(obs4, { 0, -1, 0 })).toBe(true)
	ret4 = transform(obs4, line3, rotateZMatrix)
	expect(compareVectors(ret4, { -0.7071067811865476, -0.7071067811865476, -0 })).toBe(true)
	expect(compareVectors(obs4, { -0.7071067811865476, -0.7071067811865476, -0 })).toBe(true)
end)
