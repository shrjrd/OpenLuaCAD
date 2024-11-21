-- ROBLOX NOTE: no upstream
--[[*
 * Convert the given angle (radians) to degrees.
 * @param {Number} radians - angle in radians
 * @returns {Number} angle in degrees
 * @alias module:modeling/utils.radToDeg
 ]]
local function radToDeg(radians)
	return radians * 57.29577951308232
end
return radToDeg
