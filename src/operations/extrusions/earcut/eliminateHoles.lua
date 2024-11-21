-- ROBLOX NOTE: no upstream
local Packages = game.ReplicatedStorage.Packages
local LuauPolyfill = require(Packages.LuauPolyfill)
local Array = LuauPolyfill.Array
local Boolean = LuauPolyfill.Boolean
local filterPoints, linkedPolygon, locallyInside, splitPolygon
do
	local ref = require("./linkedPolygon")
	filterPoints, linkedPolygon, locallyInside, splitPolygon =
		ref.filterPoints, ref.linkedPolygon, ref.locallyInside, ref.splitPolygon
end
local area, pointInTriangle
do
	local ref = require("./triangle")
	area, pointInTriangle = ref.area, ref.pointInTriangle
end
--[[
 * whether sector in vertex m contains sector in vertex p in the same coordinates
 ]]
local function sectorContainsSector(m, p)
	return area(m.prev, m, p.prev) < 0 --[[ ROBLOX CHECK: operator '<' works only if either both arguments are strings or both are a number ]]
		and area(p.next, m, m.next) < 0 --[[ ROBLOX CHECK: operator '<' works only if either both arguments are strings or both are a number ]]
end
--[[
 * David Eberly's algorithm for finding a bridge between hole and outer polygon
 ]]
local function findHoleBridge(hole, outerNode)
	local p = outerNode
	local hx = hole.x
	local hy = hole.y
	local qx = -math.huge
	local m -- find a segment intersected by a ray from the hole's leftmost point to the left
	-- segment's endpoint with lesser x will be potential connection point
	repeat
		if
			hy <= p.y --[[ ROBLOX CHECK: operator '<=' works only if either both arguments are strings or both are a number ]]
			and hy >= p.next.y --[[ ROBLOX CHECK: operator '>=' works only if either both arguments are strings or both are a number ]]
			and p.next.y ~= p.y
		then
			local x = p.x + (hy - p.y) * (p.next.x - p.x) / (p.next.y - p.y)
			if
				x <= hx --[[ ROBLOX CHECK: operator '<=' works only if either both arguments are strings or both are a number ]]
				and x > qx --[[ ROBLOX CHECK: operator '>' works only if either both arguments are strings or both are a number ]]
			then
				qx = x
				if x == hx then
					if hy == p.y then
						return p
					end
					if hy == p.next.y then
						return p.next
					end
				end
				m = if p.x
						< p.next.x --[[ ROBLOX CHECK: operator '<' works only if either both arguments are strings or both are a number ]]
					then p
					else p.next
			end
		end
		p = p.next
	until not (p ~= outerNode)
	if not Boolean.toJSBoolean(m) then
		return nil
	end
	if hx == qx then
		return m
	end -- hole touches outer segment; pick leftmost endpoint
	-- look for points inside the triangle of hole point, segment intersection and endpoint
	-- if there are no points found, we have a valid connection
	-- otherwise choose the point of the minimum angle with the ray as connection point
	local stop = m
	local mx = m.x
	local my = m.y
	local tanMin = math.huge
	p = m
	repeat
		if
			Boolean.toJSBoolean(
				hx >= p.x --[[ ROBLOX CHECK: operator '>=' works only if either both arguments are strings or both are a number ]]
					and p.x >= mx --[[ ROBLOX CHECK: operator '>=' works only if either both arguments are strings or both are a number ]]
					and hx ~= p.x
					and pointInTriangle(
						if hy
								< my --[[ ROBLOX CHECK: operator '<' works only if either both arguments are strings or both are a number ]]
							then hx
							else qx,
						hy,
						mx,
						my,
						if hy
								< my --[[ ROBLOX CHECK: operator '<' works only if either both arguments are strings or both are a number ]]
							then qx
							else hx,
						hy,
						p.x,
						p.y
					)
			)
		then
			local tan = math.abs(hy - p.y) / (hx - p.x) -- tangential
			if
				Boolean.toJSBoolean((function()
					local ref = locallyInside(p, hole)
					return if Boolean.toJSBoolean(ref)
						then tan < tanMin --[[ ROBLOX CHECK: operator '<' works only if either both arguments are strings or both are a number ]]
							or tan == tanMin
								and (
									p.x > m.x --[[ ROBLOX CHECK: operator '>' works only if either both arguments are strings or both are a number ]]
									or p.x == m.x and sectorContainsSector(m, p)
								)
						else ref
				end)())
			then
				m = p
				tanMin = tan
			end
		end
		p = p.next
	until not (p ~= stop)
	return m
end
--[[
 * find a bridge between vertices that connects hole with an outer ring and link it
 ]]
local function eliminateHole(hole, outerNode)
	local bridge = findHoleBridge(hole, outerNode)
	if not Boolean.toJSBoolean(bridge) then
		return outerNode
	end
	local bridgeReverse = splitPolygon(bridge, hole) -- filter colinear points around the cuts
	local filteredBridge = filterPoints(bridge, bridge.next)
	filterPoints(bridgeReverse, bridgeReverse.next) -- Check if input node was removed by the filtering
	return if outerNode == bridge then filteredBridge else outerNode
end
--[[
 * find the leftmost node of a polygon ring
 ]]
local function getLeftmost(start)
	local p = start
	local leftmost = start
	repeat
		if
			p.x < leftmost.x --[[ ROBLOX CHECK: operator '<' works only if either both arguments are strings or both are a number ]]
			or p.x == leftmost.x and p.y < leftmost.y --[[ ROBLOX CHECK: operator '<' works only if either both arguments are strings or both are a number ]]
		then
			leftmost = p
		end
		p = p.next
	until not (p ~= start)
	return leftmost
end
--[[
 * link every hole into the outer loop, producing a single-ring polygon without holes
 *
 * Original source from https://github.com/mapbox/earcut
 * Copyright (c) 2016 Mapbox
 ]]
local function eliminateHoles(data, holeIndices, outerNode, dim)
	local queue = {}
	do
		local i, len = 0, #holeIndices
		while
			i
			< len --[[ ROBLOX CHECK: operator '<' works only if either both arguments are strings or both are a number ]]
		do
			local start = holeIndices[i] * dim
			local end_ = if i
					< len - 1 --[[ ROBLOX CHECK: operator '<' works only if either both arguments are strings or both are a number ]]
				then holeIndices[(i + 1)] * dim
				else #data
			local list = linkedPolygon(data, start, end_, dim, false)
			if list == list.next then
				list.steiner = true
			end
			table.insert(queue, getLeftmost(list)) --[[ ROBLOX CHECK: check if 'queue' is an Array ]]
			i += 1
		end
	end
	Array.sort(queue, function(a, b)
		return a.x - b.x
	end) --[[ ROBLOX CHECK: check if 'queue' is an Array ]] -- compare X
	-- process holes from left to right
	do
		local i = 0
		while
			i
			< #queue --[[ ROBLOX CHECK: operator '<' works only if either both arguments are strings or both are a number ]]
		do
			outerNode = eliminateHole(queue[i], outerNode)
			outerNode = filterPoints(outerNode, outerNode.next)
			i += 1
		end
	end
	return outerNode
end
return eliminateHoles
