-- ROBLOX NOTE: no upstream
--[[*
 * Performs a linear interpolation between two vectors.
 *
 * @param {vec2} out - receiving vector
 * @param {vec2} a - first operand
 * @param {vec2} b - second operand
 * @param {Number} t - interpolation amount between the two vectors
 * @returns {vec2} out
 * @alias module:modeling/maths/vec2.lerp
 ]]
local function lerp(out, a, b, t)
	local ax = a[
		1 --[[ ROBLOX adaptation: added 1 to array index ]]
	]
	local ay = a[
		2 --[[ ROBLOX adaptation: added 1 to array index ]]
	]
	out[
		1 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = ax
		+ t * (
			b[
				1 --[[ ROBLOX adaptation: added 1 to array index ]]
			] - ax
		)
	out[
		2 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = ay
		+ t * (
			b[
				2 --[[ ROBLOX adaptation: added 1 to array index ]]
			] - ay
		)
	return out
end
return lerp
