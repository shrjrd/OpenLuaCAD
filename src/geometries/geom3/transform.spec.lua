-- ROBLOX NOTE: no upstream
local JestGlobals = require("@DevPackages/JestGlobals")
local test, expect = JestGlobals.test, JestGlobals.expect

local mat4 = require("../../maths/mat4")
local transform, fromPoints, toPolygons
do
	local ref = require("./init")
	transform, fromPoints, toPolygons = ref.transform, ref.fromPoints, ref.toPolygons
end
local comparePolygons, compareVectors
do
	local ref = require("../../../test/helpers/")
	comparePolygons, compareVectors = ref.comparePolygons, ref.compareVectors
end
test("transform: Adjusts the transforms of a populated geom3", function()
	local points = { { { 0, 0, 0 }, { 1, 0, 0 }, { 1, 0, 1 } } }
	local rotation = 90 * 0.017453292519943295
	local rotate90 = mat4.fromZRotation(mat4.create(), rotation) -- continue with typical user scenario, several iterations of transforms and access
	-- expect lazy transform, i.e. only the transforms change
	local expected = {
		polygons = { { vertices = { { 0, 0, 0 }, { 1, 0, 0 }, { 1, 0, 1 } } } },
		transforms = { 0, 1, 0, 0, -1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1 },
	}
	local geometry = fromPoints(points)
	local another = transform(rotate90, geometry)
	expect(geometry).never.toBe(another)
	expect(comparePolygons(
		another.polygons[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		],
		expected.polygons[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		]
	)).toBe(true)
	expect(compareVectors(another.transforms, expected.transforms)).toBe(true) -- expect lazy transform, i.e. only the transforms change
	expected.transforms = {
		6.123234262925839e-17,
		1,
		0,
		0,
		-1,
		6.123234262925839e-17,
		0,
		0,
		0,
		0,
		1,
		0,
		5,
		10,
		15,
		1,
	}
	another = transform(mat4.fromTranslation(mat4.create(), { 5, 10, 15 }), another)
	expect(comparePolygons(
		another.polygons[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		],
		expected.polygons[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		]
	)).toBe(true)
	expect(compareVectors(another.transforms, expected.transforms)).toBe(true) -- expect application of the transforms to the polygons
	expected.polygons = { { vertices = { { 5, 10, 15 }, { 5, 11, 15 }, { 5, 11, 16 } } } }
	expected.transforms = mat4.create()
	toPolygons(another)
	expect(comparePolygons(
		another.polygons[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		],
		expected.polygons[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		]
	)).toBe(true)
	expect(compareVectors(another.transforms, expected.transforms)).toBe(true) -- expect lazy transform, i.e. only the transforms change
	expected.transforms = { 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 5, 10, 15, 1 }
	another = transform(mat4.fromTranslation(mat4.create(), { 5, 10, 15 }), another)
	expect(comparePolygons(
		another.polygons[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		],
		expected.polygons[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		]
	)).toBe(true)
	expect(compareVectors(another.transforms, expected.transforms)).toBe(true)
end)
