-- ROBLOX NOTE: no upstream
local create = require("./create")
--[[*
 * Create a matrix with the given values.
 *
 * @param {Number} m00 Component in column 0, row 0 position (index 0)
 * @param {Number} m01 Component in column 0, row 1 position (index 1)
 * @param {Number} m02 Component in column 0, row 2 position (index 2)
 * @param {Number} m03 Component in column 0, row 3 position (index 3)
 * @param {Number} m10 Component in column 1, row 0 position (index 4)
 * @param {Number} m11 Component in column 1, row 1 position (index 5)
 * @param {Number} m12 Component in column 1, row 2 position (index 6)
 * @param {Number} m13 Component in column 1, row 3 position (index 7)
 * @param {Number} m20 Component in column 2, row 0 position (index 8)
 * @param {Number} m21 Component in column 2, row 1 position (index 9)
 * @param {Number} m22 Component in column 2, row 2 position (index 10)
 * @param {Number} m23 Component in column 2, row 3 position (index 11)
 * @param {Number} m30 Component in column 3, row 0 position (index 12)
 * @param {Number} m31 Component in column 3, row 1 position (index 13)
 * @param {Number} m32 Component in column 3, row 2 position (index 14)
 * @param {Number} m33 Component in column 3, row 3 position (index 15)
 * @returns {mat4} a new matrix
 * @alias module:modeling/maths/mat4.fromValues
 * @example
 * let matrix = fromValues(
 *   1, 0, 0, 1,
 *   0, 1, 0, 0,
 *   0, 0, 1, 0,
 *   0, 0, 0, 1
 * )
 ]]
local function fromValues(m00, m01, m02, m03, m10, m11, m12, m13, m20, m21, m22, m23, m30, m31, m32, m33)
	local out = create()
	out[
		1 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = m00
	out[
		2 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = m01
	out[
		3 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = m02
	out[
		4 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = m03
	out[
		5 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = m10
	out[
		6 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = m11
	out[
		7 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = m12
	out[
		8 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = m13
	out[
		9 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = m20
	out[
		10 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = m21
	out[
		11 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = m22
	out[
		12 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = m23
	out[
		13 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = m30
	out[
		14 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = m31
	out[
		15 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = m32
	out[
		16 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = m33
	return out
end
return fromValues
