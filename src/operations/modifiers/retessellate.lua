-- ROBLOX NOTE: no upstream

local LuauPolyfill = require("@Packages/LuauPolyfill")
local Array = LuauPolyfill.Array
local Boolean = LuauPolyfill.Boolean
local geom3 = require("../../geometries/geom3")
local poly3 = require("../../geometries/poly3")
local NEPS = require("../../maths/constants").NEPS
local reTesselateCoplanarPolygons = require("./reTesselateCoplanarPolygons")
local function byPlaneComponent(component, tolerance)
	return function(a, b)
		if
			a.plane[component] - b.plane[component]
			> tolerance --[[ ROBLOX CHECK: operator '>' works only if either both arguments are strings or both are a number ]]
		then
			return 1
		elseif
			b.plane[component] - a.plane[component]
			> tolerance --[[ ROBLOX CHECK: operator '>' works only if either both arguments are strings or both are a number ]]
		then
			return -1
		end
		return 0
	end
end
local function classifyPolygons(polygons)
	local clusters = { polygons } -- a cluster is an array of potentially coplanar polygons
	local nonCoplanar = {} -- polygons that are known to be non-coplanar
	-- go through each component of the plane starting with the last one (the distance from origin)
	do
		local function _loop(component)
			local maybeCoplanar = {}
			local tolerance = if component == 3 then 0.000000015 else NEPS
			Array.forEach(clusters, function(cluster)
				-- sort the cluster by the current component
				Array.sort(cluster, byPlaneComponent(component, tolerance)) --[[ ROBLOX CHECK: check if 'cluster' is an Array ]] -- iterate through the cluster and check if there are polygons which are not coplanar with the others
				-- or if there are sub-clusters of coplanar polygons
				local startIndex = 0
				do
					local i = 1
					while
						i
						< #cluster --[[ ROBLOX CHECK: operator '<' works only if either both arguments are strings or both are a number ]]
					do
						-- if there's a difference larger than the tolerance, split the cluster
						if
							cluster[i].plane[component] - cluster[startIndex].plane[component]
							> tolerance --[[ ROBLOX CHECK: operator '>' works only if either both arguments are strings or both are a number ]]
						then
							-- if there's a single polygon it's definitely not coplanar with any others
							if i - startIndex == 1 then
								table.insert(nonCoplanar, cluster[startIndex]) --[[ ROBLOX CHECK: check if 'nonCoplanar' is an Array ]]
							else
								-- we have a new sub cluster of potentially coplanar polygons
								table.insert(
									maybeCoplanar,
									Array.slice(cluster, startIndex, i) --[[ ROBLOX CHECK: check if 'cluster' is an Array ]]
								) --[[ ROBLOX CHECK: check if 'maybeCoplanar' is an Array ]]
							end
							startIndex = i
						end
						i += 1
					end
				end -- handle the last elements of the cluster
				if #cluster - startIndex == 1 then
					table.insert(nonCoplanar, cluster[startIndex]) --[[ ROBLOX CHECK: check if 'nonCoplanar' is an Array ]]
				else
					table.insert(
						maybeCoplanar,
						Array.slice(cluster, startIndex) --[[ ROBLOX CHECK: check if 'cluster' is an Array ]]
					) --[[ ROBLOX CHECK: check if 'maybeCoplanar' is an Array ]]
				end
			end) --[[ ROBLOX CHECK: check if 'clusters' is an Array ]] -- replace previous clusters with the new ones
			clusters = maybeCoplanar
		end
		local component = 3
		while
			component
			>= 0 --[[ ROBLOX CHECK: operator '>=' works only if either both arguments are strings or both are a number ]]
		do
			_loop(component)
			component -= 1
		end
	end -- restore the original order of the polygons
	local result = {} -- polygons inside the cluster should already be sorted by index
	Array.forEach(clusters, function(cluster)
		if
			Boolean.toJSBoolean(cluster[
				1 --[[ ROBLOX adaptation: added 1 to array index ]]
			])
		then
			result[
				tostring(cluster[
					1 --[[ ROBLOX adaptation: added 1 to array index ]]
				].index)
			] =
				cluster
		end
	end) --[[ ROBLOX CHECK: check if 'clusters' is an Array ]]
	Array.forEach(nonCoplanar, function(polygon)
		result[polygon.index] = polygon
	end) --[[ ROBLOX CHECK: check if 'nonCoplanar' is an Array ]]
	return result
end
--[[
  After boolean operations all coplanar polygon fragments are joined by a retesselating
  operation. geom3.reTesselate(geom).
  Retesselation is done through a linear sweep over the polygon surface.
  The sweep line passes over the y coordinates of all vertices in the polygon.
  Polygons are split at each sweep line, and the fragments are joined horizontally and vertically into larger polygons
  (making sure that we will end up with convex polygons).
]]
local function retessellate(geometry)
	if Boolean.toJSBoolean(geometry.isRetesselated) then
		return geometry
	end
	local polygons = Array.map(geom3.toPolygons(geometry), function(polygon, index)
		return { vertices = polygon.vertices, plane = poly3.plane(polygon), index = index }
	end) --[[ ROBLOX CHECK: check if 'geom3.toPolygons(geometry)' is an Array ]]
	local classified = classifyPolygons(polygons)
	local destPolygons = {}
	Array.forEach(classified, function(group)
		if Boolean.toJSBoolean(Array.isArray(group)) then
			local _reTessellateCoplanarPolygons = reTesselateCoplanarPolygons(group)
			table.insert(
				destPolygons,
				error("not implemented") --[[ ROBLOX TODO: Unhandled node for type: SpreadElement ]] --[[ ..._reTessellateCoplanarPolygons ]]
			) --[[ ROBLOX CHECK: check if 'destPolygons' is an Array ]]
		else
			table.insert(destPolygons, group) --[[ ROBLOX CHECK: check if 'destPolygons' is an Array ]]
		end
	end) --[[ ROBLOX CHECK: check if 'classified' is an Array ]]
	local result = geom3.create(destPolygons)
	result.isRetesselated = true
	return result
end
return retessellate
