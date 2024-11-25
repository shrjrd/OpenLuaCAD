-- ROBLOX NOTE: no upstream

local LuauPolyfill = require("@Packages/LuauPolyfill")
local Array = LuauPolyfill.Array
local poly3 = require("../../geometries/poly3")
local quickhull = require("./quickhull")
--[[*
 * Create a convex hull of the given set of points, where each point is an array of [x,y,z].
 *
 * @param {Array} uniquePoints - list of UNIQUE points from which to create a hull
 * @returns {Array} a list of polygons (poly3)
 * @alias module:modeling/hulls.hullPoints3
 ]]
local function hullPoints3(uniquePoints)
	local faces = quickhull(uniquePoints, { skipTriangulation = true })
	local polygons = Array.map(faces, function(face)
		local vertices = Array.map(face, function(index)
			return uniquePoints[index]
		end) --[[ ROBLOX CHECK: check if 'face' is an Array ]]
		return poly3.create(vertices)
	end) --[[ ROBLOX CHECK: check if 'faces' is an Array ]]
	return polygons
end
return hullPoints3
