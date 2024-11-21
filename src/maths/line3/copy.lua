-- ROBLOX NOTE: no upstream
local vec3 = require("../vec3")
--[[*
 * Copy the given line into the receiving line.
 *
 * @param {line3} out - receiving line
 * @param {line3} line - line to copy
 * @returns {line3} out
 * @alias module:modeling/maths/line3.copy
 ]]
local function copy(out, line)
	vec3.copy(
		out[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		],
		line[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		]
	)
	vec3.copy(
		out[
			2 --[[ ROBLOX adaptation: added 1 to array index ]]
		],
		line[
			2 --[[ ROBLOX adaptation: added 1 to array index ]]
		]
	)
	return out
end
return copy
