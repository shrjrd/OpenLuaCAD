-- ROBLOX NOTE: no upstream
--[[*
 * Multiplies the two matrices.
 *
 * @param {mat4} out - receiving matrix
 * @param {mat4} a - first operand
 * @param {mat4} b - second operand
 * @returns {mat4} out
 * @alias module:modeling/maths/mat4.multiply
 ]]
local function multiply(out, a, b)
	local a00 = a[
		1 --[[ ROBLOX adaptation: added 1 to array index ]]
	]
	local a01 = a[
		2 --[[ ROBLOX adaptation: added 1 to array index ]]
	]
	local a02 = a[
		3 --[[ ROBLOX adaptation: added 1 to array index ]]
	]
	local a03 = a[
		4 --[[ ROBLOX adaptation: added 1 to array index ]]
	]
	local a10 = a[
		5 --[[ ROBLOX adaptation: added 1 to array index ]]
	]
	local a11 = a[
		6 --[[ ROBLOX adaptation: added 1 to array index ]]
	]
	local a12 = a[
		7 --[[ ROBLOX adaptation: added 1 to array index ]]
	]
	local a13 = a[
		8 --[[ ROBLOX adaptation: added 1 to array index ]]
	]
	local a20 = a[
		9 --[[ ROBLOX adaptation: added 1 to array index ]]
	]
	local a21 = a[
		10 --[[ ROBLOX adaptation: added 1 to array index ]]
	]
	local a22 = a[
		11 --[[ ROBLOX adaptation: added 1 to array index ]]
	]
	local a23 = a[
		12 --[[ ROBLOX adaptation: added 1 to array index ]]
	]
	local a30 = a[
		13 --[[ ROBLOX adaptation: added 1 to array index ]]
	]
	local a31 = a[
		14 --[[ ROBLOX adaptation: added 1 to array index ]]
	]
	local a32 = a[
		15 --[[ ROBLOX adaptation: added 1 to array index ]]
	]
	local a33 = a[
		16 --[[ ROBLOX adaptation: added 1 to array index ]]
	] -- Cache only the current line of the second matrix
	local b0 = b[
		1 --[[ ROBLOX adaptation: added 1 to array index ]]
	]
	local b1 = b[
		2 --[[ ROBLOX adaptation: added 1 to array index ]]
	]
	local b2 = b[
		3 --[[ ROBLOX adaptation: added 1 to array index ]]
	]
	local b3 = b[
		4 --[[ ROBLOX adaptation: added 1 to array index ]]
	]
	out[
		1 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = b0 * a00 + b1 * a10 + b2 * a20 + b3 * a30
	out[
		2 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = b0 * a01 + b1 * a11 + b2 * a21 + b3 * a31
	out[
		3 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = b0 * a02 + b1 * a12 + b2 * a22 + b3 * a32
	out[
		4 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = b0 * a03 + b1 * a13 + b2 * a23 + b3 * a33
	b0 = b[
		5 --[[ ROBLOX adaptation: added 1 to array index ]]
	]
	b1 = b[
		6 --[[ ROBLOX adaptation: added 1 to array index ]]
	]
	b2 = b[
		7 --[[ ROBLOX adaptation: added 1 to array index ]]
	]
	b3 = b[
		8 --[[ ROBLOX adaptation: added 1 to array index ]]
	]
	out[
		5 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = b0 * a00 + b1 * a10 + b2 * a20 + b3 * a30
	out[
		6 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = b0 * a01 + b1 * a11 + b2 * a21 + b3 * a31
	out[
		7 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = b0 * a02 + b1 * a12 + b2 * a22 + b3 * a32
	out[
		8 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = b0 * a03 + b1 * a13 + b2 * a23 + b3 * a33
	b0 = b[
		9 --[[ ROBLOX adaptation: added 1 to array index ]]
	]
	b1 = b[
		10 --[[ ROBLOX adaptation: added 1 to array index ]]
	]
	b2 = b[
		11 --[[ ROBLOX adaptation: added 1 to array index ]]
	]
	b3 = b[
		12 --[[ ROBLOX adaptation: added 1 to array index ]]
	]
	out[
		9 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = b0 * a00 + b1 * a10 + b2 * a20 + b3 * a30
	out[
		10 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = b0 * a01 + b1 * a11 + b2 * a21 + b3 * a31
	out[
		11 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = b0 * a02 + b1 * a12 + b2 * a22 + b3 * a32
	out[
		12 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = b0 * a03 + b1 * a13 + b2 * a23 + b3 * a33
	b0 = b[
		13 --[[ ROBLOX adaptation: added 1 to array index ]]
	]
	b1 = b[
		14 --[[ ROBLOX adaptation: added 1 to array index ]]
	]
	b2 = b[
		15 --[[ ROBLOX adaptation: added 1 to array index ]]
	]
	b3 = b[
		16 --[[ ROBLOX adaptation: added 1 to array index ]]
	]
	out[
		13 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = b0 * a00 + b1 * a10 + b2 * a20 + b3 * a30
	out[
		14 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = b0 * a01 + b1 * a11 + b2 * a21 + b3 * a31
	out[
		15 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = b0 * a02 + b1 * a12 + b2 * a22 + b3 * a32
	out[
		16 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = b0 * a03 + b1 * a13 + b2 * a23 + b3 * a33
	return out
end
return multiply
