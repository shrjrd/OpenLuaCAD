-- ROBLOX NOTE: no upstream
local fromValues = require("../vec2/fromValues")
--[[*
 * Multiply a 2D vector by a matrix (interpreted as 2 row, 1 column).
 *
 * Calculation: result = v*M, where the fourth element is set to 1.
 * @param {vec2} vector - input vector
 * @param {mat4} matrix - input matrix
 * @returns {vec2} a new vector
 * @alias module:modeling/maths/mat4.rightMultiplyVec2
 ]]
local function rightMultiplyVec2(vector, matrix)
	local v0, v1 = table.unpack(vector, 1, 2)
	local v2 = 0
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
	end
	return fromValues(x, y)
end
return rightMultiplyVec2
