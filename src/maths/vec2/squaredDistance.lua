-- ROBLOX NOTE: no upstream
--[[*
 * Calculates the squared distance between the given vectors.
 *
 * @param {vec2} a - first operand
 * @param {vec2} b - second operand
 * @returns {Number} squared distance
 * @alias module:modeling/maths/vec2.squaredDistance
 ]]
local function squaredDistance(a, b)
	local x = b[
		1 --[[ ROBLOX adaptation: added 1 to array index ]]
	] - a[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		]
	local y = b[
		2 --[[ ROBLOX adaptation: added 1 to array index ]]
	] - a[
			2 --[[ ROBLOX adaptation: added 1 to array index ]]
		]
	return x * x + y * y
end
return squaredDistance
