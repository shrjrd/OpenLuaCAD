-- ROBLOX NOTE: no upstream
local create = require("./create")
--[[*
 * Create a clone of the given vector.
 *
 * @param {vec4} vector - source vector
 * @returns {vec4} a new vector
 * @alias module:modeling/maths/vec4.clone
 ]]
local function clone(vector)
	local out = create()
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
	out[
		4 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = vector[
		4 --[[ ROBLOX adaptation: added 1 to array index ]]
	]
	return out
end
return clone
