-- ROBLOX NOTE: no upstream
local Packages = game.ReplicatedStorage.Packages
local LuauPolyfill = require(Packages.LuauPolyfill)
local Array = LuauPolyfill.Array
local Boolean = LuauPolyfill.Boolean
local Error = LuauPolyfill.Error
local Number = LuauPolyfill.Number
local Object = LuauPolyfill.Object
local flatten = require("../../utils/flatten")
local aboutEqualNormals = require("../../maths/utils/aboutEqualNormals")
local plane = require("../../maths/plane")
local mat4 = require("../../maths/mat4")
local geom2 = require("../../geometries/geom2")
local geom3 = require("../../geometries/geom3")
local poly3 = require("../../geometries/poly3")
local measureEpsilon = require("../../measurements/measureEpsilon")
local unionGeom2 = require("../booleans/unionGeom2")
local function projectGeom3(options, geometry)
	-- create a plane from the options, and verify
	local projplane = plane.fromNormalAndPoint(plane.create(), options.axis, options.origin)
	if
		Boolean.toJSBoolean((function()
			local ref = Number.isNaN(projplane[
				1 --[[ ROBLOX adaptation: added 1 to array index ]]
			])
			ref = Boolean.toJSBoolean(ref) and ref
				or Number.isNaN(projplane[
					2 --[[ ROBLOX adaptation: added 1 to array index ]]
				])
			ref = Boolean.toJSBoolean(ref) and ref
				or Number.isNaN(projplane[
					3 --[[ ROBLOX adaptation: added 1 to array index ]]
				])
			return Boolean.toJSBoolean(ref) and ref
				or Number.isNaN(projplane[
					4 --[[ ROBLOX adaptation: added 1 to array index ]]
				])
		end)())
	then
		error(Error.new("project: invalid axis or origin"))
	end
	local epsilon = measureEpsilon(geometry)
	local epsilonArea = epsilon * epsilon * math.sqrt(3) / 4
	if epsilon == 0 then
		return geom2.create()
	end -- project the polygons to the plane
	local polygons = geom3.toPolygons(geometry)
	local projpolys = {}
	do
		local i = 0
		while
			i
			< #polygons --[[ ROBLOX CHECK: operator '<' works only if either both arguments are strings or both are a number ]]
		do
			local newpoints = Array.map(polygons[i].vertices, function(v)
				return plane.projectionOfPoint(projplane, v)
			end) --[[ ROBLOX CHECK: check if 'polygons[i].vertices' is an Array ]]
			local newpoly = poly3.create(newpoints) -- only keep projections that face the same direction as the plane
			local newplane = poly3.plane(newpoly)
			if not Boolean.toJSBoolean(aboutEqualNormals(projplane, newplane)) then
				i += 1
				continue
			end -- only keep projections that have a measurable area
			if
				poly3.measureArea(newpoly)
				< epsilonArea --[[ ROBLOX CHECK: operator '<' works only if either both arguments are strings or both are a number ]]
			then
				i += 1
				continue
			end
			table.insert(projpolys, newpoly) --[[ ROBLOX CHECK: check if 'projpolys' is an Array ]]
			i += 1
		end
	end -- rotate the polygons to lay on X/Y axes if necessary
	if not Boolean.toJSBoolean(aboutEqualNormals(projplane, { 0, 0, 1 })) then
		local rotation = mat4.fromVectorRotation(mat4.create(), projplane, { 0, 0, 1 })
		projpolys = Array.map(projpolys, function(p)
			return poly3.transform(rotation, p)
		end) --[[ ROBLOX CHECK: check if 'projpolys' is an Array ]]
	end -- sort the polygons to allow the union to ignore small pieces efficiently
	projpolys = Array.sort(projpolys, function(a, b)
		return poly3.measureArea(b) - poly3.measureArea(a)
	end) --[[ ROBLOX CHECK: check if 'projpolys' is an Array ]] -- convert polygons to geometry, and union all pieces into a single geometry
	local projgeoms = Array.map(projpolys, function(p)
		return geom2.fromPoints(p.vertices)
	end) --[[ ROBLOX CHECK: check if 'projpolys' is an Array ]]
	return unionGeom2(projgeoms)
end
--[=[*
 * Project the given 3D geometry on to the given plane.
 * @param {Object} options - options for project
 * @param {Array} [options.axis=[0,0,1]] the axis of the plane (default is Z axis)
 * @param {Array} [options.origin=[0,0,0]] the origin of the plane
 * @param {...Object} objects - the list of 3D geometry to project
 * @return {geom2|Array} the projected 2D geometry, or a list of 2D projected geometry
 * @alias module:modeling/extrusions.project
 *
 * @example
 * let myshape = project({}, sphere({radius: 20, segments: 5}))
 ]=]
local function project(
	options,
	...: any --[[ ROBLOX CHECK: check correct type of elements. ]]
)
	local objects = { ... }
	local defaults = {
		axis = { 0, 0, 1 },
		-- Z axis
		origin = { 0, 0, 0 },
	}
	local axis, origin
	do
		local ref = Object.assign({}, defaults, options)
		axis, origin = ref.axis, ref.origin
	end
	objects = flatten(objects)
	if #objects == 0 then
		error(Error.new("wrong number of arguments"))
	end
	options = { axis = axis, origin = origin }
	local results = Array.map(objects, function(object)
		-- if (path.isA(object)) return project(options, object)
		-- if (geom2.isA(object)) return project(options, object)
		if Boolean.toJSBoolean(geom3.isA(object)) then
			return projectGeom3(options, object)
		end
		return object
	end) --[[ ROBLOX CHECK: check if 'objects' is an Array ]]
	return if #results == 1
		then results[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		]
		else results
end
return project
