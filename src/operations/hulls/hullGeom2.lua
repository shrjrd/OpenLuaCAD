-- ROBLOX NOTE: no upstream
local flatten = require("../../utils/flatten")
local geom2 = require("../../geometries/geom2")
local hullPoints2 = require("./hullPoints2")
local toUniquePoints = require("./toUniquePoints")
--[[
 * Create a convex hull of the given geom2 geometries.
 *
 * NOTE: The given geometries must be valid geom2 geometries.
 *
 * @param {...geometries} geometries - list of geom2 geometries
 * @returns {geom2} new geometry
 ]]
local function hullGeom2(
	...: any --[[ ROBLOX CHECK: check correct type of elements. ]]
)
	local geometries = { ... }
	geometries = flatten(geometries) -- extract the unique points from the geometries
	local unique = toUniquePoints(geometries)
	local hullPoints = hullPoints2(unique) -- NOTE: more than three points are required to create a new geometry
	if
		#hullPoints
		< 3 --[[ ROBLOX CHECK: operator '<' works only if either both arguments are strings or both are a number ]]
	then
		return geom2.create()
	end -- assemble a new geometry from the list of points
	return geom2.fromPoints(hullPoints)
end
return hullGeom2
