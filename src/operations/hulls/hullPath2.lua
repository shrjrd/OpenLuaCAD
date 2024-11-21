-- ROBLOX NOTE: no upstream
local flatten = require("../../utils/flatten")
local path2 = require("../../geometries/path2")
local hullPoints2 = require("./hullPoints2")
local toUniquePoints = require("./toUniquePoints")
--[[
 * Create a convex hull of the given path2 geometries.
 *
 * NOTE: The given geometries must be valid path2 geometry.
 *
 * @param {...geometries} geometries - list of path2 geometries
 * @returns {path2} new geometry
 ]]
local function hullPath2(
	...: any --[[ ROBLOX CHECK: check correct type of elements. ]]
)
	local geometries = { ... }
	geometries = flatten(geometries) -- extract the unique points from the geometries
	local unique = toUniquePoints(geometries)
	local hullPoints = hullPoints2(unique) -- assemble a new geometry from the list of points
	return path2.fromPoints({ closed = true }, hullPoints)
end
return hullPath2
