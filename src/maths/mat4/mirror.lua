-- ROBLOX NOTE: no upstream
--[[
 * m the mat4 by the dimensions in the given vec3
 * create an affine matrix for mirroring into an arbitrary plane.
 *
 * @param {mat4} out - the receiving matrix
 * @param {vec3} vector - the vec3 to mirror the matrix by
 * @param {mat4} matrix - the matrix to mirror
 * @returns {mat4} out
 ]]
local function mirror(out, vector, matrix)
	local x = vector[
		1 --[[ ROBLOX adaptation: added 1 to array index ]]
	]
	local y = vector[
		2 --[[ ROBLOX adaptation: added 1 to array index ]]
	]
	local z = vector[
		3 --[[ ROBLOX adaptation: added 1 to array index ]]
	]
	out[
		1 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = matrix[
		1 --[[ ROBLOX adaptation: added 1 to array index ]]
	] * x
	out[
		2 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = matrix[
		2 --[[ ROBLOX adaptation: added 1 to array index ]]
	] * x
	out[
		3 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = matrix[
		3 --[[ ROBLOX adaptation: added 1 to array index ]]
	] * x
	out[
		4 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = matrix[
		4 --[[ ROBLOX adaptation: added 1 to array index ]]
	] * x
	out[
		5 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = matrix[
		5 --[[ ROBLOX adaptation: added 1 to array index ]]
	] * y
	out[
		6 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = matrix[
		6 --[[ ROBLOX adaptation: added 1 to array index ]]
	] * y
	out[
		7 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = matrix[
		7 --[[ ROBLOX adaptation: added 1 to array index ]]
	] * y
	out[
		8 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = matrix[
		8 --[[ ROBLOX adaptation: added 1 to array index ]]
	] * y
	out[
		9 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = matrix[
		9 --[[ ROBLOX adaptation: added 1 to array index ]]
	] * z
	out[
		10 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = matrix[
		10 --[[ ROBLOX adaptation: added 1 to array index ]]
	] * z
	out[
		11 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = matrix[
		11 --[[ ROBLOX adaptation: added 1 to array index ]]
	] * z
	out[
		12 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = matrix[
		12 --[[ ROBLOX adaptation: added 1 to array index ]]
	] * z
	out[
		13 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = matrix[
		13 --[[ ROBLOX adaptation: added 1 to array index ]]
	]
	out[
		14 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = matrix[
		14 --[[ ROBLOX adaptation: added 1 to array index ]]
	]
	out[
		15 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = matrix[
		15 --[[ ROBLOX adaptation: added 1 to array index ]]
	]
	out[
		16 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = matrix[
		16 --[[ ROBLOX adaptation: added 1 to array index ]]
	]
	return out
end
return mirror
