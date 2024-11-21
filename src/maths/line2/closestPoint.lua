-- ROBLOX NOTE: no upstream
local vec2 = require("../vec2")
local direction = require("./direction")
local origin = require("./origin")
--[[*
 * Determine the closest point on the given line to the given point.
 *
 * @param {line2} line - line of reference
 * @param {vec2} point - point of reference
 * @returns {vec2} closest point
 * @alias module:modeling/maths/line2.closestPoint
 ]]
local function closestPoint(line, point)
	local orig = origin(line)
	local dir = direction(line)
	local v = vec2.subtract(vec2.create(), point, orig)
	local dist = vec2.dot(v, dir)
	vec2.scale(v, dir, dist)
	vec2.add(v, v, orig)
	return v
end
return closestPoint
