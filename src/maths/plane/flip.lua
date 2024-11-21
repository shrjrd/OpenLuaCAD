-- ROBLOX NOTE: no upstream
--[[*
 * Flip the given plane.
 *
 * @param {plane} out - receiving plane
 * @param {plane} plane - plane to flip
 * @return {plane} out
 * @alias module:modeling/maths/plane.flip
 ]]
local function flip(out, plane)
	out[
		1 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = -plane[
		1 --[[ ROBLOX adaptation: added 1 to array index ]]
	]
	out[
		2 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = -plane[
		2 --[[ ROBLOX adaptation: added 1 to array index ]]
	]
	out[
		3 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = -plane[
		3 --[[ ROBLOX adaptation: added 1 to array index ]]
	]
	out[
		4 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = -plane[
		4 --[[ ROBLOX adaptation: added 1 to array index ]]
	]
	return out
end
return flip
