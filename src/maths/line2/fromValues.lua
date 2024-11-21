-- ROBLOX NOTE: no upstream
local create = require("./create")
--[[*
 * Creates a new line initialized with the given values.
 *
 * @param {Number} x - X coordinate of the unit normal
 * @param {Number} y - Y coordinate of the unit normal
 * @param {Number} d - distance of the line from [0,0]
 * @returns {line2} a new unbounded line
 * @alias module:modeling/maths/line2.fromValues
 ]]
local function fromValues(x, y, d)
	local out = create()
	out[
		1 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = x
	out[
		2 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = y
	out[
		3 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = d
	return out
end
return fromValues
