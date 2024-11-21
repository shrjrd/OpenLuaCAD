-- ROBLOX NOTE: no upstream
--[[*
 * Compare the given vectors for equality.
 *
 * @param {vec4} a - first vector
 * @param {vec4} b - second vector
 * @return {Boolean} true if vectors are equal
 * @alias module:modeling/maths/vec4.equals
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
	] and a[
		4 --[[ ROBLOX adaptation: added 1 to array index ]]
	] == b[
		4 --[[ ROBLOX adaptation: added 1 to array index ]]
	]
end
return equals
