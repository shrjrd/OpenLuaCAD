-- ROBLOX NOTE: no upstream
local vec3 = require("../vec3")
local fromPointAndDirection = require("./fromPointAndDirection")
--[[*
 * Transforms the given line using the given matrix.
 *
 * @param {line3} out - line to update
 * @param {line3} line - line to transform
 * @param {mat4} matrix - matrix to transform with
 * @returns {line3} a new unbounded line
 * @alias module:modeling/maths/line3.transform
 ]]
local function transform(out, line, matrix)
	local point = line[
		1 --[[ ROBLOX adaptation: added 1 to array index ]]
	]
	local direction = line[
		2 --[[ ROBLOX adaptation: added 1 to array index ]]
	]
	local pointPlusDirection = vec3.add(vec3.create(), point, direction)
	local newpoint = vec3.transform(vec3.create(), point, matrix)
	local newPointPlusDirection = vec3.transform(pointPlusDirection, pointPlusDirection, matrix)
	local newdirection = vec3.subtract(newPointPlusDirection, newPointPlusDirection, newpoint)
	return fromPointAndDirection(out, newpoint, newdirection)
end
return transform
