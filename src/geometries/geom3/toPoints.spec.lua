-- ROBLOX NOTE: no upstream
local JestGlobals = require("@DevPackages/JestGlobals")
local test, expect = JestGlobals.test, JestGlobals.expect

local toPoints, fromPoints, toString
do
	local ref = require("./init")
	toPoints, fromPoints, toString = ref.toPoints, ref.fromPoints, ref.toString
end
local comparePolygonsAsPoints = require("../../../test/helpers/").comparePolygonsAsPoints
test("toPoints: Creates an array of points from a populated geom3", function()
	local points = { { { 0, 0, 0 }, { 1, 0, 0 }, { 1, 0, 1 } } }
	local geometry = fromPoints(points)
	toString(geometry)
	local expected = { { { 0, 0, 0 }, { 1, 0, 0 }, { 1, 0, 1 } } }
	local pointarray = toPoints(geometry)
	expect(pointarray).toEqual(expected)
	expect(comparePolygonsAsPoints(pointarray, expected)).toBe(true)
	toString(geometry)
end)
