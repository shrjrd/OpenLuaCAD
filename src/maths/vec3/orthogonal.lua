-- ROBLOX NOTE: no upstream
local abs = require("./abs")
local create = require("./create")
local cross = require("./cross")
--[[*
 * Create a new vector that is orthogonal to the given vector.
 *
 * @param {vec3} out - receiving vector
 * @param {vec3} vector - vector of reference
 * @returns {vec3} out
 * @alias module:modeling/maths/vec3.orthogonal
 ]]
local function orthogonal(out, vector)
	local bV = abs(create(), vector)
	local b0 = 0
		+ (
			(
					bV[
							1 --[[ ROBLOX adaptation: added 1 to array index ]]
						]
						< bV[
							2 --[[ ROBLOX adaptation: added 1 to array index ]]
						] --[[ ROBLOX CHECK: operator '<' works only if either both arguments are strings or both are a number ]]
					and bV[
							1 --[[ ROBLOX adaptation: added 1 to array index ]]
						]
						< bV[
							3 --[[ ROBLOX adaptation: added 1 to array index ]]
						] --[[ ROBLOX CHECK: operator '<' works only if either both arguments are strings or both are a number ]]
				)
				and 1
			or 0
		)
	local b1 = 0
		+ (
			(
					bV[
							2 --[[ ROBLOX adaptation: added 1 to array index ]]
						]
						<= bV[
							1 --[[ ROBLOX adaptation: added 1 to array index ]]
						] --[[ ROBLOX CHECK: operator '<=' works only if either both arguments are strings or both are a number ]]
					and bV[
							2 --[[ ROBLOX adaptation: added 1 to array index ]]
						]
						< bV[
							3 --[[ ROBLOX adaptation: added 1 to array index ]]
						] --[[ ROBLOX CHECK: operator '<' works only if either both arguments are strings or both are a number ]]
				)
				and 1
			or 0
		)
	local b2 = 0
		+ (
			(
					bV[
							3 --[[ ROBLOX adaptation: added 1 to array index ]]
						]
						<= bV[
							1 --[[ ROBLOX adaptation: added 1 to array index ]]
						] --[[ ROBLOX CHECK: operator '<=' works only if either both arguments are strings or both are a number ]]
					and bV[
							3 --[[ ROBLOX adaptation: added 1 to array index ]]
						]
						<= bV[
							2 --[[ ROBLOX adaptation: added 1 to array index ]]
						] --[[ ROBLOX CHECK: operator '<=' works only if either both arguments are strings or both are a number ]]
				)
				and 1
			or 0
		)
	return cross(out, vector, { b0, b1, b2 })
end
return orthogonal
