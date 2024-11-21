-- ROBLOX NOTE: no upstream
local Packages = game.ReplicatedStorage.Packages
local LuauPolyfill = require(Packages.LuauPolyfill)
local Array = LuauPolyfill.Array
local Boolean = LuauPolyfill.Boolean
local WeakMap = LuauPolyfill.WeakMap
local flatten = require("../utils/flatten")
local vec2 = require("../maths/vec2")
local vec3 = require("../maths/vec3")
local geom2 = require("../geometries/geom2")
local geom3 = require("../geometries/geom3")
local path2 = require("../geometries/path2")
local poly3 = require("../geometries/poly3")
local cacheOfBoundingSpheres = WeakMap.new()
--[=[
 * Measure the bounding sphere of the given (path2) geometry.
 * @return {[[x, y, z], radius]} the bounding sphere for the geometry
 ]=]
local function measureBoundingSphereOfPath2(geometry)
	local boundingSphere = cacheOfBoundingSpheres:get(geometry)
	if boundingSphere ~= nil then
		return boundingSphere
	end
	local centroid = vec3.create()
	local radius = 0
	local points = path2.toPoints(geometry)
	if
		#points
		> 0 --[[ ROBLOX CHECK: operator '>' works only if either both arguments are strings or both are a number ]]
	then
		-- calculate the centroid of the geometry
		local numPoints = 0
		local temp = vec3.create()
		Array.forEach(points, function(point)
			vec3.add(centroid, centroid, vec3.fromVec2(temp, point, 0))
			numPoints += 1
		end) --[[ ROBLOX CHECK: check if 'points' is an Array ]]
		vec3.scale(centroid, centroid, 1 / numPoints) -- find the farthest point from the centroid
		Array.forEach(points, function(point)
			radius = math.max(radius, vec2.squaredDistance(centroid, point))
		end) --[[ ROBLOX CHECK: check if 'points' is an Array ]]
		radius = math.sqrt(radius)
	end
	boundingSphere = { centroid, radius }
	cacheOfBoundingSpheres:set(geometry, boundingSphere)
	return boundingSphere
end
--[=[
 * Measure the bounding sphere of the given (geom2) geometry.
 * @return {[[x, y, z], radius]} the bounding sphere for the geometry
 ]=]
local function measureBoundingSphereOfGeom2(geometry)
	local boundingSphere = cacheOfBoundingSpheres:get(geometry)
	if boundingSphere ~= nil then
		return boundingSphere
	end
	local centroid = vec3.create()
	local radius = 0
	local sides = geom2.toSides(geometry)
	if
		#sides
		> 0 --[[ ROBLOX CHECK: operator '>' works only if either both arguments are strings or both are a number ]]
	then
		-- calculate the centroid of the geometry
		local numPoints = 0
		local temp = vec3.create()
		Array.forEach(sides, function(side)
			vec3.add(
				centroid,
				centroid,
				vec3.fromVec2(
					temp,
					side[
						1 --[[ ROBLOX adaptation: added 1 to array index ]]
					],
					0
				)
			)
			numPoints += 1
		end) --[[ ROBLOX CHECK: check if 'sides' is an Array ]]
		vec3.scale(centroid, centroid, 1 / numPoints) -- find the farthest point from the centroid
		Array.forEach(sides, function(side)
			radius = math.max(
				radius,
				vec2.squaredDistance(
					centroid,
					side[
						1 --[[ ROBLOX adaptation: added 1 to array index ]]
					]
				)
			)
		end) --[[ ROBLOX CHECK: check if 'sides' is an Array ]]
		radius = math.sqrt(radius)
	end
	boundingSphere = { centroid, radius }
	cacheOfBoundingSpheres:set(geometry, boundingSphere)
	return boundingSphere
end
--[=[
 * Measure the bounding sphere of the given (geom3) geometry.
 * @return {[[x, y, z], radius]} the bounding sphere for the geometry
 ]=]
local function measureBoundingSphereOfGeom3(geometry)
	local boundingSphere = cacheOfBoundingSpheres:get(geometry)
	if boundingSphere ~= nil then
		return boundingSphere
	end
	local centroid = vec3.create()
	local radius = 0
	local polygons = geom3.toPolygons(geometry)
	if
		#polygons
		> 0 --[[ ROBLOX CHECK: operator '>' works only if either both arguments are strings or both are a number ]]
	then
		-- calculate the centroid of the geometry
		local numPoints = 0
		Array.forEach(polygons, function(polygon)
			Array.forEach(poly3.toPoints(polygon), function(point)
				vec3.add(centroid, centroid, point)
				numPoints += 1
			end) --[[ ROBLOX CHECK: check if 'poly3.toPoints(polygon)' is an Array ]]
		end) --[[ ROBLOX CHECK: check if 'polygons' is an Array ]]
		vec3.scale(centroid, centroid, 1 / numPoints) -- find the farthest point from the centroid
		Array.forEach(polygons, function(polygon)
			Array.forEach(poly3.toPoints(polygon), function(point)
				radius = math.max(radius, vec3.squaredDistance(centroid, point))
			end) --[[ ROBLOX CHECK: check if 'poly3.toPoints(polygon)' is an Array ]]
		end) --[[ ROBLOX CHECK: check if 'polygons' is an Array ]]
		radius = math.sqrt(radius)
	end
	boundingSphere = { centroid, radius }
	cacheOfBoundingSpheres:set(geometry, boundingSphere)
	return boundingSphere
end
--[[*
 * Measure the (approximate) bounding sphere of the given geometries.
 * @see https://en.wikipedia.org/wiki/Bounding_sphere
 * @param {...Object} geometries - the geometries to measure
 * @return {Array} the bounding sphere for each geometry, i.e. [centroid, radius]
 * @alias module:modeling/measurements.measureBoundingSphere
 *
 * @example
 * let bounds = measureBoundingSphere(cube())
 ]]
local function measureBoundingSphere(
	...: any --[[ ROBLOX CHECK: check correct type of elements. ]]
)
	local geometries = { ... }
	geometries = flatten(geometries)
	local results = Array.map(geometries, function(geometry)
		if Boolean.toJSBoolean(path2.isA(geometry)) then
			return measureBoundingSphereOfPath2(geometry)
		end
		if Boolean.toJSBoolean(geom2.isA(geometry)) then
			return measureBoundingSphereOfGeom2(geometry)
		end
		if Boolean.toJSBoolean(geom3.isA(geometry)) then
			return measureBoundingSphereOfGeom3(geometry)
		end
		return { { 0, 0, 0 }, 0 }
	end) --[[ ROBLOX CHECK: check if 'geometries' is an Array ]]
	return if #results == 1
		then results[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		]
		else results
end
return measureBoundingSphere
