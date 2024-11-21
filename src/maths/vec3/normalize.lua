-- ROBLOX NOTE: no upstream
--[[*
 * Normalize the given vector.
 *
 * @param {vec3} out - receiving vector
 * @param {vec3} vector - vector to normalize
 * @returns {vec3} out
 * @alias module:modeling/maths/vec3.normalize
 ]]
local function normalize(out, vector)
	local x = vector[
		1 --[[ ROBLOX adaptation: added 1 to array index ]]
	]
	local y = vector[
		2 --[[ ROBLOX adaptation: added 1 to array index ]]
	]
	local z = vector[
		3 --[[ ROBLOX adaptation: added 1 to array index ]]
	]
	local len = x * x + y * y + z * z
	if
		len
		> 0 --[[ ROBLOX CHECK: operator '>' works only if either both arguments are strings or both are a number ]]
	then
		len = 1 / math.sqrt(len)
	end
	out[
		1 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = x * len
	out[
		2 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = y * len
	out[
		3 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = z * len
	return out
end
return normalize
