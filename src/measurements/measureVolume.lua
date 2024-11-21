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
 * Measure the volume of the given geometry.
 * NOTE: paths are infinitely narrow and do not have an volume
 *
 * @param {Path2} geometry - geometry to measure
 * @returns {Number} volume of the geometry
 ]]
local function measureVolumeOfPath2(geometry)
	return 0
end
--[[
 * Measure the volume of the given geometry.
 * NOTE: 2D geometry are infinitely thin and do not have an volume
 *
 * @param {Geom2} geometry - 2D geometry to measure
 * @returns {Number} volume of the geometry
 ]]
local function measureVolumeOfGeom2(geometry)
	return 0
end
--[[
 * Measure the volume of the given geometry.
 *
 * @param {Geom3} geometry - 3D geometry to measure
 * @returns {Number} volume of the geometry
 ]]
local function measureVolumeOfGeom3(geometry)
	local volume = cache:get(geometry)
	if Boolean.toJSBoolean(volume) then
		return volume
	end
	local polygons = geom3.toPolygons(geometry)
	volume = Array.reduce(polygons, function(volume, polygon)
		return volume + poly3.measureSignedVolume(polygon)
	end, 0) --[[ ROBLOX CHECK: check if 'polygons' is an Array ]]
	cache:set(geometry, volume)
	return volume
end
--[[*
 * Measure the volume of the given geometries.
 * @param {...Object} geometries - the geometries to measure
 * @return {Number|Array} the volume, or a list of volumes for each geometry
 * @alias module:modeling/measurements.measureVolume
 *
 * @example
 * let volume = measureVolume(sphere())
 ]]
local function measureVolume(
	...: any --[[ ROBLOX CHECK: check correct type of elements. ]]
)
	local geometries = { ... }
	geometries = flatten(geometries)
	if #geometries == 0 then
		error(Error.new("wrong number of arguments"))
	end
	local results = Array.map(geometries, function(geometry)
		if Boolean.toJSBoolean(path2.isA(geometry)) then
			return measureVolumeOfPath2(geometry)
		end
		if Boolean.toJSBoolean(geom2.isA(geometry)) then
			return measureVolumeOfGeom2(geometry)
		end
		if Boolean.toJSBoolean(geom3.isA(geometry)) then
			return measureVolumeOfGeom3(geometry)
		end
		return 0
	end) --[[ ROBLOX CHECK: check if 'geometries' is an Array ]]
	return if #results == 1
		then results[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		]
		else results
end
return measureVolume
