-- ROBLOX NOTE: no upstream
local sin, cos
do
	local ref = require("../utils/trigonometry")
	sin, cos = ref.sin, ref.cos
end
--[[*
 * Rotates a matrix by the given angle around the X axis.
 *
 * @param {mat4} out - receiving matrix
 * @param {mat4} matrix - matrix to rotate
 * @param {Number} radians - angle to rotate the matrix by
 * @returns {mat4} out
 * @alias module:modeling/maths/mat4.rotateX
 ]]
local function rotateX(out, matrix, radians)
	local s = sin(radians)
	local c = cos(radians)
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
	local a20 = matrix[
		9 --[[ ROBLOX adaptation: added 1 to array index ]]
	]
	local a21 = matrix[
		10 --[[ ROBLOX adaptation: added 1 to array index ]]
	]
	local a22 = matrix[
		11 --[[ ROBLOX adaptation: added 1 to array index ]]
	]
	local a23 = matrix[
		12 --[[ ROBLOX adaptation: added 1 to array index ]]
	]
	if matrix ~= out then
		-- If the source and destination differ, copy the unchanged rows
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
		5 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = a10 * c + a20 * s
	out[
		6 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = a11 * c + a21 * s
	out[
		7 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = a12 * c + a22 * s
	out[
		8 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = a13 * c + a23 * s
	out[
		9 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = a20 * c - a10 * s
	out[
		10 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = a21 * c - a11 * s
	out[
		11 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = a22 * c - a12 * s
	out[
		12 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = a23 * c - a13 * s
	return out
end
return rotateX
