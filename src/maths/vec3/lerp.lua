-- ROBLOX NOTE: no upstream
--[[*
 * Performs a linear interpolation between two vectors.
 *
 * @param {vec3} out - receiving vector
 * @param {vec3} a - first operand
 * @param {vec3} b - second operand
 * @param {Number} t - interpolant (0.0 to 1.0) applied between the two inputs
 * @returns {vec3} out
 * @alias module:modeling/maths/vec3.lerp
 ]]
local function lerp(out, a, b, t)
	out[
		1 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = a[
		1 --[[ ROBLOX adaptation: added 1 to array index ]]
	]
		+ t
			* (
				b[
					1 --[[ ROBLOX adaptation: added 1 to array index ]]
				] - a[
					1 --[[ ROBLOX adaptation: added 1 to array index ]]
				]
			)
	out[
		2 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = a[
		2 --[[ ROBLOX adaptation: added 1 to array index ]]
	]
		+ t
			* (
				b[
					2 --[[ ROBLOX adaptation: added 1 to array index ]]
				] - a[
					2 --[[ ROBLOX adaptation: added 1 to array index ]]
				]
			)
	out[
		3 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = a[
		3 --[[ ROBLOX adaptation: added 1 to array index ]]
	]
		+ t
			* (
				b[
					3 --[[ ROBLOX adaptation: added 1 to array index ]]
				] - a[
					3 --[[ ROBLOX adaptation: added 1 to array index ]]
				]
			)
	return out
end
return lerp
