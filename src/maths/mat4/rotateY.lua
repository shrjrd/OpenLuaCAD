-- ROBLOX NOTE: no upstream
local sin, cos
do
	local ref = require("../utils/trigonometry")
	sin, cos = ref.sin, ref.cos
end
--[[*
 * Rotates a matrix by the given angle around the Y axis.
 *
 * @param {mat4} out - receiving matrix
 * @param {mat4} matrix - matrix to rotate
 * @param {Number} radians - angle to rotate the matrix by
 * @returns {mat4} out
 * @alias module:modeling/maths/mat4.rotateY
 ]]
local function rotateY(out, matrix, radians)
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
	] = a00 * c - a20 * s
	out[
		2 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = a01 * c - a21 * s
	out[
		3 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = a02 * c - a22 * s
	out[
		4 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = a03 * c - a23 * s
	out[
		9 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = a00 * s + a20 * c
	out[
		10 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = a01 * s + a21 * c
	out[
		11 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = a02 * s + a22 * c
	out[
		12 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = a03 * s + a23 * c
	return out
end
return rotateY
