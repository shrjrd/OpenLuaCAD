-- ROBLOX NOTE: no upstream
--[[*
 * Create a copy of the given vector.
 *
 * @param {vec2} out - receiving vector
 * @param {vec2} vector - source vector
 * @returns {vec2} out
 * @alias module:modeling/maths/vec2.copy
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
	return out
end
return copy
