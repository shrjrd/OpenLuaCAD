-- ROBLOX NOTE: no upstream
local vec3 = require("../vec3")
--[[*
 * Project the given point on to the given plane.
 *
 * @param {plane} plane - plane of reference
 * @param {vec3} point - point of reference
 * @return {vec3} projected point on plane
 * @alias module:modeling/maths/plane.projectionOfPoint
 ]]
local function projectionOfPoint(plane, point)
	local a = point[
		1 --[[ ROBLOX adaptation: added 1 to array index ]]
	]
			* plane[
				1 --[[ ROBLOX adaptation: added 1 to array index ]]
			]
		+ point[
				2 --[[ ROBLOX adaptation: added 1 to array index ]]
			]
			* plane[
				2 --[[ ROBLOX adaptation: added 1 to array index ]]
			]
		+ point[
				3 --[[ ROBLOX adaptation: added 1 to array index ]]
			]
			* plane[
				3 --[[ ROBLOX adaptation: added 1 to array index ]]
			]
		- plane[
			4 --[[ ROBLOX adaptation: added 1 to array index ]]
		]
	local x = point[
		1 --[[ ROBLOX adaptation: added 1 to array index ]]
	] - a * plane[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		]
	local y = point[
		2 --[[ ROBLOX adaptation: added 1 to array index ]]
	] - a * plane[
			2 --[[ ROBLOX adaptation: added 1 to array index ]]
		]
	local z = point[
		3 --[[ ROBLOX adaptation: added 1 to array index ]]
	] - a * plane[
			3 --[[ ROBLOX adaptation: added 1 to array index ]]
		]
	return vec3.fromValues(x, y, z)
end
return projectionOfPoint
