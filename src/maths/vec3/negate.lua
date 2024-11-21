-- ROBLOX NOTE: no upstream
--[[*
 * Negates the coordinates of the given vector.
 *
 * @param {vec3} out - receiving vector
 * @param {vec3} vector - vector to negate
 * @returns {vec3} out
 * @alias module:modeling/maths/vec3.negate
 ]]
local function negate(out, vector)
	out[
		1 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = -vector[
		1 --[[ ROBLOX adaptation: added 1 to array index ]]
	]
	out[
		2 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = -vector[
		2 --[[ ROBLOX adaptation: added 1 to array index ]]
	]
	out[
		3 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = -vector[
		3 --[[ ROBLOX adaptation: added 1 to array index ]]
	]
	return out
end
return negate
