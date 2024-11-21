-- ROBLOX NOTE: no upstream
--[[*
 * Returns the maximum coordinates of the given vectors.
 *
 * @param {vec3} out - receiving vector
 * @param {vec3} a - first operand
 * @param {vec3} b - second operand
 * @returns {vec3} out
 * @alias module:modeling/maths/vec3.max
 ]]
local function max(out, a, b)
	out[
		1 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = math.max(
		a[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		],
		b[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		]
	)
	out[
		2 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = math.max(
		a[
			2 --[[ ROBLOX adaptation: added 1 to array index ]]
		],
		b[
			2 --[[ ROBLOX adaptation: added 1 to array index ]]
		]
	)
	out[
		3 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = math.max(
		a[
			3 --[[ ROBLOX adaptation: added 1 to array index ]]
		],
		b[
			3 --[[ ROBLOX adaptation: added 1 to array index ]]
		]
	)
	return out
end
return max
