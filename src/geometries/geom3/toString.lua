-- ROBLOX NOTE: no upstream

local LuauPolyfill = require("@Packages/LuauPolyfill")
local Array = LuauPolyfill.Array
local poly3 = require("../poly3")
local toPolygons = require("./toPolygons")
--[[*
 * Create a string representing the contents of the given geometry.
 * @param {geom3} geometry - the geometry
 * @returns {String} a representative string
 * @alias module:modeling/geometries/geom3.toString
 *
 * @example
 * console.out(toString(geometry))
 ]]
local function toString(geometry)
	local polygons = toPolygons(geometry)
	local result = "geom3 (" .. tostring(#polygons) .. " polygons):\n"
	Array.forEach(polygons, function(polygon)
		result ..= "  " .. tostring(poly3.toString(polygon)) .. "\n"
	end) --[[ ROBLOX CHECK: check if 'polygons' is an Array ]]
	return result
end
return toString
