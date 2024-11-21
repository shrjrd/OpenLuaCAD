-- ROBLOX NOTE: no upstream
local vec3 = require("../vec3")
--[[*
 * Calculate the distance to the given point.
 *
 * @param {plane} plane - plane of reference
 * @param {vec3} point - point of reference
 * @return {Number} signed distance to point
 * @alias module:modeling/maths/plane.signedDistanceToPoint
 ]]
local function signedDistanceToPoint(plane, point)
	return vec3.dot(plane, point) - plane[
		4 --[[ ROBLOX adaptation: added 1 to array index ]]
	]
end
return signedDistanceToPoint
