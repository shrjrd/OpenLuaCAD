-- ROBLOX NOTE: no upstream
--[[*
 * Computes the cross product of the given vectors (AxB).
 *
 * @param {vec3} out - receiving vector
 * @param {vec3} a - first operand
 * @param {vec3} b - second operand
 * @returns {vec3} out
 * @alias module:modeling/maths/vec3.cross
 ]]
local function cross(out, a, b)
	local ax = a[
		1 --[[ ROBLOX adaptation: added 1 to array index ]]
	]
	local ay = a[
		2 --[[ ROBLOX adaptation: added 1 to array index ]]
	]
	local az = a[
		3 --[[ ROBLOX adaptation: added 1 to array index ]]
	]
	local bx = b[
		1 --[[ ROBLOX adaptation: added 1 to array index ]]
	]
	local by = b[
		2 --[[ ROBLOX adaptation: added 1 to array index ]]
	]
	local bz = b[
		3 --[[ ROBLOX adaptation: added 1 to array index ]]
	]
	out[
		1 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = ay * bz - az * by
	out[
		2 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = az * bx - ax * bz
	out[
		3 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = ax * by - ay * bx
	return out
end
return cross
