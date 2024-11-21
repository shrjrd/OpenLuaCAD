-- ROBLOX NOTE: no upstream
local angleRadians = require("./angleRadians")
--[[*
 * Calculate the angle of the given vector.
 *
 * @param {vec2} vector - vector of reference
 * @returns {Number} angle in degrees
 * @alias module:modeling/maths/vec2.angleDegrees
 ]]
local function angleDegrees(vector)
	return angleRadians(vector) * 57.29577951308232
end
return angleDegrees
