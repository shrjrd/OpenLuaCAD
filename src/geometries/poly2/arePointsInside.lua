-- ROBLOX NOTE: no upstream
local Packages = game.ReplicatedStorage.Packages
local LuauPolyfill = require(Packages.LuauPolyfill)
local Array = LuauPolyfill.Array
local Boolean = LuauPolyfill.Boolean
local measureArea = require("./measureArea")
local flip = require("./flip")
--[[
 * Determine if the given point is inside the polygon.
 *
 * @see http://erich.realtimerendering.com/ptinpoly/ (Crossings Test)
 * @param {Array} point - an array with X and Y values
 * @param {Array} polygon - a list of points, where each point is an array with X and Y values
 * @return {Integer} 1 if the point is inside, 0 if outside
 ]]
local function isPointInside(point, polygon)
	local numverts = #polygon
	local tx = point[
		1 --[[ ROBLOX adaptation: added 1 to array index ]]
	]
	local ty = point[
		2 --[[ ROBLOX adaptation: added 1 to array index ]]
	]
	local vtx0 = polygon[(numverts - 1)]
	local vtx1 = polygon[
		1 --[[ ROBLOX adaptation: added 1 to array index ]]
	]
	local yflag0 = vtx0[
		2 --[[ ROBLOX adaptation: added 1 to array index ]]
	]
		> ty --[[ ROBLOX CHECK: operator '>' works only if either both arguments are strings or both are a number ]]
	local insideFlag = 0
	local i = 0
	do
		local j = numverts + 1
		while (function()
			j -= 1
			return j
		end)() do
			--[[
     * check if Y endpoints straddle (are on opposite sides) of point's Y
     * if so, +X ray could intersect this edge.
     ]]
			local yflag1 = vtx1[
				2 --[[ ROBLOX adaptation: added 1 to array index ]]
			]
				> ty --[[ ROBLOX CHECK: operator '>' works only if either both arguments are strings or both are a number ]]
			if yflag0 ~= yflag1 then
				--[[
       * check if X endpoints are on same side of the point's X
       * if so, it's easy to test if edge hits or misses.
       ]]
				local xflag0 = vtx0[
					1 --[[ ROBLOX adaptation: added 1 to array index ]]
				]
					> tx --[[ ROBLOX CHECK: operator '>' works only if either both arguments are strings or both are a number ]]
				local xflag1 = vtx1[
					1 --[[ ROBLOX adaptation: added 1 to array index ]]
				]
					> tx --[[ ROBLOX CHECK: operator '>' works only if either both arguments are strings or both are a number ]]
				if Boolean.toJSBoolean(if Boolean.toJSBoolean(xflag0) then xflag1 else xflag0) then
					--[[ if edge's X values are both right of the point, then the point must be inside ]]
					insideFlag = not Boolean.toJSBoolean(insideFlag)
				else
					--[[
         * if X endpoints straddle the point, then
         * the compute intersection of polygon edge with +X ray
         * if intersection >= point's X then the +X ray hits it.
         ]]
					if
						vtx1[
								1 --[[ ROBLOX adaptation: added 1 to array index ]]
							]
							- (
									vtx1[
										2 --[[ ROBLOX adaptation: added 1 to array index ]]
									] - ty
								)
								* (
									vtx0[
										1 --[[ ROBLOX adaptation: added 1 to array index ]]
									]
									- vtx1[
										1 --[[ ROBLOX adaptation: added 1 to array index ]]
									]
								)
								/ (
									vtx0[
										2 --[[ ROBLOX adaptation: added 1 to array index ]]
									]
									- vtx1[
										2 --[[ ROBLOX adaptation: added 1 to array index ]]
									]
								)
						>= tx --[[ ROBLOX CHECK: operator '>=' works only if either both arguments are strings or both are a number ]]
					then
						insideFlag = not Boolean.toJSBoolean(insideFlag)
					end
				end
			end
			--[[ move to next pair of vertices, retaining info as possible ]]
			yflag0 = yflag1
			vtx0 = vtx1
			vtx1 = polygon[((function()
				i += 1
				return i
			end)())]
		end
	end
	return insideFlag
end
--[[*
 * Determine if the given points are inside the given polygon.
 *
 * @param {Array} points - a list of points, where each point is an array with X and Y values
 * @param {poly2} polygon - a 2D polygon
 * @return {Integer} 1 if all points are inside, 0 if some or none are inside
 * @alias module:modeling/geometries/poly2.arePointsInside
 ]]
local function arePointsInside(points, polygon)
	if #points == 0 then
		return 0
	end -- nothing to check
	local vertices = polygon.vertices
	if
		#vertices
		< 3 --[[ ROBLOX CHECK: operator '<' works only if either both arguments are strings or both are a number ]]
	then
		return 0
	end -- nothing can be inside an empty polygon
	if
		measureArea(polygon)
		< 0 --[[ ROBLOX CHECK: operator '<' works only if either both arguments are strings or both are a number ]]
	then
		polygon = flip(polygon) -- CCW is required
	end
	local sum = Array.reduce(points, function(acc, point)
		return acc + isPointInside(point, vertices)
	end, 0) --[[ ROBLOX CHECK: check if 'points' is an Array ]]
	return if sum == #points then 1 else 0
end
return arePointsInside
