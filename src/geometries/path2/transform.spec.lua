-- ROBLOX NOTE: no upstream
local JestGlobals = require("@DevPackages/JestGlobals")
local test, expect = JestGlobals.test, JestGlobals.expect

local mat4 = require("../../maths/mat4")
local transform, fromPoints, toPoints
do
	local ref = require("./init")
	transform, fromPoints, toPoints = ref.transform, ref.fromPoints, ref.toPoints
end
local comparePoints, compareVectors
do
	local ref = require("../../../test/helpers/")
	comparePoints, compareVectors = ref.comparePoints, ref.compareVectors
end
test("transform: adjusts the transforms of path", function()
	local points = { { 0, 0 }, { 1, 0 }, { 0, 1 } }
	local rotation = 90 * 0.017453292519943295
	local rotate90 = mat4.fromZRotation(mat4.create(), rotation) -- continue with typical user scenario, several iterations of transforms and access
	-- expect lazy transform, i.e. only the transforms change
	local expected = {
		points = { { 0, 0 }, { 1, 0 }, { 0, 1 } },
		isClosed = false,
		transforms = { 0, 1, 0, 0, -1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1 },
	}
	local geometry = fromPoints({}, points)
	local another = transform(rotate90, geometry)
	expect(geometry)["not"].toBe(another)
	expect(comparePoints(another.points, expected.points)).toBe(true)
	expect(another.isClosed).toBe(false)
	expect(compareVectors(another.transforms, expected.transforms)).toBe(true) -- expect lazy transform, i.e. only the transforms change
	expected.transforms = { 0, 1, 0, 0, -1, 0, 0, 0, 0, 0, 1, 0, 5, 10, 15, 1 }
	another = transform(mat4.fromTranslation(mat4.create(), { 5, 10, 15 }), another)
	expect(comparePoints(another.points, expected.points)).toBe(true)
	expect(another.isClosed).toBe(false)
	expect(compareVectors(another.transforms, expected.transforms)).toBe(true) -- expect application of the transforms to the sides
	expected.points = { { 5, 10 }, { 5, 11 }, { 4, 10 } }
	expected.transforms = mat4.create()
	toPoints(another)
	expect(comparePoints(another.points, expected.points)).toBe(true)
	expect(another.isClosed).toBe(false)
	expect(compareVectors(another.transforms, expected.transforms)).toBe(true) -- expect lazy transform, i.e. only the transforms change
	expected.transforms = { 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 5, 10, 15, 1 }
	another = transform(mat4.fromTranslation(mat4.create(), { 5, 10, 15 }), another)
	expect(comparePoints(another.points, expected.points)).toBe(true)
	expect(another.isClosed).toBe(false)
	expect(compareVectors(another.transforms, expected.transforms)).toBe(true)
end)
