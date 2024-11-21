-- ROBLOX NOTE: no upstream
local Packages = game.ReplicatedStorage.Packages
local LuauPolyfill = require(Packages.LuauPolyfill)
local Array = LuauPolyfill.Array
local Boolean = LuauPolyfill.Boolean
local plane = require("../../maths/plane")
local create = require("./create")
--[[*
 * Invert the give polygon to face the opposite direction.
 *
 * @param {poly3} polygon - the polygon to invert
 * @returns {poly3} a new poly3
 * @alias module:modeling/geometries/poly3.invert
 ]]
local function invert(polygon)
	local vertices =
		Array.reverse(Array.slice(polygon.vertices) --[[ ROBLOX CHECK: check if 'polygon.vertices' is an Array ]])
	local inverted = create(vertices)
	if Boolean.toJSBoolean(polygon.plane) then
		-- Flip existing plane to save recompute
		inverted.plane = plane.flip(plane.create(), polygon.plane)
	end
	return inverted
end
return invert
