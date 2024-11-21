-- ROBLOX NOTE: no upstream
local flatten = require("../../utils/flatten")
local geom3 = require("../../geometries/geom3")
local toUniquePoints = require("./toUniquePoints")
local hullPoints3 = require("./hullPoints3")
--[[
 * Create a convex hull of the given geom3 geometries.
 *
 * NOTE: The given geometries must be valid geom3 geometries.
 *
 * @param {...geometries} geometries - list of geom3 geometries
 * @returns {geom3} new geometry
 ]]
local function hullGeom3(
	...: any --[[ ROBLOX CHECK: check correct type of elements. ]]
)
	local geometries = { ... }
	geometries = flatten(geometries) -- extract the unique vertices from the geometries
	local unique = toUniquePoints(geometries)
	if #unique == 0 then
		return geom3.create()
	end
	return geom3.create(hullPoints3(unique))
end
return hullGeom3
