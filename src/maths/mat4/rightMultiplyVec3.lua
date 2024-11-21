-- ROBLOX NOTE: no upstream
local fromValues = require("../vec3/fromValues")
--[[*
 * Multiply a 3D vector by a matrix (interpreted as 3 row, 1 column)
 *
 * Calculation: result = v*M, where the fourth element is set to 1.
 * @param {vec3} vector - input vector
 * @param {mat4} matrix - input matrix
 * @returns {vec3} a new vector
 * @alias module:modeling/maths/mat4.rightMultiplyVec3
 ]]
local function rightMultiplyVec3(vector, matrix)
	local v0, v1, v2 = table.unpack(vector, 1, 3)
	local v3 = 1
	local x = v0 * matrix[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		]
		+ v1 * matrix[
			2 --[[ ROBLOX adaptation: added 1 to array index ]]
		]
		+ v2 * matrix[
			3 --[[ ROBLOX adaptation: added 1 to array index ]]
		]
		+ v3 * matrix[
			4 --[[ ROBLOX adaptation: added 1 to array index ]]
		]
	local y = v0 * matrix[
			5 --[[ ROBLOX adaptation: added 1 to array index ]]
		]
		+ v1 * matrix[
			6 --[[ ROBLOX adaptation: added 1 to array index ]]
		]
		+ v2 * matrix[
			7 --[[ ROBLOX adaptation: added 1 to array index ]]
		]
		+ v3 * matrix[
			8 --[[ ROBLOX adaptation: added 1 to array index ]]
		]
	local z = v0 * matrix[
			9 --[[ ROBLOX adaptation: added 1 to array index ]]
		]
		+ v1 * matrix[
			10 --[[ ROBLOX adaptation: added 1 to array index ]]
		]
		+ v2 * matrix[
			11 --[[ ROBLOX adaptation: added 1 to array index ]]
		]
		+ v3 * matrix[
			12 --[[ ROBLOX adaptation: added 1 to array index ]]
		]
	local w = v0 * matrix[
			13 --[[ ROBLOX adaptation: added 1 to array index ]]
		]
		+ v1 * matrix[
			14 --[[ ROBLOX adaptation: added 1 to array index ]]
		]
		+ v2 * matrix[
			15 --[[ ROBLOX adaptation: added 1 to array index ]]
		]
		+ v3 * matrix[
			16 --[[ ROBLOX adaptation: added 1 to array index ]]
		] -- scale such that fourth element becomes 1:
	if w ~= 1 then
		local invw = 1.0 / w
		x *= invw
		y *= invw
		z *= invw
	end
	return fromValues(x, y, z)
end
return rightMultiplyVec3
