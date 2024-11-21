-- ROBLOX NOTE: no upstream
local vec3 = require("../vec3")
local closestPoint = require("./closestPoint")
--[[*
 * Calculate the distance (positive) between the given point and line.
 *
 * @param {line3} line - line of reference
 * @param {vec3} point - point of reference
 * @return {Number} distance between line and point
 * @alias module:modeling/maths/line3.distanceToPoint
 ]]
local function distanceToPoint(line, point)
	local closest = closestPoint(line, point)
	local distancevector = vec3.subtract(vec3.create(), point, closest)
	return vec3.length(distancevector)
end
return distanceToPoint
