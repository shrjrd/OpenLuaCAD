-- ROBLOX NOTE: no upstream
local JestGlobals = require("@DevPackages/JestGlobals")
local test, expect = JestGlobals.test, JestGlobals.expect

local toPoints, create, fromPoints, toString
do
	local ref = require("./init")
	toPoints, create, fromPoints, toString = ref.toPoints, ref.create, ref.fromPoints, ref.toString
end
local comparePoints = require("../../../test/helpers/").comparePoints
test("toPoints: creates an empty array of points from a unpopulated geom2", function()
	local geometry = create()
	local pointarray = toPoints(geometry)
	expect(pointarray).toEqual({})
end)
test("toPoints: creates an array of points from a populated geom2", function()
	local points = { { 0, 0 }, { 1, 0 }, { 0, 1 } }
	local geometry = fromPoints(points)
	toString(geometry)
	local expected = { { 0, 0 }, { 1, 0 }, { 0, 1 } }
	local pointarray = toPoints(geometry)
	expect(comparePoints(pointarray, expected)).toBe(true)
	toString(geometry)
end)
