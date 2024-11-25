-- ROBLOX NOTE: no upstream

local LuauPolyfill = require("@Packages/LuauPolyfill")
local Array = LuauPolyfill.Array
local flatten = require("../../utils/flatten")
local geom3 = require("../../geometries/geom3")
local measureEpsilon = require("../../measurements/measureEpsilon")
local fromFakePolygons = require("./fromFakePolygons")
local to3DWalls = require("./to3DWalls")
local unionGeom3 = require("./unionGeom3")
--[[
 * Return a new 2D geometry representing the total space in the given 2D geometries.
 * @param {...geom2} geometries - list of 2D geometries to union
 * @returns {geom2} new 2D geometry
 ]]
local function union(
	...: any --[[ ROBLOX CHECK: check correct type of elements. ]]
)
	local geometries = { ... }
	geometries = flatten(geometries)
	local newgeometries = Array.map(geometries, function(geometry)
		return to3DWalls({ z0 = -1, z1 = 1 }, geometry)
	end) --[[ ROBLOX CHECK: check if 'geometries' is an Array ]]
	local newgeom3 = unionGeom3(newgeometries)
	local epsilon = measureEpsilon(newgeom3)
	return fromFakePolygons(epsilon, geom3.toPolygons(newgeom3))
end
return union
