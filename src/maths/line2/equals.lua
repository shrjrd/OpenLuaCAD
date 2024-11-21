-- ROBLOX NOTE: no upstream
--[[*
 * Compare the given lines for equality.
 *
 * @param {line2} line1 - first line to compare
 * @param {line2} line2 - second line to compare
 * @return {Boolean} true if lines are equal
 * @alias module:modeling/maths/line2.equals
 ]]
local function equals(line1, line2)
	return line1[
		1 --[[ ROBLOX adaptation: added 1 to array index ]]
	] == line2[
		1 --[[ ROBLOX adaptation: added 1 to array index ]]
	] and line1[
		2 --[[ ROBLOX adaptation: added 1 to array index ]]
	] == line2[
		2 --[[ ROBLOX adaptation: added 1 to array index ]]
	] and line1[
		3 --[[ ROBLOX adaptation: added 1 to array index ]]
	] == line2[
		3 --[[ ROBLOX adaptation: added 1 to array index ]]
	]
end
return equals
