-- ROBLOX NOTE: no upstream
--[[*
 * Compare the given vectors for equality.
 *
 * @param {vec3} a - first operand
 * @param {vec3} b - second operand
 * @returns {Boolean} true if a and b are equal
 * @alias module:modeling/maths/vec3.equals
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
	] and a[
		3 --[[ ROBLOX adaptation: added 1 to array index ]]
	] == b[
		3 --[[ ROBLOX adaptation: added 1 to array index ]]
	]
end
return equals
