-- ROBLOX NOTE: no upstream

local LuauPolyfill = require("@Packages/LuauPolyfill")
local Array = LuauPolyfill.Array
local Boolean = LuauPolyfill.Boolean
local Map = LuauPolyfill.Map
local Set = LuauPolyfill.Set
local EPS = require("../../maths/constants").EPS
local line2 = require("../../maths/line2")
local vec2 = require("../../maths/vec2")
local OrthoNormalBasis = require("../../maths/OrthoNormalBasis")
local interpolateBetween2DPointsForY = require("../../maths/utils/interpolateBetween2DPointsForY")
local insertSorted, fnNumberSort
do
	local ref = require("../../utils")
	insertSorted, fnNumberSort = ref.insertSorted, ref.fnNumberSort
end
local poly3 = require("../../geometries/poly3")
--[[
 * Retesselation for a set of COPLANAR polygons.
 * @param {poly3[]} sourcepolygons - list of polygons
 * @returns {poly3[]} new set of polygons
 ]]
local function reTesselateCoplanarPolygons(sourcepolygons)
	if
		#sourcepolygons
		< 2 --[[ ROBLOX CHECK: operator '<' works only if either both arguments are strings or both are a number ]]
	then
		return sourcepolygons
	end
	local destpolygons = {}
	local numpolygons = #sourcepolygons
	local plane = poly3.plane(sourcepolygons[
		1 --[[ ROBLOX adaptation: added 1 to array index ]]
	])
	local orthobasis = OrthoNormalBasis.new(plane)
	local polygonvertices2d = {} -- array of array of Vector2D
	local polygontopvertexindexes = {} -- array of indexes of topmost vertex per polygon
	local topy2polygonindexes = Map.new()
	local ycoordinatetopolygonindexes = Map.new() -- convert all polygon vertices to 2D
	-- Make a list of all encountered y coordinates
	-- And build a map of all polygons that have a vertex at a certain y coordinate:
	local ycoordinatebins = Map.new()
	local ycoordinateBinningFactor = 10 / EPS
	do
		local polygonindex = 0
		while
			polygonindex
			< numpolygons --[[ ROBLOX CHECK: operator '<' works only if either both arguments are strings or both are a number ]]
		do
			local poly3d = sourcepolygons[polygonindex]
			local vertices2d = {}
			local numvertices = #poly3d.vertices
			local minindex = -1
			if
				numvertices
				> 0 --[[ ROBLOX CHECK: operator '>' works only if either both arguments are strings or both are a number ]]
			then
				local miny
				local maxy
				do
					local i = 0
					while
						i
						< numvertices --[[ ROBLOX CHECK: operator '<' works only if either both arguments are strings or both are a number ]]
					do
						local pos2d = orthobasis:to2D(poly3d.vertices[i]) -- perform binning of y coordinates: If we have multiple vertices very
						-- close to each other, give them the same y coordinate:
						local ycoordinatebin = math.floor(pos2d[
							2 --[[ ROBLOX adaptation: added 1 to array index ]]
						] * ycoordinateBinningFactor)
						local newy
						if Boolean.toJSBoolean(ycoordinatebins:has(ycoordinatebin)) then
							newy = ycoordinatebins:get(ycoordinatebin)
						elseif Boolean.toJSBoolean(ycoordinatebins:has(ycoordinatebin + 1)) then
							newy = ycoordinatebins:get(ycoordinatebin + 1)
						elseif Boolean.toJSBoolean(ycoordinatebins:has(ycoordinatebin - 1)) then
							newy = ycoordinatebins:get(ycoordinatebin - 1)
						else
							newy = pos2d[
								2 --[[ ROBLOX adaptation: added 1 to array index ]]
							]
							ycoordinatebins:set(
								ycoordinatebin,
								pos2d[
									2 --[[ ROBLOX adaptation: added 1 to array index ]]
								]
							)
						end
						pos2d = vec2.fromValues(
							pos2d[
								1 --[[ ROBLOX adaptation: added 1 to array index ]]
							],
							newy
						)
						table.insert(vertices2d, pos2d) --[[ ROBLOX CHECK: check if 'vertices2d' is an Array ]]
						local y = pos2d[
							2 --[[ ROBLOX adaptation: added 1 to array index ]]
						]
						if
							i == 0
							or y < miny --[[ ROBLOX CHECK: operator '<' works only if either both arguments are strings or both are a number ]]
						then
							miny = y
							minindex = i
						end
						if
							i == 0
							or y > maxy --[[ ROBLOX CHECK: operator '>' works only if either both arguments are strings or both are a number ]]
						then
							maxy = y
						end
						local polygonindexes = ycoordinatetopolygonindexes:get(y)
						if not Boolean.toJSBoolean(polygonindexes) then
							polygonindexes = {} -- PERF
							ycoordinatetopolygonindexes:set(y, polygonindexes)
						end
						polygonindexes[polygonindex] = true
						i += 1
					end
				end
				if
					miny
					>= maxy --[[ ROBLOX CHECK: operator '>=' works only if either both arguments are strings or both are a number ]]
				then
					-- degenerate polygon, all vertices have same y coordinate. Just ignore it from now:
					vertices2d = {}
					numvertices = 0
					minindex = -1
				else
					local polygonindexes = topy2polygonindexes:get(miny)
					if not Boolean.toJSBoolean(polygonindexes) then
						polygonindexes = {}
						topy2polygonindexes:set(miny, polygonindexes)
					end
					table.insert(polygonindexes, polygonindex) --[[ ROBLOX CHECK: check if 'polygonindexes' is an Array ]]
				end
			end -- if(numvertices > 0)
			-- reverse the vertex order:
			Array.reverse(vertices2d) --[[ ROBLOX CHECK: check if 'vertices2d' is an Array ]]
			minindex = numvertices - minindex - 1
			table.insert(polygonvertices2d, vertices2d) --[[ ROBLOX CHECK: check if 'polygonvertices2d' is an Array ]]
			table.insert(polygontopvertexindexes, minindex) --[[ ROBLOX CHECK: check if 'polygontopvertexindexes' is an Array ]]
			polygonindex += 1
		end
	end
	local ycoordinates = {}
	Array.forEach(ycoordinatetopolygonindexes, function(polylist, y)
		return table.insert(ycoordinates, y) --[[ ROBLOX CHECK: check if 'ycoordinates' is an Array ]]
	end) --[[ ROBLOX CHECK: check if 'ycoordinatetopolygonindexes' is an Array ]]
	Array.sort(ycoordinates, fnNumberSort) --[[ ROBLOX CHECK: check if 'ycoordinates' is an Array ]] -- Now we will iterate over all y coordinates, from lowest to highest y coordinate
	-- activepolygons: source polygons that are 'active', i.e. intersect with our y coordinate
	--   Is sorted so the polygons are in left to right order
	-- Each element in activepolygons has these properties:
	--        polygonindex: the index of the source polygon (i.e. an index into the sourcepolygons
	--                      and polygonvertices2d arrays)
	--        leftvertexindex: the index of the vertex at the left side of the polygon (lowest x)
	--                         that is at or just above the current y coordinate
	--        rightvertexindex: dito at right hand side of polygon
	--        topleft, bottomleft: coordinates of the left side of the polygon crossing the current y coordinate
	--        topright, bottomright: coordinates of the right hand side of the polygon crossing the current y coordinate
	local activepolygons = {}
	local prevoutpolygonrow = {}
	do
		local yindex = 0
		while
			yindex
			< #ycoordinates --[[ ROBLOX CHECK: operator '<' works only if either both arguments are strings or both are a number ]]
		do
			local newoutpolygonrow = {}
			local ycoordinate = ycoordinates[yindex] -- update activepolygons for this y coordinate:
			-- - Remove any polygons that end at this y coordinate
			-- - update leftvertexindex and rightvertexindex (which point to the current vertex index
			--   at the the left and right side of the polygon
			-- Iterate over all polygons that have a corner at this y coordinate:
			local polygonindexeswithcorner = ycoordinatetopolygonindexes:get(ycoordinate)
			do
				local activepolygonindex = 0
				while
					activepolygonindex
					< #activepolygons --[[ ROBLOX CHECK: operator '<' works only if either both arguments are strings or both are a number ]]
				do
					local activepolygon = activepolygons[activepolygonindex]
					local polygonindex = activepolygon.polygonindex
					if Boolean.toJSBoolean(polygonindexeswithcorner[polygonindex]) then
						-- this active polygon has a corner at this y coordinate:
						local vertices2d = polygonvertices2d[polygonindex]
						local numvertices = #vertices2d
						local newleftvertexindex = activepolygon.leftvertexindex
						local newrightvertexindex = activepolygon.rightvertexindex -- See if we need to increase leftvertexindex or decrease rightvertexindex:
						while true do
							local nextleftvertexindex = newleftvertexindex + 1
							if
								nextleftvertexindex
								>= numvertices --[[ ROBLOX CHECK: operator '>=' works only if either both arguments are strings or both are a number ]]
							then
								nextleftvertexindex = 0
							end
							if
								vertices2d[nextleftvertexindex][
									2 --[[ ROBLOX adaptation: added 1 to array index ]]
								] ~= ycoordinate
							then
								break
							end
							newleftvertexindex = nextleftvertexindex
						end
						local nextrightvertexindex = newrightvertexindex - 1
						if
							nextrightvertexindex
							< 0 --[[ ROBLOX CHECK: operator '<' works only if either both arguments are strings or both are a number ]]
						then
							nextrightvertexindex = numvertices - 1
						end
						if
							vertices2d[nextrightvertexindex][
								2 --[[ ROBLOX adaptation: added 1 to array index ]]
							] == ycoordinate
						then
							newrightvertexindex = nextrightvertexindex
						end
						if
							newleftvertexindex ~= activepolygon.leftvertexindex
							and newleftvertexindex == newrightvertexindex
						then
							-- We have increased leftvertexindex or decreased rightvertexindex, and now they point to the same vertex
							-- This means that this is the bottom point of the polygon. We'll remove it:
							Array.splice(activepolygons, activepolygonindex, 1) --[[ ROBLOX CHECK: check if 'activepolygons' is an Array ]]
							activepolygonindex -= 1
						else
							activepolygon.leftvertexindex = newleftvertexindex
							activepolygon.rightvertexindex = newrightvertexindex
							activepolygon.topleft = vertices2d[newleftvertexindex]
							activepolygon.topright = vertices2d[newrightvertexindex]
							local nextleftvertexindex = newleftvertexindex + 1
							if
								nextleftvertexindex
								>= numvertices --[[ ROBLOX CHECK: operator '>=' works only if either both arguments are strings or both are a number ]]
							then
								nextleftvertexindex = 0
							end
							activepolygon.bottomleft = vertices2d[nextleftvertexindex]
							nextrightvertexindex = newrightvertexindex - 1
							if
								nextrightvertexindex
								< 0 --[[ ROBLOX CHECK: operator '<' works only if either both arguments are strings or both are a number ]]
							then
								nextrightvertexindex = numvertices - 1
							end
							activepolygon.bottomright = vertices2d[nextrightvertexindex]
						end
					end -- if polygon has corner here
					activepolygonindex += 1
				end
			end -- for activepolygonindex
			local nextycoordinate
			if
				yindex
				>= #ycoordinates - 1 --[[ ROBLOX CHECK: operator '>=' works only if either both arguments are strings or both are a number ]]
			then
				-- last row, all polygons must be finished here:
				activepolygons = {}
				nextycoordinate = nil
			else
				-- yindex < #ycoordinates-1
				nextycoordinate = tonumber(ycoordinates[(yindex + 1)]) --Number()
				local middleycoordinate = 0.5 * (ycoordinate + nextycoordinate) -- update activepolygons by adding any polygons that start here:
				local startingpolygonindexes = topy2polygonindexes:get(ycoordinate)
				for polygonindexKey in startingpolygonindexes do
					local polygonindex = startingpolygonindexes[polygonindexKey]
					local vertices2d = polygonvertices2d[polygonindex]
					local numvertices = #vertices2d
					local topvertexindex = polygontopvertexindexes[polygonindex] -- the top of the polygon may be a horizontal line. In that case topvertexindex can point to any point on this line.
					-- Find the left and right topmost vertices which have the current y coordinate:
					local topleftvertexindex = topvertexindex
					while true do
						local i = topleftvertexindex + 1
						if
							i
							>= numvertices --[[ ROBLOX CHECK: operator '>=' works only if either both arguments are strings or both are a number ]]
						then
							i = 0
						end
						if
							vertices2d[i][
								2 --[[ ROBLOX adaptation: added 1 to array index ]]
							] ~= ycoordinate
						then
							break
						end
						if i == topvertexindex then
							break
						end -- should not happen, but just to prevent endless loops
						topleftvertexindex = i
					end
					local toprightvertexindex = topvertexindex
					while true do
						local i = toprightvertexindex - 1
						if
							i
							< 0 --[[ ROBLOX CHECK: operator '<' works only if either both arguments are strings or both are a number ]]
						then
							i = numvertices - 1
						end
						if
							vertices2d[i][
								2 --[[ ROBLOX adaptation: added 1 to array index ]]
							] ~= ycoordinate
						then
							break
						end
						if i == topleftvertexindex then
							break
						end -- should not happen, but just to prevent endless loops
						toprightvertexindex = i
					end
					local nextleftvertexindex = topleftvertexindex + 1
					if
						nextleftvertexindex
						>= numvertices --[[ ROBLOX CHECK: operator '>=' works only if either both arguments are strings or both are a number ]]
					then
						nextleftvertexindex = 0
					end
					local nextrightvertexindex = toprightvertexindex - 1
					if
						nextrightvertexindex
						< 0 --[[ ROBLOX CHECK: operator '<' works only if either both arguments are strings or both are a number ]]
					then
						nextrightvertexindex = numvertices - 1
					end
					local newactivepolygon = {
						polygonindex = polygonindex,
						leftvertexindex = topleftvertexindex,
						rightvertexindex = toprightvertexindex,
						topleft = vertices2d[topleftvertexindex],
						topright = vertices2d[toprightvertexindex],
						bottomleft = vertices2d[nextleftvertexindex],
						bottomright = vertices2d[nextrightvertexindex],
					}
					insertSorted(activepolygons, newactivepolygon, function(el1, el2)
						local x1 = interpolateBetween2DPointsForY(el1.topleft, el1.bottomleft, middleycoordinate)
						local x2 = interpolateBetween2DPointsForY(el2.topleft, el2.bottomleft, middleycoordinate)
						if
							x1
							> x2 --[[ ROBLOX CHECK: operator '>' works only if either both arguments are strings or both are a number ]]
						then
							return 1
						end
						if
							x1
							< x2 --[[ ROBLOX CHECK: operator '<' works only if either both arguments are strings or both are a number ]]
						then
							return -1
						end
						return 0
					end)
				end -- for(let polygonindex in startingpolygonindexes)
			end --  yindex < #ycoordinates-1
			-- Now activepolygons is up to date
			-- Build the output polygons for the next row in newoutpolygonrow:
			for activepolygonKey in activepolygons do
				local activepolygon = activepolygons[activepolygonKey]
				local x = interpolateBetween2DPointsForY(activepolygon.topleft, activepolygon.bottomleft, ycoordinate)
				local topleft = vec2.fromValues(x, ycoordinate)
				x = interpolateBetween2DPointsForY(activepolygon.topright, activepolygon.bottomright, ycoordinate)
				local topright = vec2.fromValues(x, ycoordinate)
				x = interpolateBetween2DPointsForY(activepolygon.topleft, activepolygon.bottomleft, nextycoordinate)
				local bottomleft = vec2.fromValues(x, nextycoordinate)
				x = interpolateBetween2DPointsForY(activepolygon.topright, activepolygon.bottomright, nextycoordinate)
				local bottomright = vec2.fromValues(x, nextycoordinate)
				local outpolygon = {
					topleft = topleft,
					topright = topright,
					bottomleft = bottomleft,
					bottomright = bottomright,
					leftline = line2.fromPoints(line2.create(), topleft, bottomleft),
					rightline = line2.fromPoints(line2.create(), bottomright, topright),
				}
				if
					#newoutpolygonrow
					> 0 --[[ ROBLOX CHECK: operator '>' works only if either both arguments are strings or both are a number ]]
				then
					local prevoutpolygon = newoutpolygonrow[(#newoutpolygonrow - 1)]
					local d1 = vec2.distance(outpolygon.topleft, prevoutpolygon.topright)
					local d2 = vec2.distance(outpolygon.bottomleft, prevoutpolygon.bottomright)
					if
						d1 < EPS --[[ ROBLOX CHECK: operator '<' works only if either both arguments are strings or both are a number ]]
						and d2 < EPS --[[ ROBLOX CHECK: operator '<' works only if either both arguments are strings or both are a number ]]
					then
						-- we can join this polygon with the one to the left:
						outpolygon.topleft = prevoutpolygon.topleft
						outpolygon.leftline = prevoutpolygon.leftline
						outpolygon.bottomleft = prevoutpolygon.bottomleft
						Array.splice(newoutpolygonrow, #newoutpolygonrow - 1, 1) --[[ ROBLOX CHECK: check if 'newoutpolygonrow' is an Array ]]
					end
				end
				table.insert(newoutpolygonrow, outpolygon) --[[ ROBLOX CHECK: check if 'newoutpolygonrow' is an Array ]]
			end -- for(activepolygon in activepolygons)
			if
				yindex
				> 0 --[[ ROBLOX CHECK: operator '>' works only if either both arguments are strings or both are a number ]]
			then
				-- try to match the new polygons against the previous row:
				local prevcontinuedindexes = Set.new()
				local matchedindexes = Set.new()
				do
					local i = 0
					while
						i
						< #newoutpolygonrow --[[ ROBLOX CHECK: operator '<' works only if either both arguments are strings or both are a number ]]
					do
						local thispolygon = newoutpolygonrow[i]
						do
							local ii = 0
							while
								ii
								< #prevoutpolygonrow --[[ ROBLOX CHECK: operator '<' works only if either both arguments are strings or both are a number ]]
							do
								if not Boolean.toJSBoolean(matchedindexes:has(ii)) then
									-- not already processed?
									-- We have a match if the sidelines are equal or if the top coordinates
									-- are on the sidelines of the previous polygon
									local prevpolygon = prevoutpolygonrow[ii]
									if
										vec2.distance(prevpolygon.bottomleft, thispolygon.topleft)
										< EPS --[[ ROBLOX CHECK: operator '<' works only if either both arguments are strings or both are a number ]]
									then
										if
											vec2.distance(prevpolygon.bottomright, thispolygon.topright)
											< EPS --[[ ROBLOX CHECK: operator '<' works only if either both arguments are strings or both are a number ]]
										then
											-- Yes, the top of this polygon matches the bottom of the previous:
											matchedindexes:add(ii) -- Now check if the joined polygon would remain convex:
											local v1 = line2.direction(thispolygon.leftline)
											local v2 = line2.direction(prevpolygon.leftline)
											local d1 = v1[
												1 --[[ ROBLOX adaptation: added 1 to array index ]]
											]
												- v2[
													1 --[[ ROBLOX adaptation: added 1 to array index ]]
												]
											local v3 = line2.direction(thispolygon.rightline)
											local v4 = line2.direction(prevpolygon.rightline)
											local d2 = v3[
												1 --[[ ROBLOX adaptation: added 1 to array index ]]
											]
												- v4[
													1 --[[ ROBLOX adaptation: added 1 to array index ]]
												]
											local leftlinecontinues = math.abs(d1) < EPS --[[ ROBLOX CHECK: operator '<' works only if either both arguments are strings or both are a number ]]
											local rightlinecontinues = math.abs(d2) < EPS --[[ ROBLOX CHECK: operator '<' works only if either both arguments are strings or both are a number ]]
											local leftlineisconvex = Boolean.toJSBoolean(leftlinecontinues)
													and leftlinecontinues
												or d1 >= 0 --[[ ROBLOX CHECK: operator '>=' works only if either both arguments are strings or both are a number ]]
											local rightlineisconvex = Boolean.toJSBoolean(rightlinecontinues)
													and rightlinecontinues
												or d2 >= 0 --[[ ROBLOX CHECK: operator '>=' works only if either both arguments are strings or both are a number ]]
											if
												Boolean.toJSBoolean(
													if Boolean.toJSBoolean(leftlineisconvex)
														then rightlineisconvex
														else leftlineisconvex
												)
											then
												-- yes, both sides have convex corners:
												-- This polygon will continue the previous polygon
												thispolygon.outpolygon = prevpolygon.outpolygon
												thispolygon.leftlinecontinues = leftlinecontinues
												thispolygon.rightlinecontinues = rightlinecontinues
												prevcontinuedindexes:add(ii)
											end
											break
										end
									end
								end -- if(!prevcontinuedindexes.has(ii))
								ii += 1
							end
						end -- for ii
						i += 1
					end
				end -- for i
				do
					local ii = 0
					while
						ii
						< #prevoutpolygonrow --[[ ROBLOX CHECK: operator '<' works only if either both arguments are strings or both are a number ]]
					do
						if not Boolean.toJSBoolean(prevcontinuedindexes:has(ii)) then
							-- polygon ends here
							-- Finish the polygon with the last point(s):
							local prevpolygon = prevoutpolygonrow[ii]
							table.insert(prevpolygon.outpolygon.rightpoints, prevpolygon.bottomright) --[[ ROBLOX CHECK: check if 'prevpolygon.outpolygon.rightpoints' is an Array ]]
							if
								vec2.distance(prevpolygon.bottomright, prevpolygon.bottomleft)
								> EPS --[[ ROBLOX CHECK: operator '>' works only if either both arguments are strings or both are a number ]]
							then
								-- polygon ends with a horizontal line:
								table.insert(prevpolygon.outpolygon.leftpoints, prevpolygon.bottomleft) --[[ ROBLOX CHECK: check if 'prevpolygon.outpolygon.leftpoints' is an Array ]]
							end -- reverse the left half so we get a counterclockwise circle:
							Array.reverse(prevpolygon.outpolygon.leftpoints) --[[ ROBLOX CHECK: check if 'prevpolygon.outpolygon.leftpoints' is an Array ]]
							local points2d =
								Array.concat(prevpolygon.outpolygon.rightpoints, prevpolygon.outpolygon.leftpoints) --[[ ROBLOX CHECK: check if 'prevpolygon.outpolygon.rightpoints' is an Array ]]
							local vertices3d = Array.map(points2d, function(point2d)
								return orthobasis:to3D(point2d)
							end) --[[ ROBLOX CHECK: check if 'points2d' is an Array ]]
							local polygon = poly3.fromPointsAndPlane(vertices3d, plane) -- TODO support shared
							-- if we let empty polygon out, next retesselate will crash
							if Boolean.toJSBoolean(#polygon.vertices) then
								table.insert(destpolygons, polygon) --[[ ROBLOX CHECK: check if 'destpolygons' is an Array ]]
							end
						end
						ii += 1
					end
				end
			end -- if(yindex > 0)
			do
				local i = 0
				while
					i
					< #newoutpolygonrow --[[ ROBLOX CHECK: operator '<' works only if either both arguments are strings or both are a number ]]
				do
					local thispolygon = newoutpolygonrow[i]
					if not Boolean.toJSBoolean(thispolygon.outpolygon) then
						-- polygon starts here:
						thispolygon.outpolygon = { leftpoints = {}, rightpoints = {} }
						table.insert(thispolygon.outpolygon.leftpoints, thispolygon.topleft) --[[ ROBLOX CHECK: check if 'thispolygon.outpolygon.leftpoints' is an Array ]]
						if
							vec2.distance(thispolygon.topleft, thispolygon.topright)
							> EPS --[[ ROBLOX CHECK: operator '>' works only if either both arguments are strings or both are a number ]]
						then
							-- we have a horizontal line at the top:
							table.insert(thispolygon.outpolygon.rightpoints, thispolygon.topright) --[[ ROBLOX CHECK: check if 'thispolygon.outpolygon.rightpoints' is an Array ]]
						end
					else
						-- continuation of a previous row
						if not Boolean.toJSBoolean(thispolygon.leftlinecontinues) then
							table.insert(thispolygon.outpolygon.leftpoints, thispolygon.topleft) --[[ ROBLOX CHECK: check if 'thispolygon.outpolygon.leftpoints' is an Array ]]
						end
						if not Boolean.toJSBoolean(thispolygon.rightlinecontinues) then
							table.insert(thispolygon.outpolygon.rightpoints, thispolygon.topright) --[[ ROBLOX CHECK: check if 'thispolygon.outpolygon.rightpoints' is an Array ]]
						end
					end
					i += 1
				end
			end
			prevoutpolygonrow = newoutpolygonrow
			yindex += 1
		end
	end -- for yindex
	return destpolygons
end
return reTesselateCoplanarPolygons
