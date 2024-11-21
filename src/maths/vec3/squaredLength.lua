-- ROBLOX NOTE: no upstream
--[[*
 * Calculates the squared length of the given vector.
 *
 * @param {vec3} vector - vector to calculate squared length of
 * @returns {Number} squared length
 * @alias module:modeling/maths/vec3.squaredLength
 ]]
local function squaredLength(vector)
	local x = vector[
		1 --[[ ROBLOX adaptation: added 1 to array index ]]
	]
	local y = vector[
		2 --[[ ROBLOX adaptation: added 1 to array index ]]
	]
	local z = vector[
		3 --[[ ROBLOX adaptation: added 1 to array index ]]
	]
	return x * x + y * y + z * z
end
return squaredLength
