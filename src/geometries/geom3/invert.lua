-- ROBLOX NOTE: no upstream

local LuauPolyfill = require("@Packages/LuauPolyfill")
local Array = LuauPolyfill.Array
local poly3 = require("../poly3")
local create = require("./create")
local toPolygons = require("./toPolygons")
--[[*
 * Invert the given geometry, transposing solid and empty space.
 * @param {geom3} geometry - the geometry to invert
 * @return {geom3} a new geometry
 * @alias module:modeling/geometries/geom3.invert
 ]]
local function invert(geometry)
	local polygons = toPolygons(geometry)
	local newpolygons = Array.map(polygons, function(polygon)
		return poly3.invert(polygon)
	end) --[[ ROBLOX CHECK: check if 'polygons' is an Array ]]
	return create(newpolygons)
end
return invert
