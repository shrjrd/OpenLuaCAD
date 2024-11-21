-- ROBLOX NOTE: no upstream
local Packages = game.ReplicatedStorage.Packages
local LuauPolyfill = require(Packages.LuauPolyfill)
local Array = LuauPolyfill.Array
local Boolean = LuauPolyfill.Boolean
local Error = LuauPolyfill.Error
local flatten = require("../../utils/flatten")
local vec2 = require("../../maths/vec2")
local geom2 = require("../../geometries/geom2")
local geom3 = require("../../geometries/geom3")
local path2 = require("../../geometries/path2")
local measureEpsilon = require("../../measurements/measureEpsilon")
local snapPolygons = require("./snapPolygons")
local function snapPath2(geometry)
	local epsilon = measureEpsilon(geometry)
	local points = path2.toPoints(geometry)
	local newpoints = Array.map(points, function(point)
		return vec2.snap(vec2.create(), point, epsilon)
	end) --[[ ROBLOX CHECK: check if 'points' is an Array ]] -- snap can produce duplicate points, remove those
	return path2.create(newpoints)
end
local function snapGeom2(geometry)
	local epsilon = measureEpsilon(geometry)
	local sides = geom2.toSides(geometry)
	local newsides = Array.map(sides, function(side)
		return {
			vec2.snap(
				vec2.create(),
				side[
					1 --[[ ROBLOX adaptation: added 1 to array index ]]
				],
				epsilon
			),
			vec2.snap(
				vec2.create(),
				side[
					2 --[[ ROBLOX adaptation: added 1 to array index ]]
				],
				epsilon
			),
		}
	end) --[[ ROBLOX CHECK: check if 'sides' is an Array ]] -- snap can produce sides with zero (0) length, remove those
	newsides = Array.filter(newsides, function(side)
		return not Boolean.toJSBoolean(vec2.equals(
			side[
				1 --[[ ROBLOX adaptation: added 1 to array index ]]
			],
			side[
				2 --[[ ROBLOX adaptation: added 1 to array index ]]
			]
		))
	end) --[[ ROBLOX CHECK: check if 'newsides' is an Array ]]
	return geom2.create(newsides)
end
local function snapGeom3(geometry)
	local epsilon = measureEpsilon(geometry)
	local polygons = geom3.toPolygons(geometry)
	local newpolygons = snapPolygons(epsilon, polygons)
	return geom3.create(newpolygons)
end
--[[*
 * Snap the given geometries to the overall precision (epsilon) of the geometry.
 * @see measurements.measureEpsilon()
 * @param {...Object} geometries - the geometries to snap
 * @return {Object|Array} the snapped geometry, or a list of snapped geometries
 * @alias module:modeling/modifiers.snap
 ]]
local function snap(
	...: any --[[ ROBLOX CHECK: check correct type of elements. ]]
)
	local geometries = { ... }
	geometries = flatten(geometries)
	if #geometries == 0 then
		error(Error.new("wrong number of arguments"))
	end
	local results = Array.map(geometries, function(geometry)
		if Boolean.toJSBoolean(path2.isA(geometry)) then
			return snapPath2(geometry)
		end
		if Boolean.toJSBoolean(geom2.isA(geometry)) then
			return snapGeom2(geometry)
		end
		if Boolean.toJSBoolean(geom3.isA(geometry)) then
			return snapGeom3(geometry)
		end
		return geometry
	end) --[[ ROBLOX CHECK: check if 'geometries' is an Array ]]
	return if #results == 1
		then results[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		]
		else results
end
return snap
