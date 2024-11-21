-- ROBLOX NOTE: no upstream
local create = require("./create")
--[[*
 * Creates a new vector initialized with the given values.
 *
 * @param {Number} x - X component
 * @param {Number} y - Y component
 * @param {Number} z - Z component
 * @returns {vec3} a new vector
 * @alias module:modeling/maths/vec3.fromValues
 ]]
local function fromValues(x, y, z)
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
	return out
end
return fromValues
