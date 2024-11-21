-- ROBLOX NOTE: no upstream
local sin, cos
do
	local ref = require("../utils/trigonometry")
	sin, cos = ref.sin, ref.cos
end
--[[*
 * Creates a matrix from the given Tait–Bryan angles.
 *
 * Tait-Bryan Euler angle convention using active, intrinsic rotations around the axes in the order z-y-x.
 * @see https://en.wikipedia.org/wiki/Euler_angles
 *
 * @param {mat4} out - receiving matrix
 * @param {Number} yaw - Z rotation in radians
 * @param {Number} pitch - Y rotation in radians
 * @param {Number} roll - X rotation in radians
 * @returns {mat4} out
 * @alias module:modeling/maths/mat4.fromTaitBryanRotation
 * @example
 * let matrix = fromTaitBryanRotation(create(), TAU / 4, 0, TAU / 2)
 ]]
local function fromTaitBryanRotation(out, yaw, pitch, roll)
	-- precompute sines and cosines of Euler angles
	local sy = sin(yaw)
	local cy = cos(yaw)
	local sp = sin(pitch)
	local cp = cos(pitch)
	local sr = sin(roll)
	local cr = cos(roll) -- create and populate rotation matrix
	-- left-hand-rule rotation
	-- const els = [
	--  cp*cy, sr*sp*cy - cr*sy, sr*sy + cr*sp*cy, 0,
	--  cp*sy, cr*cy + sr*sp*sy, cr*sp*sy - sr*cy, 0,
	--  -sp, sr*cp, cr*cp, 0,
	--  0, 0, 0, 1
	-- ]
	-- right-hand-rule rotation
	out[
		1 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = cp * cy
	out[
		2 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = cp * sy
	out[
		3 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = -sp
	out[
		4 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = 0
	out[
		5 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = sr * sp * cy - cr * sy
	out[
		6 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = cr * cy + sr * sp * sy
	out[
		7 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = sr * cp
	out[
		8 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = 0
	out[
		9 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = sr * sy + cr * sp * cy
	out[
		10 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = cr * sp * sy - sr * cy
	out[
		11 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = cr * cp
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
return fromTaitBryanRotation
