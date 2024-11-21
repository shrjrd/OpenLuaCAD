-- ROBLOX NOTE: no upstream
local vec2 = require("../vec2")
local copy = require("./copy")
local fromValues = require("./fromValues")
--[[*
 * Create a new line in the opposite direction as the given.
 *
 * @param {line2} out - receiving line
 * @param {line2} line - line to reverse
 * @returns {line2} out
 * @alias module:modeling/maths/line2.reverse
 ]]
local function reverse(out, line)
	local normal = vec2.negate(vec2.create(), line)
	local distance = -line[
		3 --[[ ROBLOX adaptation: added 1 to array index ]]
	]
	return copy(
		out,
		fromValues(
			normal[
				1 --[[ ROBLOX adaptation: added 1 to array index ]]
			],
			normal[
				2 --[[ ROBLOX adaptation: added 1 to array index ]]
			],
			distance
		)
	)
end
return reverse
