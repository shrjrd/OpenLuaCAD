-- ROBLOX NOTE: no upstream
local vec3 = require("../vec3")
--[[*
 * Determine the closest point on the given line to the given point.
 *
 * @param {line3} line - line of reference
 * @param {vec3} point - point of reference
 * @returns {vec3} a point
 * @alias module:modeling/maths/line3.closestPoint
 ]]
local function closestPoint(line, point)
	local lpoint = line[
		1 --[[ ROBLOX adaptation: added 1 to array index ]]
	]
	local ldirection = line[
		2 --[[ ROBLOX adaptation: added 1 to array index ]]
	]
	local a = vec3.dot(vec3.subtract(vec3.create(), point, lpoint), ldirection)
	local b = vec3.dot(ldirection, ldirection)
	local t = a / b
	local closestpoint = vec3.scale(vec3.create(), ldirection, t)
	vec3.add(closestpoint, closestpoint, lpoint)
	return closestpoint
end
return closestPoint
