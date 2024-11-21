-- ROBLOX NOTE: no upstream
--[[*
 * Create a vector from a single scalar value.
 *
 * @param {vec2} out - receiving vector
 * @param {Number} scalar - the scalar value
 * @returns {vec2} out
 * @alias module:modeling/maths/vec2.fromScalar
 ]]
local function fromScalar(out, scalar)
	out[
		1 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = scalar
	out[
		2 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = scalar
	return out
end
return fromScalar
