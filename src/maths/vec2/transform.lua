-- ROBLOX NOTE: no upstream
--[[*
 * Transforms the given vector using the given matrix.
 *
 * @param {vec2} out - receiving vector
 * @param {vec2} vector - vector to transform
 * @param {mat4} matrix - matrix to transform with
 * @returns {vec2} out
 * @alias module:modeling/maths/vec2.transform
 ]]
local function transform(out, vector, matrix)
	local x = vector[
		1 --[[ ROBLOX adaptation: added 1 to array index ]]
	]
	local y = vector[
		2 --[[ ROBLOX adaptation: added 1 to array index ]]
	]
	out[
		1 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = matrix[
		1 --[[ ROBLOX adaptation: added 1 to array index ]]
	]
			* x
		+ matrix[
				5 --[[ ROBLOX adaptation: added 1 to array index ]]
			]
			* y
		+ matrix[
			13 --[[ ROBLOX adaptation: added 1 to array index ]]
		]
	out[
		2 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = matrix[
		2 --[[ ROBLOX adaptation: added 1 to array index ]]
	]
			* x
		+ matrix[
				6 --[[ ROBLOX adaptation: added 1 to array index ]]
			]
			* y
		+ matrix[
			14 --[[ ROBLOX adaptation: added 1 to array index ]]
		]
	return out
end
return transform
