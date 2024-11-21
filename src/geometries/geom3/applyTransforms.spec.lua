-- ROBLOX NOTE: no upstream
local JestGlobals = require("@DevPackages/JestGlobals")
local test, expect = JestGlobals.test, JestGlobals.expect

local fromPoints = require("./init").fromPoints
local applyTransforms = require("./applyTransforms")
local comparePolygons, compareVectors
do
	local ref = require("../../../test/helpers/")
	comparePolygons, compareVectors = ref.comparePolygons, ref.compareVectors
end
test("applyTransforms: Updates a geom3 with transformed polygons", function()
	local points = { { { 0, 0, 0 }, { 1, 0, 0 }, { 1, 0, 1 } } }
	local expected = {
		polygons = { { vertices = { { 0, 0, 0 }, { 1, 0, 0 }, { 1, 0, 1 } } } },
		isRetesselated = false,
		transforms = { 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1 },
	}
	local geometry = fromPoints(points)
	local updated = applyTransforms(geometry)
	expect(geometry).toBe(updated)
	expect(comparePolygons(
		updated.polygons[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		],
		expected.polygons[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		]
	)).toBe(true)
	expect(compareVectors(updated.transforms, expected.transforms)).toBe(true)
	local updated2 = applyTransforms(updated)
	expect(updated).toBe(updated2)
	expect(comparePolygons(
		updated2.polygons[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		],
		expected.polygons[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		]
	)).toBe(true)
	expect(compareVectors(updated2.transforms, expected.transforms)).toBe(true)
end)
