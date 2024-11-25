-- ROBLOX NOTE: no upstream

local LuauPolyfill = require("@Packages/LuauPolyfill")
local Array = LuauPolyfill.Array
local Boolean = LuauPolyfill.Boolean
local Error = LuauPolyfill.Error
local Map = LuauPolyfill.Map
local vec2 = require("../../maths/vec2")
local toSides = require("./toSides")
--[[
 * Create a list of edges which SHARE vertices.
 * This allows the edges to be traversed in order.
 ]]
local function toSharedVertices(sides)
	local unique = Map.new() -- {key: vertex}
	local function getUniqueVertex(vertex)
		local key = tostring(vertex)
		if Boolean.toJSBoolean(unique:has(key)) then
			return unique:get(key)
		else
			unique:set(key, vertex)
			return vertex
		end
	end
	return Array.map(sides, function(side)
		return Array.map(side, getUniqueVertex) --[[ ROBLOX CHECK: check if 'side' is an Array ]]
	end) --[[ ROBLOX CHECK: check if 'sides' is an Array ]]
end
--[[
 * Convert a list of sides into a map from vertex to edges.
 ]]
local function toVertexMap(sides)
	local vertexMap = Map.new() -- first map to edges with shared vertices
	local edges = toSharedVertices(sides) -- construct adjacent edges map
	Array.forEach(edges, function(edge)
		if
			Boolean.toJSBoolean(vertexMap:has(edge[
				1 --[[ ROBLOX adaptation: added 1 to array index ]]
			]))
		then
			table.insert(
				vertexMap:get(edge[
					1 --[[ ROBLOX adaptation: added 1 to array index ]]
				]),
				edge
			) --[[ ROBLOX CHECK: check if 'vertexMap.get(edge[0])' is an Array ]]
		else
			vertexMap:set(
				edge[
					1 --[[ ROBLOX adaptation: added 1 to array index ]]
				],
				{ edge }
			)
		end
	end) --[[ ROBLOX CHECK: check if 'edges' is an Array ]]
	return vertexMap
end
-- find the first counter-clockwise edge from startSide and pop from nextSides
local function popNextSide(startSide, nextSides)
	if #nextSides == 1 then
		return table.remove(nextSides) --[[ ROBLOX CHECK: check if 'nextSides' is an Array ]]
	end
	local v0 = vec2.create()
	local startAngle = vec2.angleDegrees(vec2.subtract(
		v0,
		startSide[
			2 --[[ ROBLOX adaptation: added 1 to array index ]]
		],
		startSide[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		]
	))
	local bestAngle
	local bestIndex
	Array.forEach(nextSides, function(nextSide, index)
		local nextAngle = vec2.angleDegrees(vec2.subtract(
			v0,
			nextSide[
				2 --[[ ROBLOX adaptation: added 1 to array index ]]
			],
			nextSide[
				1 --[[ ROBLOX adaptation: added 1 to array index ]]
			]
		))
		local angle = nextAngle - startAngle
		if
			angle
			< -180 --[[ ROBLOX CHECK: operator '<' works only if either both arguments are strings or both are a number ]]
		then
			angle += 360
		end
		if
			angle
			>= 180 --[[ ROBLOX CHECK: operator '>=' works only if either both arguments are strings or both are a number ]]
		then
			angle -= 360
		end
		if
			bestIndex == nil
			or angle > bestAngle --[[ ROBLOX CHECK: operator '>' works only if either both arguments are strings or both are a number ]]
		then
			bestIndex = index
			bestAngle = angle
		end
	end) --[[ ROBLOX CHECK: check if 'nextSides' is an Array ]]
	local nextSide = nextSides[bestIndex]
	Array.splice(nextSides, bestIndex, 1) --[[ ROBLOX CHECK: check if 'nextSides' is an Array ]] -- remove side from list
	return nextSide
end
--[[*
 * Create the outline(s) of the given geometry.
 * @param {geom2} geometry - geometry to create outlines from
 * @returns {Array} an array of outlines, where each outline is an array of ordered points
 * @alias module:modeling/geometries/geom2.toOutlines
 *
 * @example
 * let geometry = subtract(rectangle({size: [5, 5]}), rectangle({size: [3, 3]}))
 * let outlines = toOutlines(geometry) // returns two outlines
 ]]
local function toOutlines(geometry)
	local vertexMap = toVertexMap(toSides(geometry)) -- {vertex: [edges]}
	local outlines = {}
	while true do
		local startSide
		for _, ref in vertexMap do
			local vertex, edges = table.unpack(ref, 1, 2)
			startSide = table.remove(edges, 1) --[[ ROBLOX CHECK: check if 'edges' is an Array ]]
			if not Boolean.toJSBoolean(startSide) then
				vertexMap:delete(vertex)
				continue
			end
			break
		end
		if startSide == nil then
			break
		end -- all starting sides have been visited
		local connectedVertexPoints = {}
		local startVertex = startSide[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		]
		while true do
			table.insert(
				connectedVertexPoints,
				startSide[
					1 --[[ ROBLOX adaptation: added 1 to array index ]]
				]
			) --[[ ROBLOX CHECK: check if 'connectedVertexPoints' is an Array ]]
			local nextVertex = startSide[
				2 --[[ ROBLOX adaptation: added 1 to array index ]]
			]
			if nextVertex == startVertex then
				break
			end -- the outline has been closed
			local nextPossibleSides = vertexMap:get(nextVertex)
			if not Boolean.toJSBoolean(nextPossibleSides) then
				error(Error.new(("geometry is not closed at vertex %s"):format(tostring(nextVertex))))
			end
			local nextSide = popNextSide(startSide, nextPossibleSides)
			if #nextPossibleSides == 0 then
				vertexMap:delete(nextVertex)
			end
			startSide = nextSide
		end -- inner loop
		-- due to the logic of fromPoints()
		-- move the first point to the last
		if
			#connectedVertexPoints
			> 0 --[[ ROBLOX CHECK: operator '>' works only if either both arguments are strings or both are a number ]]
		then
			table.insert(
				connectedVertexPoints,
				table.remove(connectedVertexPoints, 1) --[[ ROBLOX CHECK: check if 'connectedVertexPoints' is an Array ]]
			) --[[ ROBLOX CHECK: check if 'connectedVertexPoints' is an Array ]]
		end
		table.insert(outlines, connectedVertexPoints) --[[ ROBLOX CHECK: check if 'outlines' is an Array ]]
	end -- outer loop
	vertexMap:clear()
	return outlines
end

return toOutlines
