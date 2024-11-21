-- ROBLOX NOTE: no upstream
local Packages = game.ReplicatedStorage.Packages
local LuauPolyfill = require(Packages.LuauPolyfill)
local Array = LuauPolyfill.Array
local Boolean = LuauPolyfill.Boolean
local Error = LuauPolyfill.Error
local WeakMap = LuauPolyfill.WeakMap
local flatten = require("../utils/flatten")
local vec2 = require("../maths/vec2")
local vec3 = require("../maths/vec3")
local geom2 = require("../geometries/geom2")
local geom3 = require("../geometries/geom3")
local path2 = require("../geometries/path2")
local poly3 = require("../geometries/poly3")
local cache = WeakMap.new()
--[[
 * Measure the min and max bounds of the given (path2) geometry.
 * @return {Array[]} the min and max bounds for the geometry
 ]]
local function measureBoundingBoxOfPath2(geometry)
	local boundingBox = cache:get(geometry)
	if Boolean.toJSBoolean(boundingBox) then
		return boundingBox
	end
	local points = path2.toPoints(geometry)
	local minpoint
	if #points == 0 then
		minpoint = vec2.create()
	else
		minpoint = vec2.clone(points[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		])
	end
	local maxpoint = vec2.clone(minpoint)
	Array.forEach(points, function(point)
		vec2.min(minpoint, minpoint, point)
		vec2.max(maxpoint, maxpoint, point)
	end) --[[ ROBLOX CHECK: check if 'points' is an Array ]]
	minpoint = {
		minpoint[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		],
		minpoint[
			2 --[[ ROBLOX adaptation: added 1 to array index ]]
		],
		0,
	}
	maxpoint = {
		maxpoint[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		],
		maxpoint[
			2 --[[ ROBLOX adaptation: added 1 to array index ]]
		],
		0,
	}
	boundingBox = { minpoint, maxpoint }
	cache:set(geometry, boundingBox)
	return boundingBox
end
--[[
 * Measure the min and max bounds of the given (geom2) geometry.
 * @return {Array[]} the min and max bounds for the geometry
 ]]
local function measureBoundingBoxOfGeom2(geometry)
	local boundingBox = cache:get(geometry)
	if Boolean.toJSBoolean(boundingBox) then
		return boundingBox
	end
	local points = geom2.toPoints(geometry)
	local minpoint
	if #points == 0 then
		minpoint = vec2.create()
	else
		minpoint = vec2.clone(points[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		])
	end
	local maxpoint = vec2.clone(minpoint)
	Array.forEach(points, function(point)
		vec2.min(minpoint, minpoint, point)
		vec2.max(maxpoint, maxpoint, point)
	end) --[[ ROBLOX CHECK: check if 'points' is an Array ]]
	minpoint = {
		minpoint[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		],
		minpoint[
			2 --[[ ROBLOX adaptation: added 1 to array index ]]
		],
		0,
	}
	maxpoint = {
		maxpoint[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		],
		maxpoint[
			2 --[[ ROBLOX adaptation: added 1 to array index ]]
		],
		0,
	}
	boundingBox = { minpoint, maxpoint }
	cache:set(geometry, boundingBox)
	return boundingBox
end
--[[
 * Measure the min and max bounds of the given (geom3) geometry.
 * @return {Array[]} the min and max bounds for the geometry
 ]]
local function measureBoundingBoxOfGeom3(geometry)
	local boundingBox = cache:get(geometry)
	if Boolean.toJSBoolean(boundingBox) then
		return boundingBox
	end
	local polygons = geom3.toPolygons(geometry)
	local minpoint = vec3.create()
	if
		#polygons
		> 0 --[[ ROBLOX CHECK: operator '>' works only if either both arguments are strings or both are a number ]]
	then
		local points = poly3.toPoints(polygons[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		])
		vec3.copy(
			minpoint,
			points[
				1 --[[ ROBLOX adaptation: added 1 to array index ]]
			]
		)
	end
	local maxpoint = vec3.clone(minpoint)
	Array.forEach(polygons, function(polygon)
		Array.forEach(poly3.toPoints(polygon), function(point)
			vec3.min(minpoint, minpoint, point)
			vec3.max(maxpoint, maxpoint, point)
		end) --[[ ROBLOX CHECK: check if 'poly3.toPoints(polygon)' is an Array ]]
	end) --[[ ROBLOX CHECK: check if 'polygons' is an Array ]]
	minpoint = {
		minpoint[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		],
		minpoint[
			2 --[[ ROBLOX adaptation: added 1 to array index ]]
		],
		minpoint[
			3 --[[ ROBLOX adaptation: added 1 to array index ]]
		],
	}
	maxpoint = {
		maxpoint[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		],
		maxpoint[
			2 --[[ ROBLOX adaptation: added 1 to array index ]]
		],
		maxpoint[
			3 --[[ ROBLOX adaptation: added 1 to array index ]]
		],
	}
	boundingBox = { minpoint, maxpoint }
	cache:set(geometry, boundingBox)
	return boundingBox
end
--[[*
 * Measure the min and max bounds of the given geometries.
 * @param {...Object} geometries - the geometries to measure
 * @return {Array} the min and max bounds, or a list of bounds for each geometry
 * @alias module:modeling/measurements.measureBoundingBox
 *
 * @example
 * let bounds = measureBoundingBox(sphere())
 ]]
local function measureBoundingBox(
	...: any --[[ ROBLOX CHECK: check correct type of elements. ]]
)
	local geometries = { ... }
	geometries = flatten(geometries)
	if #geometries == 0 then
		error(Error.new("wrong number of arguments"))
	end
	local results = Array.map(geometries, function(geometry)
		if Boolean.toJSBoolean(path2.isA(geometry)) then
			return measureBoundingBoxOfPath2(geometry)
		end
		if Boolean.toJSBoolean(geom2.isA(geometry)) then
			return measureBoundingBoxOfGeom2(geometry)
		end
		if Boolean.toJSBoolean(geom3.isA(geometry)) then
			return measureBoundingBoxOfGeom3(geometry)
		end
		return { { 0, 0, 0 }, { 0, 0, 0 } }
	end) --[[ ROBLOX CHECK: check if 'geometries' is an Array ]]
	return if #results == 1
		then results[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		]
		else results
end
return measureBoundingBox
