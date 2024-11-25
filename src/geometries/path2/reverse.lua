-- ROBLOX NOTE: no upstream

local LuauPolyfill = require("@Packages/LuauPolyfill")
local Array = LuauPolyfill.Array
local clone = require("./clone")
--[[*
 * Reverses the path so that the points are in the opposite order.
 * This swaps the left (interior) and right (exterior) edges.
 * @param {path2} geometry - the path to reverse
 * @returns {path2} a new path
 * @alias module:modeling/geometries/path2.reverse
 *
 * @example
 * let newpath = reverse(mypath)
 ]]
local function reverse(geometry)
	-- NOTE: this only updates the order of the points
	local cloned = clone(geometry)
	cloned.points =
		Array.reverse(Array.slice(geometry.points) --[[ ROBLOX CHECK: check if 'geometry.points' is an Array ]])
	return cloned
end
return reverse
