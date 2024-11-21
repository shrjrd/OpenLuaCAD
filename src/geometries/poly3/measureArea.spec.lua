-- ROBLOX NOTE: no upstream
local Number_EPSILON = 2.220446049250313e-16
local JestGlobals = require("@DevPackages/JestGlobals")
local test, expect = JestGlobals.test, JestGlobals.expect

local measureArea, create, invert, fromPoints, transform
do
	local ref = require("./init")
	measureArea, create, invert, fromPoints, transform =
		ref.measureArea, ref.create, ref.invert, ref.fromPoints, ref.transform
end
local mat4 = require("../../maths/mat4")
local nearlyEqual = require("../../../test/helpers/init").nearlyEqual
test("poly3. measureArea() should return correct values", function()
	local ply1 = create()
	local ret1 = measureArea(ply1)
	expect(ret1).toBe(0.0) -- simple triangle
	local ply2 = fromPoints({ { 0, 0, 0 }, { 0, 10, 0 }, { 0, 10, 10 } })
	local ret2 = measureArea(ply2)
	expect(ret2).toBe(50.0) -- simple square
	local ply3 = fromPoints({ { 0, 0, 0 }, { 0, 10, 0 }, { 0, 10, 10 }, { 0, 0, 10 } })
	local ret3 = measureArea(ply3)
	expect(ret3).toBe(100.0) -- V-shape
	local points = {
		{ 0, 3, 0 },
		{ 0, 5, 0 },
		{ 0, 8, 2 },
		{ 0, 6, 5 },
		{ 0, 8, 6 },
		{ 0, 5, 6 },
		{ 0, 5, 2 },
		{ 0, 2, 5 },
		{ 0, 1, 3 },
		{ 0, 3, 3 },
	}
	local ply4 = fromPoints(points)
	local ret4 = measureArea(ply4)
	expect(ret4).toBe(19.5) -- colinear vertices non-zero area
	local ply5 = fromPoints({ { 0, 0, 0 }, { 1, 0, 0 }, { 2, 0, 0 }, { 0, 1, 0 } })
	local ret5 = measureArea(ply5)
	expect(ret5).toBe(1) -- colinear vertices empty area
	local ply6 = fromPoints({ { 0, 0, 0 }, { 1, 0, 0 }, { 2, 0, 0 } })
	local ret6 = measureArea(ply6)
	expect(ret6).toBe(0) -- duplicate vertices empty area
	local ply7 = fromPoints({ { 0, 0, 0 }, { 0, 0, 0 }, { 0, 0, 0 } })
	local ret7 = measureArea(ply7)
	expect(ret7).toBe(0) -- rotated to various angles
	local rotation = mat4.fromZRotation(mat4.create(), 45 * 0.017453292519943295)
	ply1 = transform(rotation, ply1)
	ply2 = transform(rotation, ply2)
	ply3 = transform(rotation, ply3)
	ply4 = transform(rotation, ply4)
	ret1 = measureArea(ply1)
	ret2 = measureArea(ply2)
	ret3 = measureArea(ply3)
	ret4 = measureArea(ply4)
	nearlyEqual(ret1, 0.0, Number_EPSILON)
	nearlyEqual(ret2, 50.0, Number_EPSILON)
	nearlyEqual(ret3, 100.0, Number_EPSILON)
	nearlyEqual(ret4, 19.5, Number_EPSILON)
	rotation = mat4.fromYRotation(mat4.create(), 45 * 0.017453292519943295)
	ply1 = transform(rotation, ply1)
	ply2 = transform(rotation, ply2)
	ply3 = transform(rotation, ply3)
	ply4 = transform(rotation, ply4)
	ret1 = measureArea(ply1)
	ret2 = measureArea(ply2)
	ret3 = measureArea(ply3)
	ret4 = measureArea(ply4)
	nearlyEqual(ret1, 0.0, Number_EPSILON)
	nearlyEqual(ret2, 50.0, Number_EPSILON)
	nearlyEqual(ret3, 100.0, Number_EPSILON)
	nearlyEqual(ret4, 19.5, Number_EPSILON)
	rotation = mat4.fromXRotation(mat4.create(), 45 * 0.017453292519943295)
	ply1 = transform(rotation, ply1)
	ply2 = transform(rotation, ply2)
	ply3 = transform(rotation, ply3)
	ply4 = transform(rotation, ply4)
	ret1 = measureArea(ply1)
	ret2 = measureArea(ply2)
	ret3 = measureArea(ply3)
	ret4 = measureArea(ply4)
	nearlyEqual(ret1, 0.0, Number_EPSILON)
	nearlyEqual(ret2, 50.0, Number_EPSILON)
	nearlyEqual(ret3, 100.0, Number_EPSILON)
	nearlyEqual(ret4, 19.5, Number_EPSILON) -- inverted
	ply1 = invert(ply1)
	ply2 = invert(ply2)
	ply3 = invert(ply3)
	ply4 = invert(ply4)
	ret1 = measureArea(ply1)
	ret2 = measureArea(ply2)
	ret3 = measureArea(ply3)
	ret4 = measureArea(ply4)
	nearlyEqual(ret1, 0.0, Number_EPSILON)
	nearlyEqual(ret2, 50.0, Number_EPSILON)
	nearlyEqual(ret3, 100.0, Number_EPSILON)
	nearlyEqual(ret4, 19.5, Number_EPSILON * 2)
end)
