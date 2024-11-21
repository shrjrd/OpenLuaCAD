-- ROBLOX NOTE: no upstream
--[[*
 * Calculates the Euclidian distance between the given vectors.
 *
 * @param {vec3} a - first operand
 * @param {vec3} b - second operand
 * @returns {Number} distance
 * @alias module:modeling/maths/vec3.distance
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
	local z = b[
		3 --[[ ROBLOX adaptation: added 1 to array index ]]
	] - a[
			3 --[[ ROBLOX adaptation: added 1 to array index ]]
		]
	return math.sqrt(x * x + y * y + z * z)
end
return distance
