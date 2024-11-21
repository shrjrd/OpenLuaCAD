-- ROBLOX NOTE: no upstream
--[[*
 * Computes the cross product (3D) of two vectors.
 *
 * @param {vec3} out - receiving vector (3D)
 * @param {vec2} a - first operand
 * @param {vec2} b - second operand
 * @returns {vec3} out
 * @alias module:modeling/maths/vec2.cross
 ]]
local function cross(out, a, b)
	out[
		1 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = 0
	out[
		2 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = 0
	out[
		3 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = a[
		1 --[[ ROBLOX adaptation: added 1 to array index ]]
	]
			* b[
				2 --[[ ROBLOX adaptation: added 1 to array index ]]
			]
		- a[
				2 --[[ ROBLOX adaptation: added 1 to array index ]]
			]
			* b[
				1 --[[ ROBLOX adaptation: added 1 to array index ]]
			]
	return out
end
return cross
