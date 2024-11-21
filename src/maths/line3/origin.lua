-- ROBLOX NOTE: no upstream
--[[*
 * Return the origin of the given line.
 *
 * @param {line3} line - line of reference
 * @return {vec3} the origin of the line
 * @alias module:modeling/maths/line3.origin
 ]]
local function origin(line)
	return line[
		1 --[[ ROBLOX adaptation: added 1 to array index ]]
	]
end
return origin
