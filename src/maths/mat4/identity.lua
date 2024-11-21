-- ROBLOX NOTE: no upstream
--[[*
 * Set a matrix to the identity transform.
 *
 * @param {mat4} out - receiving matrix
 * @returns {mat4} out
 * @alias module:modeling/maths/mat4.identity
 ]]
local function identity(out)
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
return identity
