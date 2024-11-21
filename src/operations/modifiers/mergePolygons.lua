-- ROBLOX NOTE: no upstream
local Packages = game.ReplicatedStorage.Packages
local LuauPolyfill = require(Packages.LuauPolyfill)
local Array = LuauPolyfill.Array
local Boolean = LuauPolyfill.Boolean
local Map = LuauPolyfill.Map
local aboutEqualNormals = require("../../maths/utils/aboutEqualNormals")
local vec3 = require("../../maths/vec3")
local poly3 = require("../../geometries/poly3") -- create a set of edges from the given polygon, and link the edges as well
local function createEdges(polygon)
	local points = poly3.toPoints(polygon)
	local edges = {}
	do
		local i = 0
		while
			i
			< #points --[[ ROBLOX CHECK: operator '<' works only if either both arguments are strings or both are a number ]]
		do
			local j = (i + 1) % #points
			local edge = { v1 = points[i], v2 = points[j] }
			table.insert(edges, edge) --[[ ROBLOX CHECK: check if 'edges' is an Array ]]
			i += 1
		end
	end -- link the edges together
	do
		local i = 0
		while
			i
			< #edges --[[ ROBLOX CHECK: operator '<' works only if either both arguments are strings or both are a number ]]
		do
			local j = (i + 1) % #points
			edges[i].next = edges[j]
			edges[j].prev = edges[i]
			i += 1
		end
	end
	return edges
end
local function insertEdge(edges, edge)
	local key = ("%s:%s"):format(tostring(edge.v1), tostring(edge.v2))
	edges:set(key, edge)
end
local function deleteEdge(edges, edge)
	local key = ("%s:%s"):format(tostring(edge.v1), tostring(edge.v2))
	edges:delete(key)
end
local function findOppositeEdge(edges, edge)
	local key = ("%s:%s"):format(tostring(edge.v2), tostring(edge.v1)) -- NOTE: OPPOSITE OF INSERT KEY
	return edges:get(key)
end
local v1 = vec3.create()
local v2 = vec3.create()
local function calculateAngle(prevpoint, point, nextpoint, normal)
	local d0 = vec3.subtract(v1, point, prevpoint)
	local d1 = vec3.subtract(v2, nextpoint, point)
	vec3.cross(d0, d0, d1)
	return vec3.dot(d0, normal)
end
-- calculate the two adjoining angles between the opposing edges
local function calculateAnglesBetween(current, opposite, normal)
	local v0 = current.prev.v1
	local v1 = current.prev.v2
	local v2 = opposite.next.v2
	local angle1 = calculateAngle(v0, v1, v2, normal)
	v0 = opposite.prev.v1
	v1 = opposite.prev.v2
	v2 = current.next.v2
	local angle2 = calculateAngle(v0, v1, v2, normal)
	return { angle1, angle2 }
end
-- create a polygon starting from the given edge (if possible)
local function createPolygonAnd(edge)
	local polygon
	local points = {}
	while Boolean.toJSBoolean(edge.next) do
		local next_ = edge.next
		table.insert(points, edge.v1) --[[ ROBLOX CHECK: check if 'points' is an Array ]]
		edge.v1 = nil
		edge.v2 = nil
		edge.next = nil
		edge.prev = nil
		edge = next_
	end
	if
		#points
		> 0 --[[ ROBLOX CHECK: operator '>' works only if either both arguments are strings or both are a number ]]
	then
		polygon = poly3.create(points)
	end
	return polygon
end
--[[
 * Merge COPLANAR polygons that share common edges.
 * @param {poly3[]} sourcepolygons - list of polygons
 * @returns {poly3[]} new set of polygons
 ]]
local function mergeCoplanarPolygons(sourcepolygons)
	if
		#sourcepolygons
		< 2 --[[ ROBLOX CHECK: operator '<' works only if either both arguments are strings or both are a number ]]
	then
		return sourcepolygons
	end
	local normal = sourcepolygons[
		1 --[[ ROBLOX adaptation: added 1 to array index ]]
	].plane
	local polygons = Array.slice(sourcepolygons) --[[ ROBLOX CHECK: check if 'sourcepolygons' is an Array ]]
	local edgeList = Map.new()
	while
		#polygons
		> 0 --[[ ROBLOX CHECK: operator '>' works only if either both arguments are strings or both are a number ]]
	do
		-- NOTE: the length of polygons WILL change
		local polygon = table.remove(polygons, 1) --[[ ROBLOX CHECK: check if 'polygons' is an Array ]]
		local edges = createEdges(polygon)
		do
			local i = 0
			while
				i
				< #edges --[[ ROBLOX CHECK: operator '<' works only if either both arguments are strings or both are a number ]]
			do
				local current = edges[i]
				local opposite = findOppositeEdge(edgeList, current)
				if Boolean.toJSBoolean(opposite) then
					local angles = calculateAnglesBetween(current, opposite, normal)
					if
						angles[
							1 --[[ ROBLOX adaptation: added 1 to array index ]]
						] >= 0 --[[ ROBLOX CHECK: operator '>=' works only if either both arguments are strings or both are a number ]]
						and angles[
							2 --[[ ROBLOX adaptation: added 1 to array index ]]
						] >= 0 --[[ ROBLOX CHECK: operator '>=' works only if either both arguments are strings or both are a number ]]
					then
						local edge1 = opposite.next
						local edge2 = current.next -- adjust the edges, linking together opposing polygons
						current.prev.next = opposite.next
						current.next.prev = opposite.prev
						opposite.prev.next = current.next
						opposite.next.prev = current.prev -- remove the opposing edges
						current.v1 = nil
						current.v2 = nil
						current.next = nil
						current.prev = nil
						deleteEdge(edgeList, opposite)
						opposite.v1 = nil
						opposite.v2 = nil
						opposite.next = nil
						opposite.prev = nil
						local function mergeEdges(list, e1, e2)
							local newedge = { v1 = e2.v1, v2 = e1.v2, next = e1.next, prev = e2.prev } -- link in newedge
							e2.prev.next = newedge
							e1.next.prev = newedge -- remove old edges
							deleteEdge(list, e1)
							e1.v1 = nil
							e1.v2 = nil
							e1.next = nil
							e1.prev = nil
							deleteEdge(list, e2)
							e2.v1 = nil
							e2.v2 = nil
							e2.next = nil
							e2.prev = nil
						end
						if
							angles[
								1 --[[ ROBLOX adaptation: added 1 to array index ]]
							] == 0.0
						then
							mergeEdges(edgeList, edge1, edge1.prev)
						end
						if
							angles[
								2 --[[ ROBLOX adaptation: added 1 to array index ]]
							] == 0.0
						then
							mergeEdges(edgeList, edge2, edge2.prev)
						end
					end
				else
					if Boolean.toJSBoolean(current.next) then
						insertEdge(edgeList, current)
					end
				end
				i += 1
			end
		end
	end -- build a set of polygons from the remaining edges
	local destpolygons = {}
	Array.forEach(edgeList, function(edge)
		local polygon = createPolygonAnd(edge)
		if Boolean.toJSBoolean(polygon) then
			table.insert(destpolygons, polygon) --[[ ROBLOX CHECK: check if 'destpolygons' is an Array ]]
		end
	end) --[[ ROBLOX CHECK: check if 'edgeList' is an Array ]]
	edgeList:clear()
	return destpolygons
end
local function coplanar(plane1, plane2)
	-- expect the same distance from the origin, within tolerance
	if
		math.abs(plane1[
			4 --[[ ROBLOX adaptation: added 1 to array index ]]
		] - plane2[
			4 --[[ ROBLOX adaptation: added 1 to array index ]]
		])
		< 0.00000015 --[[ ROBLOX CHECK: operator '<' works only if either both arguments are strings or both are a number ]]
	then
		return aboutEqualNormals(plane1, plane2)
	end
	return false
end
local function mergePolygons(epsilon, polygons)
	local polygonsPerPlane = {} -- elements: [plane, [poly3...]]
	Array.forEach(polygons, function(polygon)
		local mapping = Array.find(polygonsPerPlane, function(element)
			return coplanar(
				element[
					1 --[[ ROBLOX adaptation: added 1 to array index ]]
				],
				poly3.plane(polygon)
			)
		end) --[[ ROBLOX CHECK: check if 'polygonsPerPlane' is an Array ]]
		if Boolean.toJSBoolean(mapping) then
			local polygons = mapping[
				2 --[[ ROBLOX adaptation: added 1 to array index ]]
			]
			table.insert(polygons, polygon) --[[ ROBLOX CHECK: check if 'polygons' is an Array ]]
		else
			table.insert(polygonsPerPlane, { poly3.plane(polygon), { polygon } }) --[[ ROBLOX CHECK: check if 'polygonsPerPlane' is an Array ]]
		end
	end) --[[ ROBLOX CHECK: check if 'polygons' is an Array ]]
	local destpolygons = {}
	Array.forEach(polygonsPerPlane, function(mapping)
		local sourcepolygons = mapping[
			2 --[[ ROBLOX adaptation: added 1 to array index ]]
		]
		local retesselayedpolygons = mergeCoplanarPolygons(sourcepolygons)
		destpolygons = Array.concat(destpolygons, retesselayedpolygons) --[[ ROBLOX CHECK: check if 'destpolygons' is an Array ]]
	end) --[[ ROBLOX CHECK: check if 'polygonsPerPlane' is an Array ]]
	return destpolygons
end
return mergePolygons
