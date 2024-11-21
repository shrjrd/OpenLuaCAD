-- ROBLOX NOTE: no upstream
local TAU = require("../maths/constants").TAU
--[[*
 * Calculate the number of segments from the given radius based on minimum length or angle.
 * @param {Number} radius - radius of the requested shape
 * @param {Number} minimumLength - minimum length of segments; length > 0
 * @param {Number} minimumAngle - minimum angle (radians) between segments; 0 > angle < TAU
 * @returns {Number} number of segments to complete the radius
 * @alias module:modeling/utils.radiusToSegments
 ]]
local function radiusToSegments(radius, minimumLength, minimumAngle)
	local ss = if minimumLength
			> 0 --[[ ROBLOX CHECK: operator '>' works only if either both arguments are strings or both are a number ]]
		then radius * TAU / minimumLength
		else 0
	local as = if minimumAngle
			> 0 --[[ ROBLOX CHECK: operator '>' works only if either both arguments are strings or both are a number ]]
		then TAU / minimumAngle
		else 0 -- minimum segments is four(4) for round primitives
	return math.ceil(math.max(ss, as, 4))
end
return radiusToSegments
