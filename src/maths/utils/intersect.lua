-- ROBLOX NOTE: no upstream
local Number_MIN_VALUE = 5e-324
--[[*
 * Calculate the intersect point of the two line segments (p1-p2 and p3-p4), end points included.
 * Note: If the line segments do NOT intersect then undefined is returned.
 * @see http://paulbourke.net/geometry/pointlineplane/
 * @param {vec2} p1 - first point of first line segment
 * @param {vec2} p2 - second point of first line segment
 * @param {vec2} p3 - first point of second line segment
 * @param {vec2} p4 - second point of second line segment
 * @returns {vec2} intersection point of the two line segments, or undefined
 * @alias module:modeling/maths/utils.intersect
 ]]
local function intersect(p1, p2, p3, p4)
	-- Check if none of the lines are of length 0
	if
		p1[
					1 --[[ ROBLOX adaptation: added 1 to array index ]]
				]
				== p2[
					1 --[[ ROBLOX adaptation: added 1 to array index ]]
				]
			and p1[
					2 --[[ ROBLOX adaptation: added 1 to array index ]]
				]
				== p2[
					2 --[[ ROBLOX adaptation: added 1 to array index ]]
				]
		or p3[
					1 --[[ ROBLOX adaptation: added 1 to array index ]]
				]
				== p4[
					1 --[[ ROBLOX adaptation: added 1 to array index ]]
				]
			and p3[
					2 --[[ ROBLOX adaptation: added 1 to array index ]]
				]
				== p4[
					2 --[[ ROBLOX adaptation: added 1 to array index ]]
				]
	then
		return nil
	end
	local denominator = (
		p4[
			2 --[[ ROBLOX adaptation: added 1 to array index ]]
		] - p3[
			2 --[[ ROBLOX adaptation: added 1 to array index ]]
		]
	)
			* (
				p2[
					1 --[[ ROBLOX adaptation: added 1 to array index ]]
				] - p1[
					1 --[[ ROBLOX adaptation: added 1 to array index ]]
				]
			)
		- (
				p4[
					1 --[[ ROBLOX adaptation: added 1 to array index ]]
				] - p3[
					1 --[[ ROBLOX adaptation: added 1 to array index ]]
				]
			)
			* (
				p2[
					2 --[[ ROBLOX adaptation: added 1 to array index ]]
				] - p1[
					2 --[[ ROBLOX adaptation: added 1 to array index ]]
				]
			) -- Lines are parallel
	if
		math.abs(denominator)
		< Number_MIN_VALUE --[[ ROBLOX CHECK: operator '<' works only if either both arguments are strings or both are a number ]]
	then
		return nil
	end
	local ua = (
		(
				p4[
					1 --[[ ROBLOX adaptation: added 1 to array index ]]
				] - p3[
					1 --[[ ROBLOX adaptation: added 1 to array index ]]
				]
			)
			* (
				p1[
					2 --[[ ROBLOX adaptation: added 1 to array index ]]
				] - p3[
					2 --[[ ROBLOX adaptation: added 1 to array index ]]
				]
			)
		- (
				p4[
					2 --[[ ROBLOX adaptation: added 1 to array index ]]
				] - p3[
					2 --[[ ROBLOX adaptation: added 1 to array index ]]
				]
			)
			* (
				p1[
					1 --[[ ROBLOX adaptation: added 1 to array index ]]
				] - p3[
					1 --[[ ROBLOX adaptation: added 1 to array index ]]
				]
			)
	) / denominator
	local ub = (
		(
				p2[
					1 --[[ ROBLOX adaptation: added 1 to array index ]]
				] - p1[
					1 --[[ ROBLOX adaptation: added 1 to array index ]]
				]
			)
			* (
				p1[
					2 --[[ ROBLOX adaptation: added 1 to array index ]]
				] - p3[
					2 --[[ ROBLOX adaptation: added 1 to array index ]]
				]
			)
		- (
				p2[
					2 --[[ ROBLOX adaptation: added 1 to array index ]]
				] - p1[
					2 --[[ ROBLOX adaptation: added 1 to array index ]]
				]
			)
			* (
				p1[
					1 --[[ ROBLOX adaptation: added 1 to array index ]]
				] - p3[
					1 --[[ ROBLOX adaptation: added 1 to array index ]]
				]
			)
	) / denominator -- is the intersection along the segments
	if
		ua < 0 --[[ ROBLOX CHECK: operator '<' works only if either both arguments are strings or both are a number ]]
		or ua > 1 --[[ ROBLOX CHECK: operator '>' works only if either both arguments are strings or both are a number ]]
		or ub < 0 --[[ ROBLOX CHECK: operator '<' works only if either both arguments are strings or both are a number ]]
		or ub > 1 --[[ ROBLOX CHECK: operator '>' works only if either both arguments are strings or both are a number ]]
	then
		return nil
	end -- Return the x and y coordinates of the intersection
	local x = p1[
		1 --[[ ROBLOX adaptation: added 1 to array index ]]
	]
		+ ua
			* (
				p2[
					1 --[[ ROBLOX adaptation: added 1 to array index ]]
				] - p1[
					1 --[[ ROBLOX adaptation: added 1 to array index ]]
				]
			)
	local y = p1[
		2 --[[ ROBLOX adaptation: added 1 to array index ]]
	]
		+ ua
			* (
				p2[
					2 --[[ ROBLOX adaptation: added 1 to array index ]]
				] - p1[
					2 --[[ ROBLOX adaptation: added 1 to array index ]]
				]
			)
	return { x, y }
end
return intersect
