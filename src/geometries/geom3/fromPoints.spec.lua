-- ROBLOX NOTE: no upstream
local JestGlobals = require("@DevPackages/JestGlobals")
local test, expect = JestGlobals.test, JestGlobals.expect

local fromPoints = require("./init").fromPoints
local comparePolygons, compareVectors
do
	local ref = require("../../../test/helpers/")
	comparePolygons, compareVectors = ref.comparePolygons, ref.compareVectors
end
test("fromPoints: Creates a populated geom3", function()
	local points = { { { 0, 0, 0 }, { 1, 0, 0 }, { 1, 0, 1 } } }
	local expected = {
		polygons = { { vertices = { { 0, 0, 0 }, { 1, 0, 0 }, { 1, 0, 1 } } } },
		isRetesselated = false,
		transforms = { 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1 },
	}
	local obs = fromPoints(points)
	expect(comparePolygons(
		obs.polygons[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		],
		expected.polygons[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		]
	)).toBe(true)
	expect(compareVectors(obs.transforms, expected.transforms)).toBe(true)
end)
test("fromPoints: throws for improper points", function()
	expect(function()
		return fromPoints()
	end).toThrowError(--[[{ instanceOf = Error }]])
	expect(function()
		return fromPoints(0, 0, 0)
	end).toThrowError(--[[{ instanceOf = Error }]])
end)
