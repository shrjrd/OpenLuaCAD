-- ROBLOX NOTE: no upstream
local vec2 = require("../vec2")
--[[*
 * Return the origin of the given line.
 * The origin is the point on the line which is closest to the origin [0, 0].
 *
 * @param {line2} line - line of reference
 * @return {vec2} the origin of the line
 * @alias module:modeling/maths/line2.origin
 ]]
local function origin(line)
	return vec2.scale(
		vec2.create(),
		line,
		line[
			3 --[[ ROBLOX adaptation: added 1 to array index ]]
		]
	)
end
return origin
