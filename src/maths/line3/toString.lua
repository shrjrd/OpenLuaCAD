-- ROBLOX NOTE: no upstream
--[[*
 * Return a string representing the given line.
 *
 * @param {line3} line - line of reference
 * @returns {String} string representation
 * @alias module:modeling/maths/line3.toString
 ]]
local function toString(line)
	local point = line[
		1 --[[ ROBLOX adaptation: added 1 to array index ]]
	]
	local direction = line[
		2 --[[ ROBLOX adaptation: added 1 to array index ]]
	]
	return ("line3: point: (%s, %s, %s) direction: (%s, %s, %s)"):format(
		tostring(point[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		]:toFixed(7)),
		tostring(point[
			2 --[[ ROBLOX adaptation: added 1 to array index ]]
		]:toFixed(7)),
		tostring(point[
			3 --[[ ROBLOX adaptation: added 1 to array index ]]
		]:toFixed(7)),
		tostring(direction[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		]:toFixed(7)),
		tostring(direction[
			2 --[[ ROBLOX adaptation: added 1 to array index ]]
		]:toFixed(7)),
		tostring(direction[
			3 --[[ ROBLOX adaptation: added 1 to array index ]]
		]:toFixed(7))
	)
end
return toString
