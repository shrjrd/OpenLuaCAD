-- ROBLOX NOTE: no upstream
--[[*
 * Convert the given angle (degrees) to radians.
 * @param {Number} degrees - angle in degrees
 * @returns {Number} angle in radians
 * @alias module:modeling/utils.degToRad
 ]]
local function degToRad(degrees)
	return degrees * 0.017453292519943295
end
return degToRad
