-- ROBLOX NOTE: no upstream
--[[*
 * Returns the minimum coordinates of the given vectors.
 *
 * @param {vec3} out - receiving vector
 * @param {vec3} a - first operand
 * @param {vec3} b - second operand
 * @returns {vec3} out
 * @alias module:modeling/maths/vec3.min
 ]]
local function min(out, a, b)
	out[
		1 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = math.min(
		a[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		],
		b[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		]
	)
	out[
		2 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = math.min(
		a[
			2 --[[ ROBLOX adaptation: added 1 to array index ]]
		],
		b[
			2 --[[ ROBLOX adaptation: added 1 to array index ]]
		]
	)
	out[
		3 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = math.min(
		a[
			3 --[[ ROBLOX adaptation: added 1 to array index ]]
		],
		b[
			3 --[[ ROBLOX adaptation: added 1 to array index ]]
		]
	)
	return out
end
return min
