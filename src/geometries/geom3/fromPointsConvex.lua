-- ROBLOX NOTE: no upstream

local LuauPolyfill = require("@Packages/LuauPolyfill")
local Array = LuauPolyfill.Array
local Boolean = LuauPolyfill.Boolean
local Error = LuauPolyfill.Error
local quickhull = require("../../operations/hulls/quickhull")
local create = require("./create")
local poly3 = require("../poly3")
--[[*
 * Construct a new convex 3D geometry from a list of unique points.
 * @param {Array} uniquePoints - list of points to construct convex 3D geometry
 * @returns {geom3} a new geometry
 * @alias module:modeling/geometries/geom3.fromPointsConvex
 ]]
local function fromPointsConvex(uniquePoints)
	if not Boolean.toJSBoolean(Array.isArray(uniquePoints)) then
		error(Error.new("the given points must be an array"))
	end
	local faces = quickhull(uniquePoints, { skipTriangulation = true })
	local polygons = Array.map(faces, function(face)
		local vertices = Array.map(face, function(index)
			return uniquePoints[index]
		end) --[[ ROBLOX CHECK: check if 'face' is an Array ]]
		return poly3.create(vertices)
	end) --[[ ROBLOX CHECK: check if 'faces' is an Array ]]
	return create(polygons)
end
return fromPointsConvex
