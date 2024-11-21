-- ROBLOX NOTE: no upstream
local create = require("./create")
--[[*
 * Create a clone of the given line.
 *
 * @param {line2} line - line to clone
 * @returns {line2} a new unbounded line
 * @alias module:modeling/maths/line2.clone
 ]]
local function clone(line)
	local out = create()
	out[
		1 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = line[
		1 --[[ ROBLOX adaptation: added 1 to array index ]]
	]
	out[
		2 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = line[
		2 --[[ ROBLOX adaptation: added 1 to array index ]]
	]
	out[
		3 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = line[
		3 --[[ ROBLOX adaptation: added 1 to array index ]]
	]
	return out
end
return clone
