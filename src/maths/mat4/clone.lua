-- ROBLOX NOTE: no upstream
local create = require("./create")
--[[*
 * Creates a clone of the given matrix.
 *
 * @param {mat4} matrix - matrix to clone
 * @returns {mat4} a new matrix
 * @alias module:modeling/maths/mat4.clone
 ]]
local function clone(matrix)
	local out = create()
	out[
		1 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = matrix[
		1 --[[ ROBLOX adaptation: added 1 to array index ]]
	]
	out[
		2 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = matrix[
		2 --[[ ROBLOX adaptation: added 1 to array index ]]
	]
	out[
		3 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = matrix[
		3 --[[ ROBLOX adaptation: added 1 to array index ]]
	]
	out[
		4 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = matrix[
		4 --[[ ROBLOX adaptation: added 1 to array index ]]
	]
	out[
		5 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = matrix[
		5 --[[ ROBLOX adaptation: added 1 to array index ]]
	]
	out[
		6 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = matrix[
		6 --[[ ROBLOX adaptation: added 1 to array index ]]
	]
	out[
		7 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = matrix[
		7 --[[ ROBLOX adaptation: added 1 to array index ]]
	]
	out[
		8 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = matrix[
		8 --[[ ROBLOX adaptation: added 1 to array index ]]
	]
	out[
		9 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = matrix[
		9 --[[ ROBLOX adaptation: added 1 to array index ]]
	]
	out[
		10 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = matrix[
		10 --[[ ROBLOX adaptation: added 1 to array index ]]
	]
	out[
		11 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = matrix[
		11 --[[ ROBLOX adaptation: added 1 to array index ]]
	]
	out[
		12 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = matrix[
		12 --[[ ROBLOX adaptation: added 1 to array index ]]
	]
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
return clone
