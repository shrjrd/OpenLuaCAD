-- ROBLOX NOTE: no upstream
--[[*
 * Create a new vector by extending a 2D vector with a Z value.
 *
 * @param {vec3} out - receiving vector
 * @param {Array} vector - 2D vector of values
 * @param {Number} [z=0] - Z value
 * @returns {vec3} out
 * @alias module:modeling/maths/vec3.fromVec2
 ]]
local function fromVector2(out, vector, z_: number?)
	local z: number = if z_ ~= nil then z_ else 0
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
	] = z
	return out
end
return fromVector2
