-- ROBLOX NOTE: no upstream
local vec3 = require("../vec3")
local create = require("./create")
--[[*
 * Create a clone of the given line.
 *
 * @param {line3} line - line to clone
 * @returns {line3} a new unbounded line
 * @alias module:modeling/maths/line3.clone
 ]]
local function clone(line)
	local out = create()
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
return clone
