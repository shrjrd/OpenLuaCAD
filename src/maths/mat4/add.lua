-- ROBLOX NOTE: no upstream
--[[*
 * Adds the two matrices (A+B).
 *
 * @param {mat4} out - receiving matrix
 * @param {mat4} a - first operand
 * @param {mat4} b - second operand
 * @returns {mat4} out
 * @alias module:modeling/maths/mat4.add
 ]]
local function add(out, a, b)
	out[
		1 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = a[
		1 --[[ ROBLOX adaptation: added 1 to array index ]]
	] + b[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		]
	out[
		2 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = a[
		2 --[[ ROBLOX adaptation: added 1 to array index ]]
	] + b[
			2 --[[ ROBLOX adaptation: added 1 to array index ]]
		]
	out[
		3 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = a[
		3 --[[ ROBLOX adaptation: added 1 to array index ]]
	] + b[
			3 --[[ ROBLOX adaptation: added 1 to array index ]]
		]
	out[
		4 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = a[
		4 --[[ ROBLOX adaptation: added 1 to array index ]]
	] + b[
			4 --[[ ROBLOX adaptation: added 1 to array index ]]
		]
	out[
		5 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = a[
		5 --[[ ROBLOX adaptation: added 1 to array index ]]
	] + b[
			5 --[[ ROBLOX adaptation: added 1 to array index ]]
		]
	out[
		6 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = a[
		6 --[[ ROBLOX adaptation: added 1 to array index ]]
	] + b[
			6 --[[ ROBLOX adaptation: added 1 to array index ]]
		]
	out[
		7 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = a[
		7 --[[ ROBLOX adaptation: added 1 to array index ]]
	] + b[
			7 --[[ ROBLOX adaptation: added 1 to array index ]]
		]
	out[
		8 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = a[
		8 --[[ ROBLOX adaptation: added 1 to array index ]]
	] + b[
			8 --[[ ROBLOX adaptation: added 1 to array index ]]
		]
	out[
		9 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = a[
		9 --[[ ROBLOX adaptation: added 1 to array index ]]
	] + b[
			9 --[[ ROBLOX adaptation: added 1 to array index ]]
		]
	out[
		10 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = a[
		10 --[[ ROBLOX adaptation: added 1 to array index ]]
	] + b[
			10 --[[ ROBLOX adaptation: added 1 to array index ]]
		]
	out[
		11 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = a[
		11 --[[ ROBLOX adaptation: added 1 to array index ]]
	] + b[
			11 --[[ ROBLOX adaptation: added 1 to array index ]]
		]
	out[
		12 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = a[
		12 --[[ ROBLOX adaptation: added 1 to array index ]]
	] + b[
			12 --[[ ROBLOX adaptation: added 1 to array index ]]
		]
	out[
		13 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = a[
		13 --[[ ROBLOX adaptation: added 1 to array index ]]
	] + b[
			13 --[[ ROBLOX adaptation: added 1 to array index ]]
		]
	out[
		14 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = a[
		14 --[[ ROBLOX adaptation: added 1 to array index ]]
	] + b[
			14 --[[ ROBLOX adaptation: added 1 to array index ]]
		]
	out[
		15 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = a[
		15 --[[ ROBLOX adaptation: added 1 to array index ]]
	] + b[
			15 --[[ ROBLOX adaptation: added 1 to array index ]]
		]
	out[
		16 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = a[
		16 --[[ ROBLOX adaptation: added 1 to array index ]]
	] + b[
			16 --[[ ROBLOX adaptation: added 1 to array index ]]
		]
	return out
end
return add
