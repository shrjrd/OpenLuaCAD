-- ROBLOX NOTE: no upstream
local vec2 = require("../vec2")
local solve2Linear = require("../utils").solve2Linear
--[[*
 * Return the point of intersection between the given lines.
 *
 * NOTES:
 * The point will have Infinity values if the lines are parallel.
 * The point will have NaN values if the lines are the same.
 *
 * @param {line2} line1 - line of reference
 * @param {line2} line2 - line of reference
 * @return {vec2} the point of intersection
 * @alias module:modeling/maths/line2.intersectPointOfLines
 ]]
local function intersectToLine(line1, line2)
	local point = solve2Linear(
		line1[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		],
		line1[
			2 --[[ ROBLOX adaptation: added 1 to array index ]]
		],
		line2[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		],
		line2[
			2 --[[ ROBLOX adaptation: added 1 to array index ]]
		],
		line1[
			3 --[[ ROBLOX adaptation: added 1 to array index ]]
		],
		line2[
			3 --[[ ROBLOX adaptation: added 1 to array index ]]
		]
	)
	return vec2.clone(point)
end
return intersectToLine
