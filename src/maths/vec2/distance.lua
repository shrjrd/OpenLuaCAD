-- ROBLOX NOTE: no upstream
--[[*
 * Calculates the distance between two vectors.
 *
 * @param {vec2} a - first operand
 * @param {vec2} b - second operand
 * @returns {Number} distance
 * @alias module:modeling/maths/vec2.distance
 ]]
local function distance(a, b)
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
	return math.sqrt(x * x + y * y)
end
return distance
