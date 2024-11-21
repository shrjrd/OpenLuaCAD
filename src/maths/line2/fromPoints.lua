-- ROBLOX NOTE: no upstream
local vec2 = require("../vec2")
--[[*
 * Create a new line that passes through the given points.
 *
 * @param {line2} out - receiving line
 * @param {vec2} point1 - start point of the line
 * @param {vec2} point2 - end point of the line
 * @returns {line2} a new unbounded line
 * @alias module:modeling/maths/line2.fromPoints
 ]]
local function fromPoints(out, point1, point2)
	local vector = vec2.subtract(vec2.create(), point2, point1) -- directional vector
	vec2.normal(vector, vector)
	vec2.normalize(vector, vector) -- normalized
	local distance = vec2.dot(point1, vector)
	out[
		1 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = vector[
		1 --[[ ROBLOX adaptation: added 1 to array index ]]
	]
	out[
		2 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = vector[
		2 --[[ ROBLOX adaptation: added 1 to array index ]]
	]
	out[
		3 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = distance
	return out
end
return fromPoints
