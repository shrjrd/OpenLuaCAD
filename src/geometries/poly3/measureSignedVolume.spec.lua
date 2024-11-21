-- ROBLOX NOTE: no upstream
local Number_EPSILON = 2.220446049250313e-16
local JestGlobals = require("@DevPackages/JestGlobals")
local test, expect = JestGlobals.test, JestGlobals.expect

local measureSignedVolume, create, invert, fromPoints, transform
do
	local ref = require("./init")
	measureSignedVolume, create, invert, fromPoints, transform =
		ref.measureSignedVolume, ref.create, ref.invert, ref.fromPoints, ref.transform
end
local mat4 = require("../../maths/mat4")
local nearlyEqual = require("../../../test/helpers/init").nearlyEqual
test("poly3. measureSignedVolume() should return correct values", function()
	local ply1 = create()
	local ret1 = measureSignedVolume(ply1)
	nearlyEqual(ret1, 0.0, Number_EPSILON) -- simple triangle
	local ply2 = fromPoints({ { 5, 5, 5 }, { 5, 15, 5 }, { 5, 15, 15 } })
	local ret2 = measureSignedVolume(ply2)
	nearlyEqual(ret2, 83.33333333333333, Number_EPSILON) -- simple square
	local ply3 = fromPoints({ { 5, 5, 5 }, { 5, 15, 5 }, { 5, 15, 15 }, { 5, 5, 15 } })
	local ret3 = measureSignedVolume(ply3)
	nearlyEqual(ret3, 166.66666666666666, Number_EPSILON) -- V-shape
	local points = {
		{ -50, 3, 0 },
		{ -50, 5, 0 },
		{ -50, 8, 2 },
		{ -50, 6, 5 },
		{ -50, 8, 6 },
		{ -50, 5, 6 },
		{ -50, 5, 2 },
		{ -50, 2, 5 },
		{ -50, 1, 3 },
		{ -50, 3, 3 },
	}
	local ply4 = fromPoints(points)
	local ret4 = measureSignedVolume(ply4)
	nearlyEqual(ret4, -325.00000, Number_EPSILON) -- rotated to various angles
	local rotation = mat4.fromZRotation(mat4.create(), 45 * 0.017453292519943295)
	ply1 = transform(rotation, ply1)
	ply2 = transform(rotation, ply2)
	ply3 = transform(rotation, ply3)
	ply4 = transform(rotation, ply4)
	ret1 = measureSignedVolume(ply1)
	ret2 = measureSignedVolume(ply2)
	ret3 = measureSignedVolume(ply3)
	ret4 = measureSignedVolume(ply4)
	nearlyEqual(ret1, 0.0, Number_EPSILON)
	nearlyEqual(ret2, 83.33333333333331, Number_EPSILON)
	nearlyEqual(ret3, 166.66666666666663, Number_EPSILON)
	nearlyEqual(ret4, -324.9999999999994, Number_EPSILON) -- inverted (opposite rotation, normal)
	ply2 = invert(ply2)
	ply3 = invert(ply3)
	ply4 = invert(ply4)
	ret2 = measureSignedVolume(ply2)
	ret3 = measureSignedVolume(ply3)
	ret4 = measureSignedVolume(ply4)
	nearlyEqual(ret2, -83.33333333333331, Number_EPSILON)
	nearlyEqual(ret3, -166.66666666666663, Number_EPSILON)
	nearlyEqual(ret4, 324.9999999999994, Number_EPSILON)
	expect(true).toBe(true)
end)
