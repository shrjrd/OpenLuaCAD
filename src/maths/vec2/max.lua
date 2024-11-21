-- ROBLOX NOTE: no upstream
--[[*
 * Returns the maximum coordinates of two vectors.
 *
 * @param {vec2} out - receiving vector
 * @param {vec2} a - first operand
 * @param {vec2} b - second operand
 * @returns {vec2} out
 * @alias module:modeling/maths/vec2.max
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
	return out
end
return max
