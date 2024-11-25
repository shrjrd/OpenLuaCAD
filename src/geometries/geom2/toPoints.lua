-- ROBLOX NOTE: no upstream

local LuauPolyfill = require("@Packages/LuauPolyfill")
local Array = LuauPolyfill.Array
local toSides = require("./toSides")
--[[*
 * Produces an array of points from the given geometry.
 * The returned array should not be modified as the points are shared with the geometry.
 * NOTE: The points returned do NOT define an order. Use toOutlines() for ordered points.
 * @param {geom2} geometry - the geometry
 * @returns {Array} an array of points
 * @alias module:modeling/geometries/geom2.toPoints
 *
 * @example
 * let sharedpoints = toPoints(geometry)
 ]]
local function toPoints(geometry)
	local sides = toSides(geometry)
	local points = Array.map(sides, function(side)
		return side[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		]
	end) --[[ ROBLOX CHECK: check if 'sides' is an Array ]] -- due to the logic of fromPoints()
	-- move the first point to the last
	if
		#points
		> 0 --[[ ROBLOX CHECK: operator '>' works only if either both arguments are strings or both are a number ]]
	then
		table.insert(points, table.remove(points, 1) --[[ ROBLOX CHECK: check if 'points' is an Array ]]) --[[ ROBLOX CHECK: check if 'points' is an Array ]]
	end
	return points
end
return toPoints
