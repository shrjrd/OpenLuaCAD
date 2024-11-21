-- ROBLOX NOTE: no upstream
local Packages = game.ReplicatedStorage.Packages
local LuauPolyfill = require(Packages.LuauPolyfill)
local Boolean = LuauPolyfill.Boolean
--[[*
 * Transforms the given vector using the given matrix.
 *
 * @param {vec3} out - receiving vector
 * @param {vec3} vector - vector to transform
 * @param {mat4} matrix - transform matrix
 * @returns {vec3} out
 * @alias module:modeling/maths/vec3.transform
 ]]
local function transform(out, vector, matrix)
	local x = vector[
		1 --[[ ROBLOX adaptation: added 1 to array index ]]
	]
	local y = vector[
		2 --[[ ROBLOX adaptation: added 1 to array index ]]
	]
	local z = vector[
		3 --[[ ROBLOX adaptation: added 1 to array index ]]
	]
	local w = matrix[
		4 --[[ ROBLOX adaptation: added 1 to array index ]]
	] * x
		+ matrix[
			8 --[[ ROBLOX adaptation: added 1 to array index ]]
		] * y
		+ matrix[
			12 --[[ ROBLOX adaptation: added 1 to array index ]]
		] * z
		+ matrix[
			16 --[[ ROBLOX adaptation: added 1 to array index ]]
		]
	w = Boolean.toJSBoolean(w) and w or 1.0
	out[
		1 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = (
		matrix[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		] * x
		+ matrix[
			5 --[[ ROBLOX adaptation: added 1 to array index ]]
		] * y
		+ matrix[
			9 --[[ ROBLOX adaptation: added 1 to array index ]]
		] * z
		+ matrix[
			13 --[[ ROBLOX adaptation: added 1 to array index ]]
		]
	) / w
	out[
		2 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = (
		matrix[
			2 --[[ ROBLOX adaptation: added 1 to array index ]]
		] * x
		+ matrix[
			6 --[[ ROBLOX adaptation: added 1 to array index ]]
		] * y
		+ matrix[
			10 --[[ ROBLOX adaptation: added 1 to array index ]]
		] * z
		+ matrix[
			14 --[[ ROBLOX adaptation: added 1 to array index ]]
		]
	) / w
	out[
		3 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = (
		matrix[
			3 --[[ ROBLOX adaptation: added 1 to array index ]]
		] * x
		+ matrix[
			7 --[[ ROBLOX adaptation: added 1 to array index ]]
		] * y
		+ matrix[
			11 --[[ ROBLOX adaptation: added 1 to array index ]]
		] * z
		+ matrix[
			15 --[[ ROBLOX adaptation: added 1 to array index ]]
		]
	) / w
	return out
end
return transform
