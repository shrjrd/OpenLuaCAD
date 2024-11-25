-- ROBLOX NOTE: no upstream

local LuauPolyfill = require("@Packages/LuauPolyfill")
local Boolean = LuauPolyfill.Boolean
local vec3 = require("../vec3")
--[[*
 * Compare the given lines for equality.
 *
 * @param {line3} line1 - first line to compare
 * @param {line3} line2 - second line to compare
 * @return {Boolean} true if lines are equal
 * @alias module:modeling/maths/line3.equals
 ]]
local function equals(line1, line2)
	-- compare directions (unit vectors)
	if
		not Boolean.toJSBoolean(vec3.equals(
			line1[
				2 --[[ ROBLOX adaptation: added 1 to array index ]]
			],
			line2[
				2 --[[ ROBLOX adaptation: added 1 to array index ]]
			]
		))
	then
		return false
	end -- compare points
	if
		not Boolean.toJSBoolean(vec3.equals(
			line1[
				1 --[[ ROBLOX adaptation: added 1 to array index ]]
			],
			line2[
				1 --[[ ROBLOX adaptation: added 1 to array index ]]
			]
		))
	then
		return false
	end -- why would lines with the same slope (direction) and different points be equal?
	-- let distance = distanceToPoint(line1, line2[0])
	-- if (distance > EPS) return false
	return true
end
return equals
