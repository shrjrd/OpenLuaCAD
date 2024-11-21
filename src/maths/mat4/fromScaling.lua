-- ROBLOX NOTE: no upstream
--[[*
 * Creates a matrix from a vector scaling.
 * This is equivalent to (but much faster than):
 *
 *     mat4.identity(dest)
 *     mat4.scale(dest, dest, vec)
 *
 * @param {mat4} out - receiving matrix
 * @param {vec3} vector - X, Y, Z factors by which to scale
 * @returns {mat4} out
 * @alias module:modeling/maths/mat4.fromScaling
 * @example
 * let matrix = fromScaling([1, 2, 0.5])
 ]]
local function fromScaling(out, vector)
	out[
		1 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = vector[
		1 --[[ ROBLOX adaptation: added 1 to array index ]]
	]
	out[
		2 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = 0
	out[
		3 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = 0
	out[
		4 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = 0
	out[
		5 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = 0
	out[
		6 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = vector[
		2 --[[ ROBLOX adaptation: added 1 to array index ]]
	]
	out[
		7 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = 0
	out[
		8 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = 0
	out[
		9 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = 0
	out[
		10 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = 0
	out[
		11 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = vector[
		3 --[[ ROBLOX adaptation: added 1 to array index ]]
	]
	out[
		12 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = 0
	out[
		13 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = 0
	out[
		14 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = 0
	out[
		15 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = 0
	out[
		16 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = 1
	return out
end
return fromScaling
