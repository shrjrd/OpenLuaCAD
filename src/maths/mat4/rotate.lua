-- ROBLOX NOTE: no upstream
local EPS = require("../constants").EPS
local sin, cos
do
	local ref = require("../utils/trigonometry")
	sin, cos = ref.sin, ref.cos
end
local copy = require("./copy")
--[[*
 * Rotates a matrix by the given angle about the given axis.
 *
 * @param {mat4} out - receiving matrix
 * @param {mat4} matrix - matrix to rotate
 * @param {Number} radians - angle to rotate the matrix by
 * @param {vec3} axis - axis to rotate around
 * @returns {mat4} out
 * @alias module:modeling/maths/mat4.rotate
 ]]
local function rotate(out, matrix, radians, axis)
	local x, y, z = table.unpack(axis, 1, 3)
	local lengthSquared = x * x + y * y + z * z
	if
		math.abs(lengthSquared)
		< EPS --[[ ROBLOX CHECK: operator '<' works only if either both arguments are strings or both are a number ]]
	then
		-- axis is 0,0,0 or almost
		return copy(out, matrix)
	end
	local len = 1 / math.sqrt(lengthSquared)
	x *= len
	y *= len
	z *= len
	local s = sin(radians)
	local c = cos(radians)
	local t = 1 - c
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
	] -- Construct the elements of the rotation matrix
	local b00 = x * x * t + c
	local b01 = y * x * t + z * s
	local b02 = z * x * t - y * s
	local b10 = x * y * t - z * s
	local b11 = y * y * t + c
	local b12 = z * y * t + x * s
	local b20 = x * z * t + y * s
	local b21 = y * z * t - x * s
	local b22 = z * z * t + c -- Perform rotation-specific matrix multiplication
	out[
		1 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = a00 * b00 + a10 * b01 + a20 * b02
	out[
		2 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = a01 * b00 + a11 * b01 + a21 * b02
	out[
		3 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = a02 * b00 + a12 * b01 + a22 * b02
	out[
		4 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = a03 * b00 + a13 * b01 + a23 * b02
	out[
		5 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = a00 * b10 + a10 * b11 + a20 * b12
	out[
		6 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = a01 * b10 + a11 * b11 + a21 * b12
	out[
		7 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = a02 * b10 + a12 * b11 + a22 * b12
	out[
		8 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = a03 * b10 + a13 * b11 + a23 * b12
	out[
		9 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = a00 * b20 + a10 * b21 + a20 * b22
	out[
		10 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = a01 * b20 + a11 * b21 + a21 * b22
	out[
		11 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = a02 * b20 + a12 * b21 + a22 * b22
	out[
		12 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = a03 * b20 + a13 * b21 + a23 * b22
	if matrix ~= out then
		-- If the source and destination differ, copy the unchanged last row
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
	end
	return out
end
return rotate
