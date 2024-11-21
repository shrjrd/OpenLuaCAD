-- ROBLOX NOTE: no upstream
--[[*
 * Convert the given vector to a representative string.
 *
 * @param {vec2} vector - vector of reference
 * @returns {String} string representation
 * @alias module:modeling/maths/vec2.toString
 ]]
local function toString(vector)
	return ("[%s, %s]"):format(
		tostring(vector[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		]:toFixed(7)),
		tostring(vector[
			2 --[[ ROBLOX adaptation: added 1 to array index ]]
		]:toFixed(7))
	)
end
return toString
