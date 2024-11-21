-- ROBLOX NOTE: no upstream
local Packages = game.ReplicatedStorage.Packages
local LuauPolyfill = require(Packages.LuauPolyfill)
local Array = LuauPolyfill.Array
local create = require("./create")
--[[*
 * Flip the give polygon, rotating the opposite direction.
 *
 * @param {poly2} polygon - the polygon to flip
 * @returns {poly2} a new polygon
 * @alias module:modeling/geometries/poly2.flip
 ]]
local function flip(polygon)
	local vertices =
		Array.reverse(Array.slice(polygon.vertices) --[[ ROBLOX CHECK: check if 'polygon.vertices' is an Array ]])
	return create(vertices)
end
return flip
