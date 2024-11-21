-- ROBLOX NOTE: no upstream
local Packages = game.ReplicatedStorage.Packages
local LuauPolyfill = require(Packages.LuauPolyfill)
local Array = LuauPolyfill.Array
local Boolean = LuauPolyfill.Boolean
local Error = LuauPolyfill.Error
local Number = LuauPolyfill.Number
local EPS = require("../../src/maths/constants").EPS
--[[*
 * Compare two vectors for equality
 * @param {vec} vec1 - vector (array) of values
 * @param {vec} vec2 - vector (array) of values
 * @param {number} eps - Epsilon - the largest difference between two numbers to consider trivial
 * @returns {boolean} result of comparison
 ]]
local function compareVectors(vec1, vec2, eps_: any?)
	local eps: any = if eps_ ~= nil then eps_ else EPS
	if #vec1 == #vec2 then
		return Array.reduce(vec1, function(valid, value, index)
			-- get the values, which also does type conversions
			local value1 = vec1[index]
			local value2 = vec2[index] -- special comparison for NAN values
			-- type is Number, and value is NaN
			if
				Boolean.toJSBoolean((function()
					local ref = Number.isNaN(value1)
					return if Boolean.toJSBoolean(ref) then Number.isNaN(value2) else ref
				end)())
			then
				return valid
			end -- type is Number, and value is finite
			if
				Boolean.toJSBoolean((function()
					local ref = Number.isFinite(value1)
					return if Boolean.toJSBoolean(ref) then Number.isFinite(value2) else ref
				end)())
			then
				-- compare number values, not types
				local diff = math.abs(value1 - value2)
				return if Boolean.toJSBoolean(valid)
					then diff
						< eps --[[ ROBLOX CHECK: operator '<' works only if either both arguments are strings or both are a number ]]
					else valid
			end -- catch mistakes in usage
			if typeof(value1) ~= "number" then
				error(Error.new("invalid usage of compareVectors; vec1"))
			end
			if typeof(value2) ~= "number" then
				error(Error.new("invalid usage of compareVectors; vec2"))
			end
			return valid
		end, true) --[[ ROBLOX CHECK: check if 'vec1' is an Array ]]
	end
	return false
end
return compareVectors
