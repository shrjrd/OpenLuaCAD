-- ROBLOX NOTE: no upstream
local sin, cos
do
	local ref = require("../utils/trigonometry")
	sin, cos = ref.sin, ref.cos
end
--[[*
 * Create a new vector in the direction of the given angle.
 *
 * @param {vec2} out - receiving vector
 * @param {Number} radians - angle in radians
 * @returns {vec2} out
 * @alias module:modeling/maths/vec2.fromAngleRadians
 ]]
local function fromAngleRadians(out, radians)
	out[
		1 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = cos(radians)
	out[
		2 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = sin(radians)
	return out
end
return fromAngleRadians
