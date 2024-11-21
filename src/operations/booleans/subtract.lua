-- ROBLOX NOTE: no upstream
local Packages = game.ReplicatedStorage.Packages
local LuauPolyfill = require(Packages.LuauPolyfill)
local Boolean = LuauPolyfill.Boolean
local Error = LuauPolyfill.Error
local flatten = require("../../utils/flatten")
local areAllShapesTheSameType = require("../../utils/areAllShapesTheSameType")
local geom2 = require("../../geometries/geom2")
local geom3 = require("../../geometries/geom3")
local subtractGeom2 = require("./subtractGeom2")
local subtractGeom3 = require("./subtractGeom3")
--[[*
 * Return a new geometry representing space in the first geometry but
 * not in all subsequent geometries.
 * The given geometries should be of the same type, either geom2 or geom3.
 *
 * @param {...Object} geometries - list of geometries
 * @returns {geom2|geom3} a new geometry
 * @alias module:modeling/booleans.subtract
 *
 * @example
 * let myshape = subtract(cuboid({size: [5,5,5]}), cuboid({size: [5,5,5], center: [5,5,5]}))
 *
 * @example
 * +-------+            +-------+
 * |       |            |       |
 * |   A   |            |       |
 * |    +--+----+   =   |    +--+
 * +----+--+    |       +----+
 *      |   B   |
 *      |       |
 *      +-------+
 ]]
local function subtract(
	...: any --[[ ROBLOX CHECK: check correct type of elements. ]]
)
	local geometries = { ... }
	geometries = flatten(geometries)
	if #geometries == 0 then
		error(Error.new("wrong number of arguments"))
	end
	if not Boolean.toJSBoolean(areAllShapesTheSameType(geometries)) then
		error(Error.new("only subtract of the types are supported"))
	end
	local geometry = geometries[
		1 --[[ ROBLOX adaptation: added 1 to array index ]]
	] -- if (path.isA(geometry)) return pathsubtract(matrix, geometries)
	if Boolean.toJSBoolean(geom2.isA(geometry)) then
		return subtractGeom2(geometries)
	end
	if Boolean.toJSBoolean(geom3.isA(geometry)) then
		return subtractGeom3(geometries)
	end
	return geometry
end
return subtract
