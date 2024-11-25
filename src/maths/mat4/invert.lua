-- ROBLOX NOTE: no upstream

local LuauPolyfill = require("@Packages/LuauPolyfill")
local Boolean = LuauPolyfill.Boolean
--[[*
 * Creates a invert copy of the given matrix.
 * @author Julian Lloyd
 * code from https://github.com/jlmakes/rematrix/blob/master/src/index.js
 *
 * @param {mat4} out - receiving matrix
 * @param {mat4} matrix - matrix to invert
 * @returns {mat4} out
 * @alias module:modeling/maths/mat4.invert
 ]]
local function invert(out, matrix)
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
	]
	local a30 = matrix[
		13 --[[ ROBLOX adaptation: added 1 to array index ]]
	]
	local a31 = matrix[
		14 --[[ ROBLOX adaptation: added 1 to array index ]]
	]
	local a32 = matrix[
		15 --[[ ROBLOX adaptation: added 1 to array index ]]
	]
	local a33 = matrix[
		16 --[[ ROBLOX adaptation: added 1 to array index ]]
	]
	local b00 = a00 * a11 - a01 * a10
	local b01 = a00 * a12 - a02 * a10
	local b02 = a00 * a13 - a03 * a10
	local b03 = a01 * a12 - a02 * a11
	local b04 = a01 * a13 - a03 * a11
	local b05 = a02 * a13 - a03 * a12
	local b06 = a20 * a31 - a21 * a30
	local b07 = a20 * a32 - a22 * a30
	local b08 = a20 * a33 - a23 * a30
	local b09 = a21 * a32 - a22 * a31
	local b10 = a21 * a33 - a23 * a31
	local b11 = a22 * a33 - a23 * a32 -- Calculate the determinant
	local det = b00 * b11 - b01 * b10 + b02 * b09 + b03 * b08 - b04 * b07 + b05 * b06
	if not Boolean.toJSBoolean(det) then
		return nil
	end
	det = 1.0 / det
	out[
		1 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = (a11 * b11 - a12 * b10 + a13 * b09) * det
	out[
		2 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = (a02 * b10 - a01 * b11 - a03 * b09) * det
	out[
		3 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = (a31 * b05 - a32 * b04 + a33 * b03) * det
	out[
		4 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = (a22 * b04 - a21 * b05 - a23 * b03) * det
	out[
		5 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = (a12 * b08 - a10 * b11 - a13 * b07) * det
	out[
		6 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = (a00 * b11 - a02 * b08 + a03 * b07) * det
	out[
		7 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = (a32 * b02 - a30 * b05 - a33 * b01) * det
	out[
		8 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = (a20 * b05 - a22 * b02 + a23 * b01) * det
	out[
		9 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = (a10 * b10 - a11 * b08 + a13 * b06) * det
	out[
		10 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = (a01 * b08 - a00 * b10 - a03 * b06) * det
	out[
		11 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = (a30 * b04 - a31 * b02 + a33 * b00) * det
	out[
		12 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = (a21 * b02 - a20 * b04 - a23 * b00) * det
	out[
		13 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = (a11 * b07 - a10 * b09 - a12 * b06) * det
	out[
		14 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = (a00 * b09 - a01 * b07 + a02 * b06) * det
	out[
		15 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = (a31 * b01 - a30 * b03 - a32 * b00) * det
	out[
		16 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = (a20 * b03 - a21 * b01 + a22 * b00) * det
	return out
end
return invert
