-- ROBLOX NOTE: no upstream

local LuauPolyfill = require("@Packages/LuauPolyfill")
local Array = LuauPolyfill.Array
local Boolean = LuauPolyfill.Boolean
local Error = LuauPolyfill.Error
local flatten = require("../utils/flatten")
local geom2, geom3, path2
do
	local ref = require("../geometries")
	geom2, geom3, path2 = ref.geom2, ref.geom3, ref.path2
end
local calculateEpsilonFromBounds = require("./calculateEpsilonFromBounds")
local measureBoundingBox = require("./measureBoundingBox")
--[[
 * Measure the epsilon of the given (path2) geometry.
 * @return {Number} the epsilon (precision) of the geometry
 ]]
local function measureEpsilonOfPath2(geometry)
	return calculateEpsilonFromBounds(measureBoundingBox(geometry), 2)
end
--[[
 * Measure the epsilon of the given (geom2) geometry.
 * @return {Number} the epsilon (precision) of the geometry
 ]]
local function measureEpsilonOfGeom2(geometry)
	return calculateEpsilonFromBounds(measureBoundingBox(geometry), 2)
end
--[[
 * Measure the epsilon of the given (geom3) geometry.
 * @return {Float} the epsilon (precision) of the geometry
 ]]
local function measureEpsilonOfGeom3(geometry)
	return calculateEpsilonFromBounds(measureBoundingBox(geometry), 3)
end
--[[*
 * Measure the epsilon of the given geometries.
 * Epsilon values are used in various functions to determine minimum distances between points, planes, etc.
 * @param {...Object} geometries - the geometries to measure
 * @return {Number|Array} the epsilon, or a list of epsilons for each geometry
 * @alias module:modeling/measurements.measureEpsilon
 *
 * @example
 * let epsilon = measureEpsilon(sphere())
 ]]
local function measureEpsilon(
	...: any --[[ ROBLOX CHECK: check correct type of elements. ]]
)
	local geometries = { ... }
	geometries = flatten(geometries)
	if #geometries == 0 then
		error(Error.new("wrong number of arguments"))
	end
	local results = Array.map(geometries, function(geometry)
		if Boolean.toJSBoolean(path2.isA(geometry)) then
			return measureEpsilonOfPath2(geometry)
		end
		if Boolean.toJSBoolean(geom2.isA(geometry)) then
			return measureEpsilonOfGeom2(geometry)
		end
		if Boolean.toJSBoolean(geom3.isA(geometry)) then
			return measureEpsilonOfGeom3(geometry)
		end
		return 0
	end) --[[ ROBLOX CHECK: check if 'geometries' is an Array ]]
	return if #results == 1
		then results[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		]
		else results
end
return measureEpsilon
