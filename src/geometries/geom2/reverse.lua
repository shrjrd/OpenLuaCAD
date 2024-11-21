-- ROBLOX NOTE: no upstream
local Packages = game.ReplicatedStorage.Packages
local LuauPolyfill = require(Packages.LuauPolyfill)
local Array = LuauPolyfill.Array
local create = require("./create")
local toSides = require("./toSides")
--[[*
 * Reverses the given geometry so that the sides are flipped in the opposite order.
 * This swaps the left (interior) and right (exterior) edges.
 * @param {geom2} geometry - the geometry to reverse
 * @returns {geom2} the new reversed geometry
 * @alias module:modeling/geometries/geom2.reverse
 *
 * @example
 * let newgeometry = reverse(geometry)
 ]]
local function reverse(geometry)
	local oldsides = toSides(geometry)
	local newsides = Array.map(oldsides, function(side)
		return {
			side[
				2 --[[ ROBLOX adaptation: added 1 to array index ]]
			],
			side[
				1 --[[ ROBLOX adaptation: added 1 to array index ]]
			],
		}
	end) --[[ ROBLOX CHECK: check if 'oldsides' is an Array ]]
	Array.reverse(newsides) --[[ ROBLOX CHECK: check if 'newsides' is an Array ]] -- is this required?
	return create(newsides)
end
return reverse
