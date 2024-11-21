-- ROBLOX NOTE: no upstream
--[[*
 * Subtracts the coordinates of two vectors (A-B).
 *
 * @param {vec3} out - receiving vector
 * @param {vec3} a - minuend vector
 * @param {vec3} b - subtrahend vector
 * @returns {vec3} out
 * @alias module:modeling/maths/vec3.subtract
 ]]
local function subtract(out, a, b)
	out[
		1 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = a[
		1 --[[ ROBLOX adaptation: added 1 to array index ]]
	] - b[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		]
	out[
		2 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = a[
		2 --[[ ROBLOX adaptation: added 1 to array index ]]
	] - b[
			2 --[[ ROBLOX adaptation: added 1 to array index ]]
		]
	out[
		3 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = a[
		3 --[[ ROBLOX adaptation: added 1 to array index ]]
	] - b[
			3 --[[ ROBLOX adaptation: added 1 to array index ]]
		]
	return out
end
return subtract
