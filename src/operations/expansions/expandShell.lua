-- ROBLOX NOTE: no upstream
local Packages = game.ReplicatedStorage.Packages
local LuauPolyfill = require(Packages.LuauPolyfill)
local Array = LuauPolyfill.Array
local Boolean = LuauPolyfill.Boolean
local Map = LuauPolyfill.Map
local Object = LuauPolyfill.Object
local EPS, TAU
do
	local ref = require("../../maths/constants")
	EPS, TAU = ref.EPS, ref.TAU
end
local mat4 = require("../../maths/mat4")
local vec3 = require("../../maths/vec3")
local fnNumberSort = require("../../utils/fnNumberSort")
local geom3 = require("../../geometries/geom3")
local poly3 = require("../../geometries/poly3")
local sphere = require("../../primitives/sphere")
local retessellate = require("../modifiers/retessellate")
local unionGeom3Sub = require("../booleans/unionGeom3Sub")
local extrudePolygon = require("./extrudePolygon")
--[[
 * Collect all planes adjacent to each vertex
 ]]
local function mapPlaneToVertex(map, vertex, plane)
	local key = tostring(vertex)
	if not Boolean.toJSBoolean(map:has(key)) then
		local entry = { vertex, { plane } }
		map:set(key, entry)
	else
		local planes = map:get(key)[
			2 --[[ ROBLOX adaptation: added 1 to array index ]]
		]
		table.insert(planes, plane) --[[ ROBLOX CHECK: check if 'planes' is an Array ]]
	end
end
--[[
 * Collect all planes adjacent to each edge.
 * Combine undirected edges, no need for duplicate cylinders.
 ]]
local function mapPlaneToEdge(map, edge, plane)
	local key0 = tostring(edge[
		1 --[[ ROBLOX adaptation: added 1 to array index ]]
	])
	local key1 = tostring(edge[
		2 --[[ ROBLOX adaptation: added 1 to array index ]]
	]) -- Sort keys to make edges undirected
	local key = if key0
			< key1 --[[ ROBLOX CHECK: operator '<' works only if either both arguments are strings or both are a number ]]
		then ("%s,%s"):format(tostring(key0), tostring(key1))
		else ("%s,%s"):format(tostring(key1), tostring(key0))
	if not Boolean.toJSBoolean(map:has(key)) then
		local entry = { edge, { plane } }
		map:set(key, entry)
	else
		local planes = map:get(key)[
			2 --[[ ROBLOX adaptation: added 1 to array index ]]
		]
		table.insert(planes, plane) --[[ ROBLOX CHECK: check if 'planes' is an Array ]]
	end
end
local function addUniqueAngle(map, angle)
	local i = Array.findIndex(map, function(item)
		return item == angle
	end) --[[ ROBLOX CHECK: check if 'map' is an Array ]]
	if
		i < 0 --[[ ROBLOX CHECK: operator '<' works only if either both arguments are strings or both are a number ]]
	then
		table.insert(map, angle) --[[ ROBLOX CHECK: check if 'map' is an Array ]]
	end
end
--[[
 * Create the expanded shell of the solid:
 * All faces are extruded to 2 times delta
 * Cylinders are constructed around every side
 * Spheres are placed on every vertex
 * the result is a true expansion of the solid
 * @param  {Number} delta
 * @param  {Integer} segments
 ]]
local function expandShell(options, geometry)
	local defaults = { delta = 1, segments = 12 }
	local delta, segments
	do
		local ref = Object.assign({}, defaults, options)
		delta, segments = ref.delta, ref.segments
	end
	local result = geom3.create()
	local vertices2planes = Map.new() -- {vertex: [vertex, [plane, ...]]}
	local edges2planes = Map.new() -- {edge: [[vertex, vertex], [plane, ...]]}
	local v1 = vec3.create()
	local v2 = vec3.create() -- loop through the polygons
	-- - extruded the polygon, and add to the composite result
	-- - add the plane to the unique vertice map
	-- - add the plane to the unique edge map
	local polygons = geom3.toPolygons(geometry)
	Array.forEach(polygons, function(polygon, index)
		local extrudevector = vec3.scale(vec3.create(), poly3.plane(polygon), 2 * delta)
		local translatedpolygon = poly3.transform(
			mat4.fromTranslation(mat4.create(), vec3.scale(vec3.create(), extrudevector, -0.5)),
			polygon
		)
		local extrudedface = extrudePolygon(extrudevector, translatedpolygon)
		result = unionGeom3Sub(result, extrudedface)
		local vertices = polygon.vertices
		do
			local i = 0
			while
				i
				< #vertices --[[ ROBLOX CHECK: operator '<' works only if either both arguments are strings or both are a number ]]
			do
				mapPlaneToVertex(vertices2planes, vertices[i], poly3.plane(polygon))
				local j = (i + 1) % #vertices
				local edge = { vertices[i], vertices[j] }
				mapPlaneToEdge(edges2planes, edge, poly3.plane(polygon))
				i += 1
			end
		end
	end) --[[ ROBLOX CHECK: check if 'polygons' is an Array ]] -- now construct a cylinder on every side
	-- The cylinder is always an approximation of a true cylinder, having polygons
	-- around the sides. We will make sure though that the cylinder will have an edge at every
	-- face that touches this side. This ensures that we will get a smooth fill even
	-- if two edges are at, say, 10 degrees and the segments is low.
	Array.forEach(edges2planes, function(item)
		local edge = item[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		]
		local planes = item[
			2 --[[ ROBLOX adaptation: added 1 to array index ]]
		]
		local startpoint = edge[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		]
		local endpoint = edge[
			2 --[[ ROBLOX adaptation: added 1 to array index ]]
		] -- our x,y and z vectors:
		local zbase = vec3.subtract(vec3.create(), endpoint, startpoint)
		vec3.normalize(zbase, zbase)
		local xbase = planes[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		]
		local ybase = vec3.cross(vec3.create(), xbase, zbase) -- make a list of angles that the cylinder should traverse:
		local angles = {} -- first of all equally spaced around the cylinder:
		do
			local i = 0
			while
				i
				< segments --[[ ROBLOX CHECK: operator '<' works only if either both arguments are strings or both are a number ]]
			do
				addUniqueAngle(angles, i * TAU / segments)
				i += 1
			end
		end -- and also at every normal of all touching planes:
		do
			local i, iMax = 0, #planes
			while
				i
				< iMax --[[ ROBLOX CHECK: operator '<' works only if either both arguments are strings or both are a number ]]
			do
				local planenormal = planes[i]
				local si = vec3.dot(ybase, planenormal)
				local co = vec3.dot(xbase, planenormal)
				local angle = math.atan2(si, co)
				if
					angle
					< 0 --[[ ROBLOX CHECK: operator '<' works only if either both arguments are strings or both are a number ]]
				then
					angle += TAU
				end
				addUniqueAngle(angles, angle)
				angle = math.atan2(-si, -co)
				if
					angle
					< 0 --[[ ROBLOX CHECK: operator '<' works only if either both arguments are strings or both are a number ]]
				then
					angle += TAU
				end
				addUniqueAngle(angles, angle)
				i += 1
			end
		end -- this will result in some duplicate angles but we will get rid of those later.
		angles = Array.sort(angles, fnNumberSort) --[[ ROBLOX CHECK: check if 'angles' is an Array ]] -- Now construct the cylinder by traversing all angles:
		local numangles = #angles
		local prevp1
		local prevp2
		local startfacevertices = {}
		local endfacevertices = {}
		local polygons = {}
		do
			local i = -1
			while
				i
				< numangles --[[ ROBLOX CHECK: operator '<' works only if either both arguments are strings or both are a number ]]
			do
				local angle = angles[
					tostring(
						if i
								< 0 --[[ ROBLOX CHECK: operator '<' works only if either both arguments are strings or both are a number ]]
							then i + numangles
							else i
					)
				]
				local si = math.sin(angle)
				local co = math.cos(angle)
				vec3.scale(v1, xbase, co * delta)
				vec3.scale(v2, ybase, si * delta)
				vec3.add(v1, v1, v2)
				local p1 = vec3.add(vec3.create(), startpoint, v1)
				local p2 = vec3.add(vec3.create(), endpoint, v1)
				local skip = false
				if
					i
					>= 0 --[[ ROBLOX CHECK: operator '>=' works only if either both arguments are strings or both are a number ]]
				then
					if
						vec3.distance(p1, prevp1)
						< EPS --[[ ROBLOX CHECK: operator '<' works only if either both arguments are strings or both are a number ]]
					then
						skip = true
					end
				end
				if not Boolean.toJSBoolean(skip) then
					if
						i
						>= 0 --[[ ROBLOX CHECK: operator '>=' works only if either both arguments are strings or both are a number ]]
					then
						table.insert(startfacevertices, p1) --[[ ROBLOX CHECK: check if 'startfacevertices' is an Array ]]
						table.insert(endfacevertices, p2) --[[ ROBLOX CHECK: check if 'endfacevertices' is an Array ]]
						local points = { prevp2, p2, p1, prevp1 }
						local polygon = poly3.create(points)
						table.insert(polygons, polygon) --[[ ROBLOX CHECK: check if 'polygons' is an Array ]]
					end
					prevp1 = p1
					prevp2 = p2
				end
				i += 1
			end
		end
		Array.reverse(endfacevertices) --[[ ROBLOX CHECK: check if 'endfacevertices' is an Array ]]
		table.insert(polygons, poly3.create(startfacevertices)) --[[ ROBLOX CHECK: check if 'polygons' is an Array ]]
		table.insert(polygons, poly3.create(endfacevertices)) --[[ ROBLOX CHECK: check if 'polygons' is an Array ]]
		local cylinder = geom3.create(polygons)
		result = unionGeom3Sub(result, cylinder)
	end) --[[ ROBLOX CHECK: check if 'edges2planes' is an Array ]] -- build spheres at each unique vertex
	-- We will try to set the x and z axis to the normals of 2 planes
	-- This will ensure that our sphere tesselation somewhat matches 2 planes
	Array.forEach(vertices2planes, function(item)
		local vertex = item[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		]
		local planes = item[
			2 --[[ ROBLOX adaptation: added 1 to array index ]]
		] -- use the first normal to be the x axis of our sphere:
		local xaxis = planes[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		] -- and find a suitable z axis. We will use the normal which is most perpendicular to the x axis:
		local bestzaxis = nil
		local bestzaxisorthogonality = 0
		do
			local i = 1
			while
				i
				< #planes --[[ ROBLOX CHECK: operator '<' works only if either both arguments are strings or both are a number ]]
			do
				local normal = planes[i]
				local cross = vec3.cross(v1, xaxis, normal)
				local crosslength = vec3.length(cross)
				if
					crosslength
					> 0.05 --[[ ROBLOX CHECK: operator '>' works only if either both arguments are strings or both are a number ]]
				then
					-- FIXME why 0.05?
					if
						crosslength
						> bestzaxisorthogonality --[[ ROBLOX CHECK: operator '>' works only if either both arguments are strings or both are a number ]]
					then
						bestzaxisorthogonality = crosslength
						bestzaxis = normal
					end
				end
				i += 1
			end
		end
		if not Boolean.toJSBoolean(bestzaxis) then
			bestzaxis = vec3.orthogonal(v1, xaxis)
		end
		local yaxis = vec3.cross(v1, xaxis, bestzaxis)
		vec3.normalize(yaxis, yaxis)
		local zaxis = vec3.cross(v2, yaxis, xaxis)
		local corner = sphere({
			center = {
				vertex[
					1 --[[ ROBLOX adaptation: added 1 to array index ]]
				],
				vertex[
					2 --[[ ROBLOX adaptation: added 1 to array index ]]
				],
				vertex[
					3 --[[ ROBLOX adaptation: added 1 to array index ]]
				],
			},
			radius = delta,
			segments = segments,
			axes = { xaxis, yaxis, zaxis },
		})
		result = unionGeom3Sub(result, corner)
	end) --[[ ROBLOX CHECK: check if 'vertices2planes' is an Array ]]
	return retessellate(result)
end
return expandShell
