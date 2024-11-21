-- ROBLOX NOTE: no upstream
local sin, cos
do
	local ref = require("../utils/trigonometry")
	sin, cos = ref.sin, ref.cos
end
--[[*
 * Rotates a matrix by the given angle around the Z axis.
 *
 * @param {mat4} out - receiving matrix
 * @param {mat4} matrix - matrix to rotate
 * @param {Number} radians - angle to rotate the matrix by
 * @returns {mat4} out
 * @alias module:modeling/maths/mat4.rotateZ
 ]]
local function rotateZ(out, matrix, radians)
	local s = sin(radians)
	local c = cos(radians)
	local a00 = matrix[
		1 --[[ ROBLOX adaptation: added 1 to array index ]]
	]
	local a01 = matrix[
		2 --[[ ROBLOX adaptation: added 1 to array index ]]
	]
	local a02 = matrix[
		3 --[[ ROBLOX adaptation: added 1 to array index ]]
	]
	local a03 = matrix[
		4 --[[ ROBLOX adaptation: added 1 to array index ]]
	]
	local a10 = matrix[
		5 --[[ ROBLOX adaptation: added 1 to array index ]]
	]
	local a11 = matrix[
		6 --[[ ROBLOX adaptation: added 1 to array index ]]
	]
	local a12 = matrix[
		7 --[[ ROBLOX adaptation: added 1 to array index ]]
	]
	local a13 = matrix[
		8 --[[ ROBLOX adaptation: added 1 to array index ]]
	]
	if matrix ~= out then
		-- If the source and destination differ, copy the unchanged last row
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
	end -- Perform axis-specific matrix multiplication
	out[
		1 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = a00 * c + a10 * s
	out[
		2 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = a01 * c + a11 * s
	out[
		3 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = a02 * c + a12 * s
	out[
		4 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = a03 * c + a13 * s
	out[
		5 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = a10 * c - a00 * s
	out[
		6 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = a11 * c - a01 * s
	out[
		7 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = a12 * c - a02 * s
	out[
		8 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = a13 * c - a03 * s
	return out
end
return rotateZ
