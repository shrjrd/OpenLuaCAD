-- ROBLOX NOTE: no upstream
local create = require("./create")
--[[*
 * Creates a new vector initialized with the given values.
 *
 * @param {Number} x - X coordinate
 * @param {Number} y - Y coordinate
 * @returns {vec2} a new vector
 * @alias module:modeling/maths/vec2.fromValues
 ]]
local function fromValues(x, y)
	local out = create()
	out[
		1 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = x
	out[
		2 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = y
	return out
end
return fromValues
