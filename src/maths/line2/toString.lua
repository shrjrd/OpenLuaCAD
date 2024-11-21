-- ROBLOX NOTE: no upstream
--[[*
 * Return a string representing the given line.
 *
 * @param {line2} line - line of reference
 * @returns {String} string representation
 * @alias module:modeling/maths/line2.toString
 ]]
local function toString(line)
	return ("line2. (%s, %s, %s)"):format(
		tostring(line[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		]:toFixed(7)),
		tostring(line[
			2 --[[ ROBLOX adaptation: added 1 to array index ]]
		]:toFixed(7)),
		tostring(line[
			3 --[[ ROBLOX adaptation: added 1 to array index ]]
		]:toFixed(7))
	)
end
return toString
