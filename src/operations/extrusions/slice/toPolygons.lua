-- ROBLOX NOTE: no upstream

local LuauPolyfill = require("@Packages/LuauPolyfill")
local Array = LuauPolyfill.Array
local poly3 = require("../../../geometries/poly3")
local earcut = require("../earcut")
local PolygonHierarchy = require("../earcut/polygonHierarchy")
--[[*
 * Return a list of polygons which are enclosed by the slice.
 * @param {slice} slice - the slice
 * @return {Array} a list of polygons (3D)
 * @alias module:modeling/extrusions/slice.toPolygons
 ]]
local function toPolygons(slice)
	local hierarchy = PolygonHierarchy.new(slice)
	local polygons = {}
	Array.forEach(hierarchy.roots, function(ref0)
		local solid, holes = ref0.solid, ref0.holes
		-- hole indices
		local index = #solid
		local holesIndex = {}
		Array.forEach(holes, function(hole, i)
			table.insert(holesIndex, index) --[[ ROBLOX CHECK: check if 'holesIndex' is an Array ]]
			index += #hole
		end) --[[ ROBLOX CHECK: check if 'holes' is an Array ]] -- compute earcut triangulation for each solid
		local vertices = Array.concat({}, { solid }, Array.spread(holes)):flat()
		local data = vertices:flat() -- Get original 3D vertex by index
		local function getVertex(i)
			return hierarchy:to3D(vertices[i])
		end
		local indices = earcut(data, holesIndex)
		do
			local i = 0
			while
				i
				< #indices --[[ ROBLOX CHECK: operator '<' works only if either both arguments are strings or both are a number ]]
			do
				-- Map back to original vertices
				local tri = Array.map(
					Array.slice(indices, i, i + 3), --[[ ROBLOX CHECK: check if 'indices' is an Array ]]
					getVertex
				)
				table.insert(polygons, poly3.fromPointsAndPlane(tri, hierarchy.plane)) --[[ ROBLOX CHECK: check if 'polygons' is an Array ]]
				i += 3
			end
		end
	end) --[[ ROBLOX CHECK: check if 'hierarchy.roots' is an Array ]]
	return polygons
end
return toPolygons
