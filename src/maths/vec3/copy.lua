-- ROBLOX NOTE: no upstream
--[[*
 * Create a copy of the given vector.
 *
 * @param {vec3} out - receiving vector
 * @param {vec3} vector - vector to copy
 * @returns {vec3} out
 * @alias module:modeling/maths/vec3.copy
 ]]
local function copy(out, vector)
	out[
		1 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = vector[
		1 --[[ ROBLOX adaptation: added 1 to array index ]]
	]
	out[
		2 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = vector[
		2 --[[ ROBLOX adaptation: added 1 to array index ]]
	]
	out[
		3 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = vector[
		3 --[[ ROBLOX adaptation: added 1 to array index ]]
	]
	return out
end
return copy
