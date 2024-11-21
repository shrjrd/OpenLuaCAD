-- ROBLOX NOTE: no upstream
--[[*
 * Returns whether or not the matrices have exactly the same elements in the same position.
 *
 * @param {mat4} a - first matrix
 * @param {mat4} b - second matrix
 * @returns {Boolean} true if the matrices are equal
 * @alias module:modeling/maths/mat4.equals
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
	] and a[
		5 --[[ ROBLOX adaptation: added 1 to array index ]]
	] == b[
		5 --[[ ROBLOX adaptation: added 1 to array index ]]
	] and a[
		6 --[[ ROBLOX adaptation: added 1 to array index ]]
	] == b[
		6 --[[ ROBLOX adaptation: added 1 to array index ]]
	] and a[
		7 --[[ ROBLOX adaptation: added 1 to array index ]]
	] == b[
		7 --[[ ROBLOX adaptation: added 1 to array index ]]
	] and a[
		8 --[[ ROBLOX adaptation: added 1 to array index ]]
	] == b[
		8 --[[ ROBLOX adaptation: added 1 to array index ]]
	] and a[
		9 --[[ ROBLOX adaptation: added 1 to array index ]]
	] == b[
		9 --[[ ROBLOX adaptation: added 1 to array index ]]
	] and a[
		10 --[[ ROBLOX adaptation: added 1 to array index ]]
	] == b[
		10 --[[ ROBLOX adaptation: added 1 to array index ]]
	] and a[
		11 --[[ ROBLOX adaptation: added 1 to array index ]]
	] == b[
		11 --[[ ROBLOX adaptation: added 1 to array index ]]
	] and a[
		12 --[[ ROBLOX adaptation: added 1 to array index ]]
	] == b[
		12 --[[ ROBLOX adaptation: added 1 to array index ]]
	] and a[
		13 --[[ ROBLOX adaptation: added 1 to array index ]]
	] == b[
		13 --[[ ROBLOX adaptation: added 1 to array index ]]
	] and a[
		14 --[[ ROBLOX adaptation: added 1 to array index ]]
	] == b[
		14 --[[ ROBLOX adaptation: added 1 to array index ]]
	] and a[
		15 --[[ ROBLOX adaptation: added 1 to array index ]]
	] == b[
		15 --[[ ROBLOX adaptation: added 1 to array index ]]
	] and a[
		16 --[[ ROBLOX adaptation: added 1 to array index ]]
	] == b[
		16 --[[ ROBLOX adaptation: added 1 to array index ]]
	]
end
return equals
