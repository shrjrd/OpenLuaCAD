-- ROBLOX NOTE: no upstream

local LuauPolyfill = require("@Packages/LuauPolyfill")
local Boolean = LuauPolyfill.Boolean
local Error = LuauPolyfill.Error
local flatten = require("../../utils/flatten")
local areAllShapesTheSameType = require("../../utils/areAllShapesTheSameType")
local geom2 = require("../../geometries/geom2")
local geom3 = require("../../geometries/geom3")
local path2 = require("../../geometries/path2")
local hullPath2 = require("./hullPath2")
local hullGeom2 = require("./hullGeom2")
local hullGeom3 = require("./hullGeom3")
--[[*
 * Create a convex hull of the given geometries.
 * The given geometries should be of the same type, either geom2 or geom3 or path2.
 * @param {...Objects} geometries - list of geometries from which to create a hull
 * @returns {geom2|geom3} new geometry
 * @alias module:modeling/hulls.hull
 *
 * @example
 * let myshape = hull(rectangle({center: [-5,-5]}), ellipse({center: [5,5]}))
 *
 * @example
 * +-------+           +-------+
 * |       |           |        \
 * |   A   |           |         \
 * |       |           |          \
 * +-------+           +           \
 *                  =   \           \
 *       +-------+       \           +
 *       |       |        \          |
 *       |   B   |         \         |
 *       |       |          \        |
 *       +-------+           +-------+
 ]]
local function hull(
	...: any --[[ ROBLOX CHECK: check correct type of elements. ]]
)
	local geometries = { ... }
	geometries = flatten(geometries)
	if #geometries == 0 then
		error(Error.new("wrong number of arguments"))
	end
	if not Boolean.toJSBoolean(areAllShapesTheSameType(geometries)) then
		error(Error.new("only hulls of the same type are supported"))
	end
	local geometry = geometries[
		1 --[[ ROBLOX adaptation: added 1 to array index ]]
	]
	if Boolean.toJSBoolean(path2.isA(geometry)) then
		return hullPath2(geometries)
	end
	if Boolean.toJSBoolean(geom2.isA(geometry)) then
		return hullGeom2(geometries)
	end
	if Boolean.toJSBoolean(geom3.isA(geometry)) then
		return hullGeom3(geometries)
	end -- FIXME should this throw an error for unknown geometries?
	return geometry
end
return hull
