-- ROBLOX NOTE: no upstream
local JestGlobals = require("@DevPackages/JestGlobals")
local test, expect = JestGlobals.test, JestGlobals.expect

local transform, create, fromPointAxisNormal
do
	local ref = require("./init")
	transform, create, fromPointAxisNormal = ref.transform, ref.create, ref.fromPointAxisNormal
end
local compareVectors = require("../../test/helpers/").compareVectors
test("connector: transform() should return a connector with correct values", function()
	local connector1 = create()
	local connector2 = fromPointAxisNormal({ 1, 0, 0 }, { 0, 1, 0 }, { 0, 0, 1 })
	local connector3 = fromPointAxisNormal({ -3, -3, -3 }, { 3, 3, 3 }, { 3, -3, 3 })
	local identityMatrix = { 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1 }
	local obs1 = transform(identityMatrix, connector1)
	expect(compareVectors(obs1.point, { 0, 0, 0 })).toBe(true)
	expect(compareVectors(obs1.axis, { 0, 0, 1 })).toBe(true)
	expect(compareVectors(obs1.normal, { 1, 0, 0 })).toBe(true)
	obs1 = transform(identityMatrix, connector2)
	expect(compareVectors(obs1.point, { 1, 0, 0 })).toBe(true)
	expect(compareVectors(obs1.axis, { 0, 1, 0 })).toBe(true)
	expect(compareVectors(obs1.normal, { 0, 0, 1 })).toBe(true)
	obs1 = transform(identityMatrix, connector3)
	expect(compareVectors(obs1.point, { -3, -3, -3 })).toBe(true)
	expect(compareVectors(obs1.axis, { 0.5773502691896258, 0.5773502691896258, 0.5773502691896258 })).toBe(true)
	expect(compareVectors(obs1.normal, { 0.5773502691896258, -0.5773502691896258, 0.5773502691896258 })).toBe(true)
	local x = 1
	local y = 5
	local z = 7
	local translationMatrix = { 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, x, y, z, 1 }
	local obs2 = transform(translationMatrix, connector1)
	expect(compareVectors(obs2.point, { 1, 5, 7 })).toBe(true)
	expect(compareVectors(obs2.axis, { 0, 0, 1 })).toBe(true)
	expect(compareVectors(obs2.normal, { 1, 0, 0 })).toBe(true)
	obs2 = transform(translationMatrix, connector2)
	expect(compareVectors(obs2.point, { 2, 5, 7 })).toBe(true)
	expect(compareVectors(obs2.axis, { 0, 1, 0 })).toBe(true)
	expect(compareVectors(obs2.normal, { 0, 0, 1 })).toBe(true)
	obs2 = transform(translationMatrix, connector3)
	expect(compareVectors(obs2.point, { -2, 2, 4 })).toBe(true)
	expect(compareVectors(obs2.axis, { 0.5773502691896256, 0.5773502691896256, 0.5773502691896261 })).toBe(true)
	expect(compareVectors(obs2.normal, { 0.5773502691896256, -0.5773502691896256, 0.5773502691896261 })).toBe(true)
	local w = 1
	local h = 3
	local d = 5
	local scaleMatrix = { w, 0, 0, 0, 0, h, 0, 0, 0, 0, d, 0, 0, 0, 0, 1 }
	local obs3 = transform(scaleMatrix, connector1)
	expect(compareVectors(obs3.point, { 0, 0, 0 })).toBe(true)
	expect(compareVectors(obs3.axis, { 0, 0, 1 })).toBe(true)
	expect(compareVectors(obs3.normal, { 1, 0, 0 })).toBe(true)
	obs3 = transform(scaleMatrix, connector2)
	expect(compareVectors(obs3.point, { 1, 0, 0 })).toBe(true)
	expect(compareVectors(obs3.axis, { 0, 1, 0 })).toBe(true)
	expect(compareVectors(obs3.normal, { 0, 0, 1 })).toBe(true)
	obs3 = transform(scaleMatrix, connector3)
	expect(compareVectors(obs3.point, { -3, -9, -15 })).toBe(true)
	expect(compareVectors(obs3.axis, { 0.1690308509457033, 0.5070925528371097, 0.8451542547285166 })).toBe(true)
	expect(compareVectors(obs3.normal, { 0.1690308509457033, -0.5070925528371097, 0.8451542547285166 })).toBe(true)
	local r = 90 * 0.017453292519943295
	local rotateZMatrix = { math.cos(r), math.sin(r), 0, 0, -math.sin(r), math.cos(r), 0, 0, 0, 0, 1, 0, 0, 0, 0, 1 }
	local obs4 = transform(rotateZMatrix, connector1)
	expect(compareVectors(obs4.point, { 0, 0, 0 })).toBe(true)
	expect(compareVectors(obs4.axis, { 0, 0, 1 })).toBe(true)
	expect(compareVectors(obs4.normal, { 6.123234262925839e-17, 1, 0 })).toBe(true)
	obs4 = transform(rotateZMatrix, connector2)
	expect(compareVectors(obs4.point, { 0, 1, 0 })).toBe(true)
	expect(compareVectors(obs4.axis, { -1, 0, 0 })).toBe(true)
	expect(compareVectors(obs4.normal, { 0, 0, 1 })).toBe(true)
	obs4 = transform(rotateZMatrix, connector3)
	expect(compareVectors(obs4.point, { 3, -3, -3 })).toBe(true)
	expect(compareVectors(obs4.axis, { -0.5773502691896258, 0.5773502691896258, 0.5773502691896258 })).toBe(true)
	expect(compareVectors(obs4.normal, { 0.5773502691896258, 0.5773502691896258, 0.5773502691896258 })).toBe(true)
end)
