-- ROBLOX NOTE: no upstream
--[[*
 * Convert the given vector to a representative string.
 * @param {vec3} vec - vector of reference
 * @returns {String} string representation
 * @alias module:modeling/maths/vec3.toString
 ]]
local function toString(vec)
	return ("[%s, %s, %s]"):format(
		tostring(vec[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		]:toFixed(7)),
		tostring(vec[
			2 --[[ ROBLOX adaptation: added 1 to array index ]]
		]:toFixed(7)),
		tostring(vec[
			3 --[[ ROBLOX adaptation: added 1 to array index ]]
		]:toFixed(7))
	)
end
return toString
