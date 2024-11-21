-- ROBLOX NOTE: no upstream
--[[*
 * Convert the given vector to a representative string.
 *
 * @param {vec4} vec - vector to convert
 * @returns {String} representative string
 * @alias module:modeling/maths/vec4.toString
 ]]
local function toString(vec)
	return ("(%s, %s, %s, %s)"):format(
		tostring(vec[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		]:toFixed(9)),
		tostring(vec[
			2 --[[ ROBLOX adaptation: added 1 to array index ]]
		]:toFixed(9)),
		tostring(vec[
			3 --[[ ROBLOX adaptation: added 1 to array index ]]
		]:toFixed(9)),
		tostring(vec[
			4 --[[ ROBLOX adaptation: added 1 to array index ]]
		]:toFixed(9))
	)
end
return toString
