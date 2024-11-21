-- ROBLOX NOTE: no upstream
local Packages = game.ReplicatedStorage.Packages
local LuauPolyfill = require(Packages.LuauPolyfill)
local Array = LuauPolyfill.Array
local Boolean = LuauPolyfill.Boolean
local Error = LuauPolyfill.Error
local Object = LuauPolyfill.Object
local flatten = require("../../utils/flatten")
local measureEpsilon = require("../../measurements/measureEpsilon")
local geom2 = require("../../geometries/geom2")
local geom3 = require("../../geometries/geom3")
local path2 = require("../../geometries/path2")
local snapPolygons = require("./snapPolygons")
local mergePolygons = require("./mergePolygons")
local insertTjunctions = require("./insertTjunctions")
local triangulatePolygons = require("./triangulatePolygons")
--[[
 ]]
local function generalizePath2(options, geometry)
	return geometry
end
--[[
 ]]
local function generalizeGeom2(options, geometry)
	return geometry
end
--[[
 ]]
local function generalizeGeom3(options, geometry)
	local defaults = { snap = false, simplify = false, triangulate = false }
	local snap, simplify, triangulate
	do
		local ref = Object.assign({}, defaults, options)
		snap, simplify, triangulate = ref.snap, ref.simplify, ref.triangulate
	end
	local epsilon = measureEpsilon(geometry)
	local polygons = geom3.toPolygons(geometry) -- snap the given geometry if requested
	if Boolean.toJSBoolean(snap) then
		polygons = snapPolygons(epsilon, polygons)
	end -- simplify the polygons if requested
	if Boolean.toJSBoolean(simplify) then
		-- TODO implement some mesh decimations
		polygons = mergePolygons(epsilon, polygons)
	end -- triangulate the polygons if requested
	if Boolean.toJSBoolean(triangulate) then
		polygons = insertTjunctions(polygons)
		polygons = triangulatePolygons(epsilon, polygons)
	end -- FIXME replace with geom3.cloneShallow() when available
	local clone = Object.assign({}, geometry)
	clone.polygons = polygons
	return clone
end
--[[*
 * Apply various modifications in proper order to produce a generalized geometry.
 * @param {Object} options - options for modifications
 * @param {Boolean} [options.snap=false] the geometries should be snapped to epsilons
 * @param {Boolean} [options.simplify=false] the geometries should be simplified
 * @param {Boolean} [options.triangulate=false] the geometries should be triangulated
 * @param {...Object} geometries - the geometries to generalize
 * @return {Object|Array} the modified geometry, or a list of modified geometries
 * @alias module:modeling/modifiers.generalize
 ]]
local function generalize(
	options,
	...: any --[[ ROBLOX CHECK: check correct type of elements. ]]
)
	local geometries = { ... }
	geometries = flatten(geometries)
	if #geometries == 0 then
		error(Error.new("wrong number of arguments"))
	end
	local results = Array.map(geometries, function(geometry)
		if Boolean.toJSBoolean(path2.isA(geometry)) then
			return generalizePath2(options, geometry)
		end
		if Boolean.toJSBoolean(geom2.isA(geometry)) then
			return generalizeGeom2(options, geometry)
		end
		if Boolean.toJSBoolean(geom3.isA(geometry)) then
			return generalizeGeom3(options, geometry)
		end
		error(Error.new("invalid geometry"))
	end) --[[ ROBLOX CHECK: check if 'geometries' is an Array ]]
	return if #results == 1
		then results[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		]
		else results
end
return generalize
