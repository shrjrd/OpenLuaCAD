-- ROBLOX NOTE: no upstream

local LuauPolyfill = require("@Packages/LuauPolyfill")
local Array = LuauPolyfill.Array
local poly3 = require("../poly3")
local toPolygons = require("./toPolygons")
--[[*
 * Return the given geometry as a list of points, after applying transforms.
 * The returned array should not be modified as the points are shared with the geometry.
 * @param {geom3} geometry - the geometry
 * @return {Array} list of points, where each sub-array represents a polygon
 * @alias module:modeling/geometries/geom3.toPoints
 ]]
local function toPoints(geometry)
	local polygons = toPolygons(geometry)
	local listofpoints = Array.map(polygons, function(polygon)
		return poly3.toPoints(polygon)
	end) --[[ ROBLOX CHECK: check if 'polygons' is an Array ]]
	return listofpoints
end
return toPoints
