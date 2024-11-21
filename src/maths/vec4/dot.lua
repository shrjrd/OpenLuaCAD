-- ROBLOX NOTE: no upstream
--[[*
 * Calculates the dot product of the given vectors.
 *
 * @param {vec4} a - first vector
 * @param {vec4} b - second vector
 * @returns {Number} dot product
 * @alias module:modeling/maths/vec4.dot
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
	] + a[
		4 --[[ ROBLOX adaptation: added 1 to array index ]]
	] * b[
		4 --[[ ROBLOX adaptation: added 1 to array index ]]
	]
end
return dot
