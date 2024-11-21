-- ROBLOX NOTE: no upstream
local Packages = game.ReplicatedStorage.Packages
local LuauPolyfill = require(Packages.LuauPolyfill)
local Array = LuauPolyfill.Array
local Boolean = LuauPolyfill.Boolean
local vec3 = require("../../maths/vec3")
local poly3 = require("../../geometries/poly3")
local function triangulatePolygon(epsilon, polygon, triangles)
	local nv = #polygon.vertices
	if
		nv > 3 --[[ ROBLOX CHECK: operator '>' works only if either both arguments are strings or both are a number ]]
	then
		if
			nv
			> 4 --[[ ROBLOX CHECK: operator '>' works only if either both arguments are strings or both are a number ]]
		then
			-- split the polygon using a midpoint
			local midpoint = { 0, 0, 0 }
			Array.forEach(polygon.vertices, function(vertice)
				return vec3.add(midpoint, midpoint, vertice)
			end) --[[ ROBLOX CHECK: check if 'polygon.vertices' is an Array ]]
			vec3.snap(midpoint, vec3.divide(midpoint, midpoint, { nv, nv, nv }), epsilon)
			do
				local i = 0
				while
					i
					< nv --[[ ROBLOX CHECK: operator '<' works only if either both arguments are strings or both are a number ]]
				do
					local poly = poly3.create({
						midpoint,
						polygon.vertices[i],
						polygon.vertices[((i + 1) % nv)],
					})
					if Boolean.toJSBoolean(polygon.color) then
						poly.color = polygon.color
					end
					table.insert(triangles, poly) --[[ ROBLOX CHECK: check if 'triangles' is an Array ]]
					i += 1
				end
			end
			return
		end -- exactly 4 vertices, use simple triangulation
		local poly0 = poly3.create({
			polygon.vertices[
				1 --[[ ROBLOX adaptation: added 1 to array index ]]
			],
			polygon.vertices[
				2 --[[ ROBLOX adaptation: added 1 to array index ]]
			],
			polygon.vertices[
				3 --[[ ROBLOX adaptation: added 1 to array index ]]
			],
		})
		local poly1 = poly3.create({
			polygon.vertices[
				1 --[[ ROBLOX adaptation: added 1 to array index ]]
			],
			polygon.vertices[
				3 --[[ ROBLOX adaptation: added 1 to array index ]]
			],
			polygon.vertices[
				4 --[[ ROBLOX adaptation: added 1 to array index ]]
			],
		})
		if Boolean.toJSBoolean(polygon.color) then
			poly0.color = polygon.color
			poly1.color = polygon.color
		end
		Array.concat(triangles, { poly0, poly1 }) --[[ ROBLOX CHECK: check if 'triangles' is an Array ]]
		return
	end -- exactly 3 vertices, so return the original
	table.insert(triangles, polygon) --[[ ROBLOX CHECK: check if 'triangles' is an Array ]]
end
--[[
 * Convert the given polygons into a list of triangles (polygons with 3 vertices).
 * NOTE: this is possible because poly3 is CONVEX by definition
 ]]
local function triangulatePolygons(epsilon, polygons)
	local triangles = {}
	Array.forEach(polygons, function(polygon)
		triangulatePolygon(epsilon, polygon, triangles)
	end) --[[ ROBLOX CHECK: check if 'polygons' is an Array ]]
	return triangles
end
return triangulatePolygons
