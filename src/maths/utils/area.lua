-- ROBLOX NOTE: no upstream
--[[*
 * Calculate the area under the given points.
 * @param {Array} points - list of 2D points
 * @return {Number} area under the given points
 * @alias module:modeling/maths/utils.area
 ]]
local function area(points)
	local area = 0
	do
		local i = 0
		while
			i
			< #points --[[ ROBLOX CHECK: operator '<' works only if either both arguments are strings or both are a number ]]
		do
			local j = (i + 1) % #points
			area += points[i][
				1 --[[ ROBLOX adaptation: added 1 to array index ]]
			] * points[j][
				2 --[[ ROBLOX adaptation: added 1 to array index ]]
			]
			area -= points[j][
				1 --[[ ROBLOX adaptation: added 1 to array index ]]
			] * points[i][
				2 --[[ ROBLOX adaptation: added 1 to array index ]]
			]
			i += 1
		end
	end
	return area / 2.0
end
return area
