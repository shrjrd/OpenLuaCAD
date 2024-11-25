-- ROBLOX NOTE: no upstream
local JestGlobals = require("@DevPackages/JestGlobals")
local test, expect = JestGlobals.test, JestGlobals.expect

local invert, create, fromPoints
do
	local ref = require("./init")
	invert, create, fromPoints = ref.invert, ref.create, ref.fromPoints
end
local comparePolygons, compareVectors
do
	local ref = require("../../../test/helpers/")
	comparePolygons, compareVectors = ref.comparePolygons, ref.compareVectors
end
test("invert: Creates a invert on an empty geom3", function()
	local expected = { polygons = {}, transforms = { 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1 } }
	local geometry = create()
	local another = invert(geometry)
	expect(another).never.toBe(geometry)
	expect(another).toEqual(expected)
end)
test("invert: Creates a invert of a populated geom3", function()
	local points = { { { 0, 0, 0 }, { 1, 0, 0 }, { 1, 0, 1 } } }
	local expected = {
		polygons = { { vertices = { { 1, 0, 1 }, { 1, 0, 0 }, { 0, 0, 0 } } } },
		transforms = { 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1 },
	}
	local geometry = fromPoints(points)
	local another = invert(geometry)
	expect(another).never.toBe(geometry)
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
