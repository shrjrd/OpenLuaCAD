-- ROBLOX NOTE: no upstream

local LuauPolyfill = require("@Packages/LuauPolyfill")
local Math = LuauPolyfill.Math
--[[*
 * Snaps the coordinates of the given vector to the given epsilon.
 *
 * @param {vec2} out - receiving vector
 * @param {vec2} vector - vector to snap
 * @param {Number} epsilon - epsilon of precision, less than 0
 * @returns {vec2} out
 * @alias module:modeling/maths/vec2.snap
 ]]
local function snap(out, vector, epsilon)
	out[
		1 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = Math.round(vector[
		1 --[[ ROBLOX adaptation: added 1 to array index ]]
	] / epsilon) --[[ ROBLOX NOTE: Math.round is currently not supported by the Luau Math polyfill, please add your own implementation or file a ticket on the same ]]
			* epsilon
		+ 0
	out[
		2 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = Math.round(vector[
		2 --[[ ROBLOX adaptation: added 1 to array index ]]
	] / epsilon) --[[ ROBLOX NOTE: Math.round is currently not supported by the Luau Math polyfill, please add your own implementation or file a ticket on the same ]]
			* epsilon
		+ 0
	return out
end
return snap
