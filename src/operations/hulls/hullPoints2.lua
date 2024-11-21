-- ROBLOX NOTE: no upstream
local Packages = game.ReplicatedStorage.Packages
local Number_EPSILON = 2.220446049250313e-16
local LuauPolyfill = require(Packages.LuauPolyfill)
local Array = LuauPolyfill.Array
local vec2 = require("../../maths/vec2")
-- Returned "angle" is really 1/tan (inverse of slope) made negative to increase with angle.
-- This function is strictly for sorting in this algorithm.
local function fakeAtan2(y, x)
	-- The "if" is a special case for when the minimum vector found in loop above is present.
	-- We need to ensure that it sorts as the minimum point. Otherwise, this becomes NaN.
	if y == 0 and x == 0 then
		return -math.huge
	else
		return -x / y
	end
end
-- returns: < 0 clockwise, 0 colinear, > 0 counter-clockwise
local function ccw(v1, v2, v3)
	return (
		v2[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		] - v1[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		]
	)
			* (
				v3[
					2 --[[ ROBLOX adaptation: added 1 to array index ]]
				] - v1[
					2 --[[ ROBLOX adaptation: added 1 to array index ]]
				]
			)
		- (
				v2[
					2 --[[ ROBLOX adaptation: added 1 to array index ]]
				] - v1[
					2 --[[ ROBLOX adaptation: added 1 to array index ]]
				]
			)
			* (
				v3[
					1 --[[ ROBLOX adaptation: added 1 to array index ]]
				] - v1[
					1 --[[ ROBLOX adaptation: added 1 to array index ]]
				]
			)
end
--[[*
 * Create a convex hull of the given set of points, where each point is an array of [x,y].
 * @see https://en.wikipedia.org/wiki/Graham_scan
 *
 * @param {Array} uniquePoints - list of UNIQUE points from which to create a hull
 * @returns {Array} a list of points that form the hull
 * @alias module:modeling/hulls.hullPoints2
 ]]
local function hullPoints2(uniquePoints)
	-- find min point
	local min = vec2.fromValues(math.huge, math.huge)
	Array.forEach(uniquePoints, function(point)
		if
			point[
					2 --[[ ROBLOX adaptation: added 1 to array index ]]
				]
				< min[
					2 --[[ ROBLOX adaptation: added 1 to array index ]]
				] --[[ ROBLOX CHECK: operator '<' works only if either both arguments are strings or both are a number ]]
			or point[
						2 --[[ ROBLOX adaptation: added 1 to array index ]]
					]
					== min[
						2 --[[ ROBLOX adaptation: added 1 to array index ]]
					]
				and point[
						1 --[[ ROBLOX adaptation: added 1 to array index ]]
					]
					< min[
						1 --[[ ROBLOX adaptation: added 1 to array index ]]
					] --[[ ROBLOX CHECK: operator '<' works only if either both arguments are strings or both are a number ]]
		then
			min = point
		end
	end) --[[ ROBLOX CHECK: check if 'uniquePoints' is an Array ]] -- gather information for sorting by polar coordinates (point, angle, distSq)
	local points = {}
	Array.forEach(uniquePoints, function(point)
		-- use faster fakeAtan2 instead of Math.atan2
		local angle = fakeAtan2(point[
			2 --[[ ROBLOX adaptation: added 1 to array index ]]
		] - min[
			2 --[[ ROBLOX adaptation: added 1 to array index ]]
		], point[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		] - min[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		])
		local distSq = vec2.squaredDistance(point, min)
		table.insert(points, { point = point, angle = angle, distSq = distSq }) --[[ ROBLOX CHECK: check if 'points' is an Array ]]
	end) --[[ ROBLOX CHECK: check if 'uniquePoints' is an Array ]] -- sort by polar coordinates
	Array.sort(points, function(pt1, pt2)
		return if pt1.angle ~= pt2.angle then pt1.angle - pt2.angle else pt1.distSq - pt2.distSq
	end) --[[ ROBLOX CHECK: check if 'points' is an Array ]]
	local stack = {} -- start with empty stack
	Array.forEach(points, function(point)
		local cnt = #stack
		while
			cnt > 1 --[[ ROBLOX CHECK: operator '>' works only if either both arguments are strings or both are a number ]]
			and ccw(stack[(cnt - 2)], stack[(cnt - 1)], point.point) <= Number_EPSILON --[[ ROBLOX CHECK: operator '<=' works only if either both arguments are strings or both are a number ]]
		do
			table.remove(stack) --[[ ROBLOX CHECK: check if 'stack' is an Array ]] -- get rid of colinear and interior (clockwise) points
			cnt = #stack
		end
		table.insert(stack, point.point) --[[ ROBLOX CHECK: check if 'stack' is an Array ]]
	end) --[[ ROBLOX CHECK: check if 'points' is an Array ]]
	return stack
end
return hullPoints2
