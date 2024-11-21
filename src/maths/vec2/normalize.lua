-- ROBLOX NOTE: no upstream
--[[*
 * Normalize the given vector.
 *
 * @param {vec2} out - receiving vector
 * @param {vec2} vector - vector to normalize
 * @returns {vec2} out
 * @alias module:modeling/maths/vec2.normalize
 ]]
local function normalize(out, vector)
	local x = vector[
		1 --[[ ROBLOX adaptation: added 1 to array index ]]
	]
	local y = vector[
		2 --[[ ROBLOX adaptation: added 1 to array index ]]
	]
	local len = x * x + y * y
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
	return out
end -- old this.dividedBy(#this())
return normalize
