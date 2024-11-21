-- ROBLOX NOTE: no upstream
local vec2 = require("../vec2")
--[[*
 * Return the direction of the given line.
 *
 * @param {line2} line - line of reference
 * @return {vec2} a vector in the direction of the line
 * @alias module:modeling/maths/line2.direction
 ]]
local function direction(line)
	local vector = vec2.normal(vec2.create(), line)
	vec2.negate(vector, vector)
	return vector
end
return direction
