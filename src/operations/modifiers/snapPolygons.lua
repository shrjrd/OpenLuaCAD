-- ROBLOX NOTE: no upstream

local LuauPolyfill = require("@Packages/LuauPolyfill")
local Array = LuauPolyfill.Array
local Boolean = LuauPolyfill.Boolean
local Number = LuauPolyfill.Number
local vec3 = require("../../maths/vec3")
local poly3 = require("../../geometries/poly3")
local function isValidPoly3(epsilon, polygon)
	local area = math.abs(poly3.measureArea(polygon))
	local ref = Number.isFinite(area)
	return if Boolean.toJSBoolean(ref)
		then area
			> epsilon --[[ ROBLOX CHECK: operator '>' works only if either both arguments are strings or both are a number ]]
		else ref
end
--[[
 * Snap the given list of polygons to the epsilon.
 ]]
local function snapPolygons(epsilon, polygons)
	local newpolygons = Array.map(polygons, function(polygon)
		local snapvertices = Array.map(polygon.vertices, function(vertice)
			return vec3.snap(vec3.create(), vertice, epsilon)
		end) --[[ ROBLOX CHECK: check if 'polygon.vertices' is an Array ]] -- only retain unique vertices
		local newvertices = {}
		do
			local i = 0
			while
				i
				< #snapvertices --[[ ROBLOX CHECK: operator '<' works only if either both arguments are strings or both are a number ]]
			do
				local j = (i + 1) % #snapvertices
				if not Boolean.toJSBoolean(vec3.equals(snapvertices[i], snapvertices[j])) then
					table.insert(newvertices, snapvertices[i]) --[[ ROBLOX CHECK: check if 'newvertices' is an Array ]]
				end
				i += 1
			end
		end
		local newpolygon = poly3.create(newvertices)
		if Boolean.toJSBoolean(polygon.color) then
			newpolygon.color = polygon.color
		end
		return newpolygon
	end) --[[ ROBLOX CHECK: check if 'polygons' is an Array ]] -- snap can produce polygons with zero (0) area, remove those
	local epsilonArea = epsilon * epsilon * math.sqrt(3) / 4
	newpolygons = Array.filter(newpolygons, function(polygon)
		return isValidPoly3(epsilonArea, polygon)
	end) --[[ ROBLOX CHECK: check if 'newpolygons' is an Array ]]
	return newpolygons
end
return snapPolygons
