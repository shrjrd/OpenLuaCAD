-- ROBLOX NOTE: no upstream
local vec2 = require("../vec2")
--[[*
 * Calculate the distance (positive) between the given point and line.
 *
 * @param {line2} line - line of reference
 * @param {vec2} point - point of reference
 * @return {Number} distance between line and point
 * @alias module:modeling/maths/line2.distanceToPoint
 ]]
local function distanceToPoint(line, point)
	local distance = vec2.dot(point, line)
	distance = math.abs(distance - line[
		3 --[[ ROBLOX adaptation: added 1 to array index ]]
	])
	return distance
end
return distanceToPoint
