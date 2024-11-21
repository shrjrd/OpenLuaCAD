-- ROBLOX NOTE: no upstream
local Packages = game.ReplicatedStorage.Packages
local LuauPolyfill = require(Packages.LuauPolyfill)
local Array = LuauPolyfill.Array
local Boolean = LuauPolyfill.Boolean
local WeakMap = LuauPolyfill.WeakMap
local flatten = require("../utils/flatten")
local vec3 = require("../maths/vec3")
local geom2 = require("../geometries/geom2")
local geom3 = require("../geometries/geom3")
local cacheOfCenterOfMass = WeakMap.new()
--[[
 * Measure the center of mass for the given geometry.
 *
 * @see http://paulbourke.net/geometry/polygonmesh/
 * @return {Array} the center of mass for the geometry
 ]]
local function measureCenterOfMassGeom2(geometry)
	local centerOfMass = cacheOfCenterOfMass:get(geometry)
	if centerOfMass ~= nil then
		return centerOfMass
	end
	local sides = geom2.toSides(geometry)
	local area = 0
	local x = 0
	local y = 0
	if
		#sides
		> 0 --[[ ROBLOX CHECK: operator '>' works only if either both arguments are strings or both are a number ]]
	then
		do
			local i = 0
			while
				i
				< #sides --[[ ROBLOX CHECK: operator '<' works only if either both arguments are strings or both are a number ]]
			do
				local p1 = sides[i][
					1 --[[ ROBLOX adaptation: added 1 to array index ]]
				]
				local p2 = sides[i][
					2 --[[ ROBLOX adaptation: added 1 to array index ]]
				]
				local a = p1[
					1 --[[ ROBLOX adaptation: added 1 to array index ]]
				]
						* p2[
							2 --[[ ROBLOX adaptation: added 1 to array index ]]
						]
					- p1[
							2 --[[ ROBLOX adaptation: added 1 to array index ]]
						]
						* p2[
							1 --[[ ROBLOX adaptation: added 1 to array index ]]
						]
				area += a
				x += (p1[
					1 --[[ ROBLOX adaptation: added 1 to array index ]]
				] + p2[
					1 --[[ ROBLOX adaptation: added 1 to array index ]]
				]) * a
				y += (p1[
					2 --[[ ROBLOX adaptation: added 1 to array index ]]
				] + p2[
					2 --[[ ROBLOX adaptation: added 1 to array index ]]
				]) * a
				i += 1
			end
		end
		area /= 2
		local f = 1 / (area * 6)
		x *= f
		y *= f
	end
	centerOfMass = vec3.fromValues(x, y, 0)
	cacheOfCenterOfMass:set(geometry, centerOfMass)
	return centerOfMass
end
--[[
 * Measure the center of mass for the given geometry.
 * @return {Array} the center of mass for the geometry
 ]]
local function measureCenterOfMassGeom3(geometry)
	local centerOfMass = cacheOfCenterOfMass:get(geometry)
	if centerOfMass ~= nil then
		return centerOfMass
	end
	centerOfMass = vec3.create() -- 0, 0, 0
	local polygons = geom3.toPolygons(geometry)
	if #polygons == 0 then
		return centerOfMass
	end
	local totalVolume = 0
	local vector = vec3.create() -- for speed
	Array.forEach(polygons, function(polygon)
		-- calculate volume and center of each tetrahedron
		local vertices = polygon.vertices
		do
			local i = 0
			while
				i
				< #vertices - 2 --[[ ROBLOX CHECK: operator '<' works only if either both arguments are strings or both are a number ]]
			do
				vec3.cross(vector, vertices[(i + 1)], vertices[(i + 2)])
				local volume = vec3.dot(
					vertices[
						1 --[[ ROBLOX adaptation: added 1 to array index ]]
					],
					vector
				) / 6
				totalVolume += volume
				vec3.add(
					vector,
					vertices[
						1 --[[ ROBLOX adaptation: added 1 to array index ]]
					],
					vertices[(i + 1)]
				)
				vec3.add(vector, vector, vertices[(i + 2)])
				local weightedCenter = vec3.scale(vector, vector, 1 / 4 * volume)
				vec3.add(centerOfMass, centerOfMass, weightedCenter)
				i += 1
			end
		end
	end) --[[ ROBLOX CHECK: check if 'polygons' is an Array ]]
	vec3.scale(centerOfMass, centerOfMass, 1 / totalVolume)
	cacheOfCenterOfMass:set(geometry, centerOfMass)
	return centerOfMass
end
--[[*
 * Measure the center of mass for the given geometries.
 * @param {...Object} geometries - the geometries to measure
 * @return {Array} the center of mass for each geometry, i.e. [X, Y, Z]
 * @alias module:modeling/measurements.measureCenterOfMass
 *
 * @example
 * let center = measureCenterOfMass(sphere())
 ]]
local function measureCenterOfMass(
	...: any --[[ ROBLOX CHECK: check correct type of elements. ]]
)
	local geometries = { ... }
	geometries = flatten(geometries)
	local results = Array.map(geometries, function(geometry)
		-- NOTE: center of mass for geometry path2 is not possible
		if Boolean.toJSBoolean(geom2.isA(geometry)) then
			return measureCenterOfMassGeom2(geometry)
		end
		if Boolean.toJSBoolean(geom3.isA(geometry)) then
			return measureCenterOfMassGeom3(geometry)
		end
		return { 0, 0, 0 }
	end) --[[ ROBLOX CHECK: check if 'geometries' is an Array ]]
	return if #results == 1
		then results[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		]
		else results
end
return measureCenterOfMass
