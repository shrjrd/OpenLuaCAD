-- ROBLOX NOTE: no upstream

local LuauPolyfill = require("@Packages/LuauPolyfill")
local Array = LuauPolyfill.Array
local Boolean = LuauPolyfill.Boolean
local EPS = require("../../../maths/constants").EPS
local plane = require("../../../maths/plane")
local vec3 = require("../../../maths/vec3")
local poly3 = require("../../../geometries/poly3")
local splitLineSegmentByPlane = require("./splitLineSegmentByPlane") -- Returns object:
-- .type:
--   0: coplanar-front
--   1: coplanar-back
--   2: front
--   3: back
--   4: spanning
-- In case the polygon is spanning, returns:
-- .front: a Polygon3 of the front part
-- .back: a Polygon3 of the back part
local function splitPolygonByPlane(splane, polygon)
	local result = { type = nil, front = nil, back = nil } -- cache in local lets (speedup):
	local vertices = polygon.vertices
	local numvertices = #vertices
	local pplane = poly3.plane(polygon)
	if Boolean.toJSBoolean(plane.equals(pplane, splane)) then
		result.type = 0
	else
		local hasfront = false
		local hasback = false
		local vertexIsBack = {}
		local MINEPS = -EPS
		do
			local i = 0
			while
				i
				< numvertices --[[ ROBLOX CHECK: operator '<' works only if either both arguments are strings or both are a number ]]
			do
				local t = vec3.dot(splane, vertices[i])
					- splane[
						4 --[[ ROBLOX adaptation: added 1 to array index ]]
					]
				local isback = t < MINEPS --[[ ROBLOX CHECK: operator '<' works only if either both arguments are strings or both are a number ]]
				table.insert(vertexIsBack, isback) --[[ ROBLOX CHECK: check if 'vertexIsBack' is an Array ]]
				if
					t
					> EPS --[[ ROBLOX CHECK: operator '>' works only if either both arguments are strings or both are a number ]]
				then
					hasfront = true
				end
				if
					t
					< MINEPS --[[ ROBLOX CHECK: operator '<' works only if either both arguments are strings or both are a number ]]
				then
					hasback = true
				end
				i += 1
			end
		end
		if not Boolean.toJSBoolean(hasfront) and not Boolean.toJSBoolean(hasback) then
			-- all points coplanar
			local t = vec3.dot(splane, pplane)
			result.type = if t
					>= 0 --[[ ROBLOX CHECK: operator '>=' works only if either both arguments are strings or both are a number ]]
				then 0
				else 1
		elseif not Boolean.toJSBoolean(hasback) then
			result.type = 2
		elseif not Boolean.toJSBoolean(hasfront) then
			result.type = 3
		else
			-- spanning
			result.type = 4
			local frontvertices = {}
			local backvertices = {}
			local isback = vertexIsBack[
				1 --[[ ROBLOX adaptation: added 1 to array index ]]
			]
			do
				local vertexindex = 0
				while
					vertexindex
					< numvertices --[[ ROBLOX CHECK: operator '<' works only if either both arguments are strings or both are a number ]]
				do
					local vertex = vertices[vertexindex]
					local nextvertexindex = vertexindex + 1
					if
						nextvertexindex
						>= numvertices --[[ ROBLOX CHECK: operator '>=' works only if either both arguments are strings or both are a number ]]
					then
						nextvertexindex = 0
					end
					local nextisback = vertexIsBack[nextvertexindex]
					if isback == nextisback then
						-- line segment is on one side of the plane.
						if Boolean.toJSBoolean(isback) then
							table.insert(backvertices, vertex) --[[ ROBLOX CHECK: check if 'backvertices' is an Array ]]
						else
							table.insert(frontvertices, vertex) --[[ ROBLOX CHECK: check if 'frontvertices' is an Array ]]
						end
					else
						-- line segment intersects plane.
						local nextpoint = vertices[nextvertexindex]
						local intersectionpoint = splitLineSegmentByPlane(splane, vertex, nextpoint)
						if Boolean.toJSBoolean(isback) then
							table.insert(backvertices, vertex) --[[ ROBLOX CHECK: check if 'backvertices' is an Array ]]
							table.insert(backvertices, intersectionpoint) --[[ ROBLOX CHECK: check if 'backvertices' is an Array ]]
							table.insert(frontvertices, intersectionpoint) --[[ ROBLOX CHECK: check if 'frontvertices' is an Array ]]
						else
							table.insert(frontvertices, vertex) --[[ ROBLOX CHECK: check if 'frontvertices' is an Array ]]
							table.insert(frontvertices, intersectionpoint) --[[ ROBLOX CHECK: check if 'frontvertices' is an Array ]]
							table.insert(backvertices, intersectionpoint) --[[ ROBLOX CHECK: check if 'backvertices' is an Array ]]
						end
					end
					isback = nextisback
					vertexindex += 1
				end
			end -- for vertexindex
			-- remove duplicate vertices:
			local EPS_SQUARED = EPS * EPS
			if
				#backvertices
				>= 3 --[[ ROBLOX CHECK: operator '>=' works only if either both arguments are strings or both are a number ]]
			then
				local prevvertex = backvertices[(#backvertices - 1)]
				do
					local vertexindex = 0
					while
						vertexindex
						< #backvertices --[[ ROBLOX CHECK: operator '<' works only if either both arguments are strings or both are a number ]]
					do
						local vertex = backvertices[vertexindex]
						if
							vec3.squaredDistance(vertex, prevvertex)
							< EPS_SQUARED --[[ ROBLOX CHECK: operator '<' works only if either both arguments are strings or both are a number ]]
						then
							Array.splice(backvertices, vertexindex, 1) --[[ ROBLOX CHECK: check if 'backvertices' is an Array ]]
							vertexindex -= 1
						end
						prevvertex = vertex
						vertexindex += 1
					end
				end
			end
			if
				#frontvertices
				>= 3 --[[ ROBLOX CHECK: operator '>=' works only if either both arguments are strings or both are a number ]]
			then
				local prevvertex = frontvertices[(#frontvertices - 1)]
				do
					local vertexindex = 0
					while
						vertexindex
						< #frontvertices --[[ ROBLOX CHECK: operator '<' works only if either both arguments are strings or both are a number ]]
					do
						local vertex = frontvertices[vertexindex]
						if
							vec3.squaredDistance(vertex, prevvertex)
							< EPS_SQUARED --[[ ROBLOX CHECK: operator '<' works only if either both arguments are strings or both are a number ]]
						then
							Array.splice(frontvertices, vertexindex, 1) --[[ ROBLOX CHECK: check if 'frontvertices' is an Array ]]
							vertexindex -= 1
						end
						prevvertex = vertex
						vertexindex += 1
					end
				end
			end
			if
				#frontvertices
				>= 3 --[[ ROBLOX CHECK: operator '>=' works only if either both arguments are strings or both are a number ]]
			then
				result.front = poly3.fromPointsAndPlane(frontvertices, pplane)
			end
			if
				#backvertices
				>= 3 --[[ ROBLOX CHECK: operator '>=' works only if either both arguments are strings or both are a number ]]
			then
				result.back = poly3.fromPointsAndPlane(backvertices, pplane)
			end
		end
	end
	return result
end
return splitPolygonByPlane
