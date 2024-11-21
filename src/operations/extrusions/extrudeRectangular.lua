-- ROBLOX NOTE: no upstream
local Packages = game.ReplicatedStorage.Packages
local LuauPolyfill = require(Packages.LuauPolyfill)
local Array = LuauPolyfill.Array
local Boolean = LuauPolyfill.Boolean
local Error = LuauPolyfill.Error
local Object = LuauPolyfill.Object
local flatten = require("../../utils/flatten")
local geom2 = require("../../geometries/geom2")
local path2 = require("../../geometries/path2")
local extrudeRectangularPath2 = require("./extrudeRectangularPath2")
local extrudeRectangularGeom2 = require("./extrudeRectangularGeom2")
--[[*
 * Extrude the given geometry by following the outline(s) with a rectangle.
 * @See expand for addition options
 * @param {Object} options - options for extrusion, if any
 * @param {Number} [options.size=1] - size of the rectangle
 * @param {Number} [options.height=1] - height of the extrusion
 * @param {...Object} objects - the geometries to extrude
 * @return {Object|Array} the extruded object, or a list of extruded objects
 * @alias module:modeling/extrusions.extrudeRectangular
 *
 * @example
 * let mywalls = extrudeRectangular({size: 1, height: 3}, square({size: 20}))
 * let mywalls = extrudeRectangular({size: 1, height: 300, twistAngle: TAU / 2}, square({size: 20}))
 ]]
local function extrudeRectangular(
	options,
	...: any --[[ ROBLOX CHECK: check correct type of elements. ]]
)
	local objects = { ... }
	local defaults = { size = 1, height = 1 }
	local size, height
	do
		local ref = Object.assign({}, defaults, options)
		size, height = ref.size, ref.height
	end
	objects = flatten(objects)
	if #objects == 0 then
		error(Error.new("wrong number of arguments"))
	end
	if
		size
		<= 0 --[[ ROBLOX CHECK: operator '<=' works only if either both arguments are strings or both are a number ]]
	then
		error(Error.new("size must be positive"))
	end
	if
		height
		<= 0 --[[ ROBLOX CHECK: operator '<=' works only if either both arguments are strings or both are a number ]]
	then
		error(Error.new("height must be positive"))
	end
	local results = Array.map(objects, function(object)
		if Boolean.toJSBoolean(path2.isA(object)) then
			return extrudeRectangularPath2(options, object)
		end
		if Boolean.toJSBoolean(geom2.isA(object)) then
			return extrudeRectangularGeom2(options, object)
		end -- if (geom3.isA(object)) return geom3.transform(matrix, object)
		return object
	end) --[[ ROBLOX CHECK: check if 'objects' is an Array ]]
	return if #results == 1
		then results[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		]
		else results
end
return extrudeRectangular
