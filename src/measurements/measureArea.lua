-- ROBLOX NOTE: no upstream
local Packages = game.ReplicatedStorage.Packages
local LuauPolyfill = require(Packages.LuauPolyfill)
local Array = LuauPolyfill.Array
local Boolean = LuauPolyfill.Boolean
local Error = LuauPolyfill.Error
local WeakMap = LuauPolyfill.WeakMap
local flatten = require("../utils/flatten")
local geom2 = require("../geometries/geom2")
local geom3 = require("../geometries/geom3")
local path2 = require("../geometries/path2")
local poly3 = require("../geometries/poly3")
local cache = WeakMap.new()
--[[
 * Measure the area of the given geometry.
 * NOTE: paths are infinitely narrow and do not have an area
 *
 * @param {path2} geometry - geometry to measure
 * @returns {Number} area of the geometry
 ]]
local function measureAreaOfPath2(geometry)
	return 0
end
--[[
 * Measure the area of the given geometry.
 * For a counter clockwise rotating geometry (about Z) the area is positive, otherwise negative.
 *
 * @see http://paulbourke.net/geometry/polygonmesh/
 * @param {geom2} geometry - 2D geometry to measure
 * @returns {Number} area of the geometry
 ]]
local function measureAreaOfGeom2(geometry)
	local area = cache:get(geometry)
	if Boolean.toJSBoolean(area) then
		return area
	end
	local sides = geom2.toSides(geometry)
	area = Array.reduce(sides, function(area, side)
		return area
			+ (
				side[
						1 --[[ ROBLOX adaptation: added 1 to array index ]]
					][
						1 --[[ ROBLOX adaptation: added 1 to array index ]]
					]
					* side[
						2 --[[ ROBLOX adaptation: added 1 to array index ]]
					][
						2 --[[ ROBLOX adaptation: added 1 to array index ]]
					]
				- side[
						1 --[[ ROBLOX adaptation: added 1 to array index ]]
					][
						2 --[[ ROBLOX adaptation: added 1 to array index ]]
					]
					* side[
						2 --[[ ROBLOX adaptation: added 1 to array index ]]
					][
						1 --[[ ROBLOX adaptation: added 1 to array index ]]
					]
			)
	end, 0) --[[ ROBLOX CHECK: check if 'sides' is an Array ]]
	area *= 0.5
	cache:set(geometry, area)
	return area
end
--[[
 * Measure the area of the given geometry.
 *
 * @param {geom3} geometry - 3D geometry to measure
 * @returns {Number} area of the geometry
 ]]
local function measureAreaOfGeom3(geometry)
	local area = cache:get(geometry)
	if Boolean.toJSBoolean(area) then
		return area
	end
	local polygons = geom3.toPolygons(geometry)
	area = Array.reduce(polygons, function(area, polygon)
		return area + poly3.measureArea(polygon)
	end, 0) --[[ ROBLOX CHECK: check if 'polygons' is an Array ]]
	cache:set(geometry, area)
	return area
end
--[[*
 * Measure the area of the given geometries.
 * @param {...Objects} geometries - the geometries to measure
 * @return {Number|Array} the area, or a list of areas for each geometry
 * @alias module:modeling/measurements.measureArea
 *
 * @example
 * let area = measureArea(sphere())
 ]]
local function measureArea(
	...: any --[[ ROBLOX CHECK: check correct type of elements. ]]
)
	local geometries = { ... }
	geometries = flatten(geometries)
	if #geometries == 0 then
		error(Error.new("wrong number of arguments"))
	end
	local results = Array.map(geometries, function(geometry)
		if Boolean.toJSBoolean(path2.isA(geometry)) then
			return measureAreaOfPath2(geometry)
		end
		if Boolean.toJSBoolean(geom2.isA(geometry)) then
			return measureAreaOfGeom2(geometry)
		end
		if Boolean.toJSBoolean(geom3.isA(geometry)) then
			return measureAreaOfGeom3(geometry)
		end
		return 0
	end) --[[ ROBLOX CHECK: check if 'geometries' is an Array ]]
	return if #results == 1
		then results[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		]
		else results
end
return measureArea
