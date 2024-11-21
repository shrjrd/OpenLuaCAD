-- ROBLOX NOTE: no upstream
--[[*
 * Calculate the angle of the given vector.
 *
 * @param {vec2} vector - vector of reference
 * @returns {Number} angle in radians
 * @alias module:modeling/maths/vec2.angleRadians
 ]]
local function angleRadians(vector)
	return math.atan2(
		vector[
			2 --[[ ROBLOX adaptation: added 1 to array index ]]
		],
		vector[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		]
	)
end -- y=sin, x=cos
return angleRadians
