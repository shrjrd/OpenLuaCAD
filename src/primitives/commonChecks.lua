-- ROBLOX NOTE: no upstream

local LuauPolyfill = require("@Packages/LuauPolyfill")
local Array = LuauPolyfill.Array
local Boolean = LuauPolyfill.Boolean
local Number = LuauPolyfill.Number
-- verify that the array has the given dimension, and contains Number values
local function isNumberArray(array, dimension)
	if
		Boolean.toJSBoolean((function()
			local ref = Array.isArray(array)
			return if Boolean.toJSBoolean(ref)
				then #array
					>= dimension --[[ ROBLOX CHECK: operator '>=' works only if either both arguments are strings or both are a number ]]
				else ref
		end)())
	then
		return Array.every(array, function(n)
			return Number.isFinite(n)
		end) --[[ ROBLOX CHECK: check if 'array' is an Array ]]
	end
	return false
end -- verify that the value is a Number greater than the constant
local function isGT(value, constant)
	local ref = Number.isFinite(value)
	return if Boolean.toJSBoolean(ref)
		then value
			> constant --[[ ROBLOX CHECK: operator '>' works only if either both arguments are strings or both are a number ]]
		else ref
end -- verify that the value is a Number greater than or equal to the constant
local function isGTE(value, constant)
	local ref = Number.isFinite(value)
	return if Boolean.toJSBoolean(ref)
		then value
			>= constant --[[ ROBLOX CHECK: operator '>=' works only if either both arguments are strings or both are a number ]]
		else ref
end
return { isNumberArray = isNumberArray, isGT = isGT, isGTE = isGTE }
