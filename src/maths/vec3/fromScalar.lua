-- ROBLOX NOTE: no upstream
--[[*
 * Creates a vector from a single scalar value.
 * All components of the resulting vector have the given value.
 *
 * @param {vec3} out - receiving vector
 * @param {Number} scalar
 * @returns {vec3} out
 * @alias module:modeling/maths/vec3.fromScalar
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
	return out
end
return fromScalar
