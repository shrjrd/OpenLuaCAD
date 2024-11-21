-- ROBLOX NOTE: no upstream
--[[*
 * Return the direction of the given line.
 *
 * @param {line3} line - line for reference
 * @return {vec3} the relative vector in the direction of the line
 * @alias module:modeling/maths/line3.direction
 ]]
local function direction(line)
	return line[
		2 --[[ ROBLOX adaptation: added 1 to array index ]]
	]
end
return direction
