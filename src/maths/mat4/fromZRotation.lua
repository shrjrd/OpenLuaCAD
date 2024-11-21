-- ROBLOX NOTE: no upstream
local sin, cos
do
	local ref = require("../utils/trigonometry")
	sin, cos = ref.sin, ref.cos
end
--[[*
 * Creates a matrix from the given angle around the Z axis.
 * This is equivalent to (but much faster than):
 *
 *     mat4.identity(dest)
 *     mat4.rotateZ(dest, dest, radians)
 *
 * @param {mat4} out - receiving matrix
 * @param {Number} radians - angle to rotate the matrix by
 * @returns {mat4} out
 * @alias module:modeling/maths/mat4.fromZRotation
 * @example
 * let matrix = fromZRotation(create(), TAU / 4)
 ]]
local function fromZRotation(out, radians)
	local s = sin(radians)
	local c = cos(radians) -- Perform axis-specific matrix multiplication
	out[
		1 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = c
	out[
		2 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = s
	out[
		3 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = 0
	out[
		4 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = 0
	out[
		5 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = -s
	out[
		6 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = c
	out[
		7 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = 0
	out[
		8 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = 0
	out[
		9 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = 0
	out[
		10 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = 0
	out[
		11 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = 1
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
return fromZRotation
