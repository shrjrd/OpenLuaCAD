-- ROBLOX NOTE: no upstream
--[[*
 * Calculates the dot product of two vectors.
 *
 * @param {vec3} a - first operand
 * @param {vec3} b - second operand
 * @returns {Number} dot product
 * @alias module:modeling/maths/vec3.dot
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
	] + a[
		3 --[[ ROBLOX adaptation: added 1 to array index ]]
	] * b[
		3 --[[ ROBLOX adaptation: added 1 to array index ]]
	]
end
return dot
