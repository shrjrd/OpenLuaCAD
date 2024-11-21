-- ROBLOX NOTE: no upstream
--[[*
 * Calculates the absolute coordinates of the give vector.
 *
 * @param {vec3} out - receiving vector
 * @param {vec3} vector - vector of reference
 * @returns {vec3} out
 * @alias module:modeling/maths/vec3.abs
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
	out[
		3 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = math.abs(vector[
		3 --[[ ROBLOX adaptation: added 1 to array index ]]
	])
	return out
end
return abs
