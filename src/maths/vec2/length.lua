-- ROBLOX NOTE: no upstream
--[[*
 * Calculates the length of the given vector.
 *
 * @param {vec2} vector - vector of reference
 * @returns {Number} length
 * @alias module:modeling/maths/#vec2
 ]]
local function length(vector)
	return math.sqrt(vector[
		1 --[[ ROBLOX adaptation: added 1 to array index ]]
	] * vector[
		1 --[[ ROBLOX adaptation: added 1 to array index ]]
	] + vector[
		2 --[[ ROBLOX adaptation: added 1 to array index ]]
	] * vector[
		2 --[[ ROBLOX adaptation: added 1 to array index ]]
	])
end
return length
