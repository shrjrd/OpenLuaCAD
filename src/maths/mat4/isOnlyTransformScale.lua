-- ROBLOX NOTE: no upstream

local Number_EPSILON = 2.220446049250313e-16
local LuauPolyfill = require("@Packages/LuauPolyfill")
local Boolean = LuauPolyfill.Boolean
local function isZero(num)
	return math.abs(num) < Number_EPSILON --[[ ROBLOX CHECK: operator '<' works only if either both arguments are strings or both are a number ]]
end
--[[*
 * Determine whether the given matrix is only translate and/or scale.
 * This code returns true for TAU / 2 rotation as it can be interpreted as scale.
 *
 * @param {mat4} matrix - the matrix
 * @returns {Boolean} true if matrix is for translate and/or scale
 * @alias module:modeling/maths/mat4.isOnlyTransformScale
 ]]
local function isOnlyTransformScale(matrix)
	local ref = isZero(matrix[
		2 --[[ ROBLOX adaptation: added 1 to array index ]]
	])
	ref = if Boolean.toJSBoolean(ref)
		then isZero(matrix[
			3 --[[ ROBLOX adaptation: added 1 to array index ]]
		])
		else ref
	ref = if Boolean.toJSBoolean(ref)
		then isZero(matrix[
			4 --[[ ROBLOX adaptation: added 1 to array index ]]
		])
		else ref
	ref = if Boolean.toJSBoolean(ref)
		then isZero(matrix[
			5 --[[ ROBLOX adaptation: added 1 to array index ]]
		])
		else ref
	ref = if Boolean.toJSBoolean(ref)
		then isZero(matrix[
			7 --[[ ROBLOX adaptation: added 1 to array index ]]
		])
		else ref
	ref = if Boolean.toJSBoolean(ref)
		then isZero(matrix[
			8 --[[ ROBLOX adaptation: added 1 to array index ]]
		])
		else ref
	ref = if Boolean.toJSBoolean(ref)
		then isZero(matrix[
			9 --[[ ROBLOX adaptation: added 1 to array index ]]
		])
		else ref
	ref = if Boolean.toJSBoolean(ref)
		then isZero(matrix[
			10 --[[ ROBLOX adaptation: added 1 to array index ]]
		])
		else ref
	ref = if Boolean.toJSBoolean(ref)
		then isZero(matrix[
			12 --[[ ROBLOX adaptation: added 1 to array index ]]
		])
		else ref
	return -- TODO check if it is worth the effort to add recognition of 90 deg rotations
		if Boolean.toJSBoolean(ref)
		then matrix[
			16 --[[ ROBLOX adaptation: added 1 to array index ]]
		] == 1
		else ref
end
return isOnlyTransformScale
