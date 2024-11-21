-- ROBLOX NOTE: no upstream
--[[*
 * Calculates the absolute coordinates of the given vector.
 *
 * @param {vec2} out - receiving vector
 * @param {vec2} vector - vector of reference
 * @returns {vec2} out
 * @alias module:modeling/maths/vec2.abs
 ]]
local function abs(out, vector)
	out[
		1 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = math.abs(vector[
		1 --[[ ROBLOX adaptation: added 1 to array index ]]
	])
	out[
		2 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = math.abs(vector[
		2 --[[ ROBLOX adaptation: added 1 to array index ]]
	])
	return out
end
return abs
