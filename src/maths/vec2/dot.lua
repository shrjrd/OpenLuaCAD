-- ROBLOX NOTE: no upstream
--[[*
 * Calculates the dot product of two vectors.
 *
 * @param {vec2} a - first operand
 * @param {vec2} b - second operand
 * @returns {Number} dot product
 * @alias module:modeling/maths/vec2.dot
 ]]
local function dot(a, b)
	return a[
		1 --[[ ROBLOX adaptation: added 1 to array index ]]
	] * b[
		1 --[[ ROBLOX adaptation: added 1 to array index ]]
	] + a[
		2 --[[ ROBLOX adaptation: added 1 to array index ]]
	] * b[
		2 --[[ ROBLOX adaptation: added 1 to array index ]]
	]
end
return dot
