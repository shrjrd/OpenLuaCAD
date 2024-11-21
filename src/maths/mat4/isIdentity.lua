-- ROBLOX NOTE: no upstream
--[[*
 * Determine whether the given matrix is the identity transform.
 * This is equivalent to (but much faster than):
 *
 *     mat4.equals(mat4.create(), matrix)
 *
 * @param {mat4} matrix - the matrix
 * @returns {Boolean} true if matrix is the identity transform
 * @alias module:modeling/maths/mat4.isIdentity
 * @example
 * if (mat4.isIdentity(mymatrix)) ...
 ]]
local function isIdentity(matrix)
	return matrix[
		1 --[[ ROBLOX adaptation: added 1 to array index ]]
	] == 1 and matrix[
		2 --[[ ROBLOX adaptation: added 1 to array index ]]
	] == 0 and matrix[
		3 --[[ ROBLOX adaptation: added 1 to array index ]]
	] == 0 and matrix[
		4 --[[ ROBLOX adaptation: added 1 to array index ]]
	] == 0 and matrix[
		5 --[[ ROBLOX adaptation: added 1 to array index ]]
	] == 0 and matrix[
		6 --[[ ROBLOX adaptation: added 1 to array index ]]
	] == 1 and matrix[
		7 --[[ ROBLOX adaptation: added 1 to array index ]]
	] == 0 and matrix[
		8 --[[ ROBLOX adaptation: added 1 to array index ]]
	] == 0 and matrix[
		9 --[[ ROBLOX adaptation: added 1 to array index ]]
	] == 0 and matrix[
		10 --[[ ROBLOX adaptation: added 1 to array index ]]
	] == 0 and matrix[
		11 --[[ ROBLOX adaptation: added 1 to array index ]]
	] == 1 and matrix[
		12 --[[ ROBLOX adaptation: added 1 to array index ]]
	] == 0 and matrix[
		13 --[[ ROBLOX adaptation: added 1 to array index ]]
	] == 0 and matrix[
		14 --[[ ROBLOX adaptation: added 1 to array index ]]
	] == 0 and matrix[
		15 --[[ ROBLOX adaptation: added 1 to array index ]]
	] == 0 and matrix[
		16 --[[ ROBLOX adaptation: added 1 to array index ]]
	] == 1
end
return isIdentity
