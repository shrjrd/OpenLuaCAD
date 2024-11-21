-- ROBLOX NOTE: no upstream
local create = require("./create")
--[[*
 * Creates a new vector with the given values.
 *
 * @param {Number} x - X component
 * @param {Number} y - Y component
 * @param {Number} z - Z component
 * @param {Number} w - W component
 * @returns {vec4} a new vector
 * @alias module:modeling/maths/vec4.fromValues
 ]]
local function fromValues(x, y, z, w)
	local out = create()
	out[
		1 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = x
	out[
		2 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = y
	out[
		3 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = z
	out[
		4 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = w
	return out
end
return fromValues
