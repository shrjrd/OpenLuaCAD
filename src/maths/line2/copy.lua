-- ROBLOX NOTE: no upstream
--[[*
 * Copy the given line to the receiving line.
 *
 * @param {line2} out - receiving line
 * @param {line2} line - line to copy
 * @returns {line2} out
 * @alias module:modeling/maths/line2.copy
 ]]
local function copy(out, line)
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
return copy
