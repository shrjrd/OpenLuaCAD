-- ROBLOX NOTE: no upstream
--[[*
 * Create a new vector from the given scalar value.
 *
 * @param {vec4} out - receiving vector
 * @param  {Number} scalar
 * @returns {vec4} out
 * @alias module:modeling/maths/vec4.fromScalar
 ]]
local function fromScalar(out, scalar)
	out[
		1 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = scalar
	out[
		2 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = scalar
	out[
		3 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = scalar
	out[
		4 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = scalar
	return out
end
return fromScalar
