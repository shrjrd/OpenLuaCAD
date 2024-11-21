-- ROBLOX NOTE: no upstream
--[[*
 * Compare the given vectors for equality.
 *
 * @param {vec2} a - first operand
 * @param {vec2} b - second operand
 * @returns {Boolean} true if a and b are equal
 * @alias module:modeling/maths/vec2.equals
 ]]
local function equals(a, b)
	return a[
		1 --[[ ROBLOX adaptation: added 1 to array index ]]
	] == b[
		1 --[[ ROBLOX adaptation: added 1 to array index ]]
	] and a[
		2 --[[ ROBLOX adaptation: added 1 to array index ]]
	] == b[
		2 --[[ ROBLOX adaptation: added 1 to array index ]]
	]
end
return equals
