-- ROBLOX NOTE: no upstream
local EPS = require("../constants").EPS
local sin, cos
do
	local ref = require("../utils/trigonometry")
	sin, cos = ref.sin, ref.cos
end
local identity = require("./identity")
--[[*
 * Creates a matrix from a given angle around a given axis
 * This is equivalent to (but much faster than):
 *
 *     mat4.identity(dest)
 *     mat4.rotate(dest, dest, rad, axis)
 *
 * @param {mat4} out - receiving matrix
 * @param {Number} rad - angle to rotate the matrix by
 * @param {vec3} axis - axis of which to rotate around
 * @returns {mat4} out
 * @alias module:modeling/maths/mat4.fromRotation
 * @example
 * let matrix = fromRotation(create(), TAU / 4, [0, 0, 3])
 ]]
local function fromRotation(out, rad, axis)
	local x, y, z = table.unpack(axis, 1, 3)
	local lengthSquared = x * x + y * y + z * z
	if
		math.abs(lengthSquared)
		< EPS --[[ ROBLOX CHECK: operator '<' works only if either both arguments are strings or both are a number ]]
	then
		-- axis is 0,0,0 or almost
		return identity(out)
	end
	local len = 1 / math.sqrt(lengthSquared)
	x *= len
	y *= len
	z *= len
	local s = sin(rad)
	local c = cos(rad)
	local t = 1 - c -- Perform rotation-specific matrix multiplication
	out[
		1 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = x * x * t + c
	out[
		2 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = y * x * t + z * s
	out[
		3 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = z * x * t - y * s
	out[
		4 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = 0
	out[
		5 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = x * y * t - z * s
	out[
		6 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = y * y * t + c
	out[
		7 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = z * y * t + x * s
	out[
		8 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = 0
	out[
		9 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = x * z * t + y * s
	out[
		10 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = y * z * t - x * s
	out[
		11 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = z * z * t + c
	out[
		12 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = 0
	out[
		13 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = 0
	out[
		14 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = 0
	out[
		15 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = 0
	out[
		16 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = 1
	return out
end
return fromRotation
