-- ROBLOX NOTE: no upstream

local LuauPolyfill = require("@Packages/LuauPolyfill")
local Array = LuauPolyfill.Array
local Boolean = LuauPolyfill.Boolean
local Map = LuauPolyfill.Map
local console = LuauPolyfill.console
local vec3 = require("../../../maths/vec3")
local create = require("./create")
--[[
 * Mend gaps in a 2D slice to make it a closed polygon
 ]]
local function repair(slice)
	if not Boolean.toJSBoolean(slice.edges) then
		return slice
	end
	local edges = slice.edges
	local vertexMap = Map.new() -- string key to vertex map
	local edgeCount = Map.new() -- count of (in - out) edges
	-- Remove self-edges
	edges = Array.filter(edges, function(e)
		return not Boolean.toJSBoolean(vec3.equals(
			e[
				1 --[[ ROBLOX adaptation: added 1 to array index ]]
			],
			e[
				2 --[[ ROBLOX adaptation: added 1 to array index ]]
			]
		))
	end) --[[ ROBLOX CHECK: check if 'edges' is an Array ]] -- build vertex and edge count maps
	Array.forEach(edges, function(edge)
		local inKey = tostring(edge[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		])
		local outKey = tostring(edge[
			2 --[[ ROBLOX adaptation: added 1 to array index ]]
		])
		vertexMap:set(
			inKey,
			edge[
				1 --[[ ROBLOX adaptation: added 1 to array index ]]
			]
		)
		vertexMap:set(
			outKey,
			edge[
				2 --[[ ROBLOX adaptation: added 1 to array index ]]
			]
		)
		edgeCount:set(inKey, (function()
			local ref = edgeCount:get(inKey)
			return Boolean.toJSBoolean(ref) and ref or 0
		end)() + 1) -- in
		edgeCount:set(outKey, (function()
			local ref = edgeCount:get(outKey)
			return Boolean.toJSBoolean(ref) and ref or 0
		end)() - 1) -- out
	end) --[[ ROBLOX CHECK: check if 'edges' is an Array ]] -- find vertices which are missing in or out edges
	local missingIn = {}
	local missingOut = {}
	Array.forEach(edgeCount, function(count, vertex)
		if
			count
			< 0 --[[ ROBLOX CHECK: operator '<' works only if either both arguments are strings or both are a number ]]
		then
			table.insert(missingIn, vertex) --[[ ROBLOX CHECK: check if 'missingIn' is an Array ]]
		end
		if
			count
			> 0 --[[ ROBLOX CHECK: operator '>' works only if either both arguments are strings or both are a number ]]
		then
			table.insert(missingOut, vertex) --[[ ROBLOX CHECK: check if 'missingOut' is an Array ]]
		end
	end) --[[ ROBLOX CHECK: check if 'edgeCount' is an Array ]] -- pairwise distance of bad vertices
	Array.forEach(missingIn, function(key1)
		local v1 = vertexMap:get(key1) -- find the closest vertex that is missing an out edge
		local bestDistance = math.huge
		local bestReplacement
		Array.forEach(missingOut, function(key2)
			local v2 = vertexMap:get(key2)
			local distance = vec3.distance(v1, v2)
			if
				distance
				< bestDistance --[[ ROBLOX CHECK: operator '<' works only if either both arguments are strings or both are a number ]]
			then
				bestDistance = distance
				bestReplacement = v2
			end
		end) --[[ ROBLOX CHECK: check if 'missingOut' is an Array ]]
		console.warn(
			("slice.repair: repairing vertex gap %s to %s distance %s"):format(
				tostring(v1),
				tostring(bestReplacement),
				tostring(bestDistance)
			)
		) -- merge broken vertices
		edges = Array.map(edges, function(edge)
			if
				tostring(edge[
					1 --[[ ROBLOX adaptation: added 1 to array index ]]
				]) == key1
			then
				return {
					bestReplacement,
					edge[
						2 --[[ ROBLOX adaptation: added 1 to array index ]]
					],
				}
			end
			if
				tostring(edge[
					2 --[[ ROBLOX adaptation: added 1 to array index ]]
				]) == key1
			then
				return {
					edge[
						1 --[[ ROBLOX adaptation: added 1 to array index ]]
					],
					bestReplacement,
				}
			end
			return edge
		end) --[[ ROBLOX CHECK: check if 'edges' is an Array ]]
	end) --[[ ROBLOX CHECK: check if 'missingIn' is an Array ]]
	return create(edges)
end
return repair
