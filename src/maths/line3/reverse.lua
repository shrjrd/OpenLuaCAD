-- ROBLOX NOTE: no upstream
local vec3 = require("../vec3")
local fromPointAndDirection = require("./fromPointAndDirection")
--[[*
 * Create a line in the opposite direction as the given.
 *
 * @param {line3} out - receiving line
 * @param {line3} line - line to reverse
 * @returns {line3} out
 * @alias module:modeling/maths/line3.reverse
 ]]
local function reverse(out, line)
	local point = vec3.clone(line[
		1 --[[ ROBLOX adaptation: added 1 to array index ]]
	])
	local direction = vec3.negate(
		vec3.create(),
		line[
			2 --[[ ROBLOX adaptation: added 1 to array index ]]
		]
	)
	return fromPointAndDirection(out, point, direction)
end
return reverse
