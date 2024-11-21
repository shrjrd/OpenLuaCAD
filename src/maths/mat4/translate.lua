-- ROBLOX NOTE: no upstream
--[[*
 * Translate the matrix by the given offset vector.
 *
 * @param {mat4} out - receiving matrix
 * @param {mat4} matrix - matrix to translate
 * @param {vec3} offsets - offset vector to translate by
 * @returns {mat4} out
 * @alias module:modeling/maths/mat4.translate
 ]]
local function translate(out, matrix, offsets)
	local x = offsets[
		1 --[[ ROBLOX adaptation: added 1 to array index ]]
	]
	local y = offsets[
		2 --[[ ROBLOX adaptation: added 1 to array index ]]
	]
	local z = offsets[
		3 --[[ ROBLOX adaptation: added 1 to array index ]]
	]
	local a00
	local a01
	local a02
	local a03
	local a10
	local a11
	local a12
	local a13
	local a20
	local a21
	local a22
	local a23
	if matrix == out then
		-- 0-11 assignments are unnecessary
		out[
			13 --[[ ROBLOX adaptation: added 1 to array index ]]
		] = matrix[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		]
				* x
			+ matrix[
					5 --[[ ROBLOX adaptation: added 1 to array index ]]
				]
				* y
			+ matrix[
					9 --[[ ROBLOX adaptation: added 1 to array index ]]
				]
				* z
			+ matrix[
				13 --[[ ROBLOX adaptation: added 1 to array index ]]
			]
		out[
			14 --[[ ROBLOX adaptation: added 1 to array index ]]
		] = matrix[
			2 --[[ ROBLOX adaptation: added 1 to array index ]]
		]
				* x
			+ matrix[
					6 --[[ ROBLOX adaptation: added 1 to array index ]]
				]
				* y
			+ matrix[
					10 --[[ ROBLOX adaptation: added 1 to array index ]]
				]
				* z
			+ matrix[
				14 --[[ ROBLOX adaptation: added 1 to array index ]]
			]
		out[
			15 --[[ ROBLOX adaptation: added 1 to array index ]]
		] = matrix[
			3 --[[ ROBLOX adaptation: added 1 to array index ]]
		]
				* x
			+ matrix[
					7 --[[ ROBLOX adaptation: added 1 to array index ]]
				]
				* y
			+ matrix[
					11 --[[ ROBLOX adaptation: added 1 to array index ]]
				]
				* z
			+ matrix[
				15 --[[ ROBLOX adaptation: added 1 to array index ]]
			]
		out[
			16 --[[ ROBLOX adaptation: added 1 to array index ]]
		] = matrix[
			4 --[[ ROBLOX adaptation: added 1 to array index ]]
		]
				* x
			+ matrix[
					8 --[[ ROBLOX adaptation: added 1 to array index ]]
				]
				* y
			+ matrix[
					12 --[[ ROBLOX adaptation: added 1 to array index ]]
				]
				* z
			+ matrix[
				16 --[[ ROBLOX adaptation: added 1 to array index ]]
			]
	else
		a00 = matrix[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		]
		a01 = matrix[
			2 --[[ ROBLOX adaptation: added 1 to array index ]]
		]
		a02 = matrix[
			3 --[[ ROBLOX adaptation: added 1 to array index ]]
		]
		a03 = matrix[
			4 --[[ ROBLOX adaptation: added 1 to array index ]]
		]
		a10 = matrix[
			5 --[[ ROBLOX adaptation: added 1 to array index ]]
		]
		a11 = matrix[
			6 --[[ ROBLOX adaptation: added 1 to array index ]]
		]
		a12 = matrix[
			7 --[[ ROBLOX adaptation: added 1 to array index ]]
		]
		a13 = matrix[
			8 --[[ ROBLOX adaptation: added 1 to array index ]]
		]
		a20 = matrix[
			9 --[[ ROBLOX adaptation: added 1 to array index ]]
		]
		a21 = matrix[
			10 --[[ ROBLOX adaptation: added 1 to array index ]]
		]
		a22 = matrix[
			11 --[[ ROBLOX adaptation: added 1 to array index ]]
		]
		a23 = matrix[
			12 --[[ ROBLOX adaptation: added 1 to array index ]]
		]
		out[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		] = a00
		out[
			2 --[[ ROBLOX adaptation: added 1 to array index ]]
		] = a01
		out[
			3 --[[ ROBLOX adaptation: added 1 to array index ]]
		] = a02
		out[
			4 --[[ ROBLOX adaptation: added 1 to array index ]]
		] = a03
		out[
			5 --[[ ROBLOX adaptation: added 1 to array index ]]
		] = a10
		out[
			6 --[[ ROBLOX adaptation: added 1 to array index ]]
		] = a11
		out[
			7 --[[ ROBLOX adaptation: added 1 to array index ]]
		] = a12
		out[
			8 --[[ ROBLOX adaptation: added 1 to array index ]]
		] = a13
		out[
			9 --[[ ROBLOX adaptation: added 1 to array index ]]
		] = a20
		out[
			10 --[[ ROBLOX adaptation: added 1 to array index ]]
		] = a21
		out[
			11 --[[ ROBLOX adaptation: added 1 to array index ]]
		] = a22
		out[
			12 --[[ ROBLOX adaptation: added 1 to array index ]]
		] = a23
		out[
			13 --[[ ROBLOX adaptation: added 1 to array index ]]
		] = a00 * x
			+ a10 * y
			+ a20 * z
			+ matrix[
				13 --[[ ROBLOX adaptation: added 1 to array index ]]
			]
		out[
			14 --[[ ROBLOX adaptation: added 1 to array index ]]
		] = a01 * x
			+ a11 * y
			+ a21 * z
			+ matrix[
				14 --[[ ROBLOX adaptation: added 1 to array index ]]
			]
		out[
			15 --[[ ROBLOX adaptation: added 1 to array index ]]
		] = a02 * x
			+ a12 * y
			+ a22 * z
			+ matrix[
				15 --[[ ROBLOX adaptation: added 1 to array index ]]
			]
		out[
			16 --[[ ROBLOX adaptation: added 1 to array index ]]
		] = a03 * x
			+ a13 * y
			+ a23 * z
			+ matrix[
				16 --[[ ROBLOX adaptation: added 1 to array index ]]
			]
	end
	return out
end
return translate
