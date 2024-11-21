-- ROBLOX NOTE: no upstream
--[[*
 * Calculates the length of a vector.
 *
 * @param {vec3} vector - vector to calculate length of
 * @returns {Number} length
 * @alias module:modeling/maths/#vec3
 ]]
local function length(vector)
	local x = vector[
		1 --[[ ROBLOX adaptation: added 1 to array index ]]
	]
	local y = vector[
		2 --[[ ROBLOX adaptation: added 1 to array index ]]
	]
	local z = vector[
		3 --[[ ROBLOX adaptation: added 1 to array index ]]
	]
	return math.sqrt(x * x + y * y + z * z)
end
return length
