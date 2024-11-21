-- ROBLOX NOTE: no upstream
--[[*
 * Rotates the given vector by the given angle.
 *
 * @param {vec2} out - receiving vector
 * @param {vec2} vector - vector to rotate
 * @param {vec2} origin - origin of the rotation
 * @param {Number} radians - angle of rotation (radians)
 * @returns {vec2} out
 * @alias module:modeling/maths/vec2.rotate
 ]]
local function rotate(out, vector, origin, radians)
	local x = vector[
		1 --[[ ROBLOX adaptation: added 1 to array index ]]
	] - origin[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		]
	local y = vector[
		2 --[[ ROBLOX adaptation: added 1 to array index ]]
	] - origin[
			2 --[[ ROBLOX adaptation: added 1 to array index ]]
		]
	local c = math.cos(radians)
	local s = math.sin(radians)
	out[
		1 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = x * c
		- y * s
		+ origin[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		]
	out[
		2 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = x * s
		+ y * c
		+ origin[
			2 --[[ ROBLOX adaptation: added 1 to array index ]]
		]
	return out
end
return rotate
