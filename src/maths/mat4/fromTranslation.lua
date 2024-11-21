-- ROBLOX NOTE: no upstream
--[[*
 * Creates a matrix from a vector translation.
 * This is equivalent to (but much faster than):
 *
 *     mat4.identity(dest)
 *     mat4.translate(dest, dest, vec)
 *
 * @param {mat4} out - receiving matrix
 * @param {vec3} vector - offset (vector) of translation
 * @returns {mat4} out
 * @alias module:modeling/maths/mat4.fromTranslation
 * @example
 * let matrix = fromTranslation(create(), [1, 2, 3])
 ]]
local function fromTranslation(out, vector)
	out[
		1 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = 1
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
	] = 1
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
	] = 1
	out[
		12 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = 0
	out[
		13 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = vector[
		1 --[[ ROBLOX adaptation: added 1 to array index ]]
	]
	out[
		14 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = vector[
		2 --[[ ROBLOX adaptation: added 1 to array index ]]
	]
	out[
		15 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = vector[
		3 --[[ ROBLOX adaptation: added 1 to array index ]]
	]
	out[
		16 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = 1
	return out
end
return fromTranslation
