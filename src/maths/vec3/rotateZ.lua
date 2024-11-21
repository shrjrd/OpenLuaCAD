-- ROBLOX NOTE: no upstream
--[[*
 * Rotate the given vector around the given origin, Z axis only.
 *
 * @param {vec3} out - receiving vector
 * @param {vec3} vector - vector to rotate
 * @param {vec3} origin - origin of the rotation
 * @param {Number} radians - angle of rotation in radians
 * @returns {vec3} out
 * @alias module:modeling/maths/vec3.rotateZ
 ]]
local function rotateZ(out, vector, origin, radians)
	local p = {}
	local r = {} -- Translate point to the origin
	p[
		1 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = vector[
		1 --[[ ROBLOX adaptation: added 1 to array index ]]
	] - origin[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		]
	p[
		2 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = vector[
		2 --[[ ROBLOX adaptation: added 1 to array index ]]
	] - origin[
			2 --[[ ROBLOX adaptation: added 1 to array index ]]
		] -- perform rotation
	r[
		1 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = p[
		1 --[[ ROBLOX adaptation: added 1 to array index ]]
	]
			* math.cos(radians)
		- p[
			2 --[[ ROBLOX adaptation: added 1 to array index ]]
		] * math.sin(radians)
	r[
		2 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = p[
		1 --[[ ROBLOX adaptation: added 1 to array index ]]
	]
			* math.sin(radians)
		+ p[
			2 --[[ ROBLOX adaptation: added 1 to array index ]]
		] * math.cos(radians) -- translate to correct position
	out[
		1 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = r[
		1 --[[ ROBLOX adaptation: added 1 to array index ]]
	] + origin[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		]
	out[
		2 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = r[
		2 --[[ ROBLOX adaptation: added 1 to array index ]]
	] + origin[
			2 --[[ ROBLOX adaptation: added 1 to array index ]]
		]
	out[
		3 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = vector[
		3 --[[ ROBLOX adaptation: added 1 to array index ]]
	]
	return out
end
return rotateZ
