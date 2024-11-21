-- ROBLOX NOTE: no upstream
--[[*
 * Scales the matrix by the given dimensions.
 *
 * @param {mat4} out - receiving matrix
 * @param {mat4} matrix - matrix to scale
 * @param {vec3} dimensions - dimensions to scale the matrix by
 * @returns {mat4} out
 * @alias module:modeling/maths/mat4.scale
 ]]
local function scale(out, matrix, dimensions)
	local x = dimensions[
		1 --[[ ROBLOX adaptation: added 1 to array index ]]
	]
	local y = dimensions[
		2 --[[ ROBLOX adaptation: added 1 to array index ]]
	]
	local z = dimensions[
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
return scale
