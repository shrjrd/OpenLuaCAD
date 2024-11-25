-- ROBLOX NOTE: no upstream

local LuauPolyfill = require("@Packages/LuauPolyfill")
local Array = LuauPolyfill.Array
local Boolean = LuauPolyfill.Boolean
local Error = LuauPolyfill.Error
local Object = LuauPolyfill.Object
local flatten = require("../../utils/flatten")
local geom2 = require("../../geometries/geom2")
local path2 = require("../../geometries/path2")
local extrudeLinearGeom2 = require("./extrudeLinearGeom2")
local extrudeLinearPath2 = require("./extrudeLinearPath2")
--[[*
 * Extrude the given geometry in an upward linear direction using the given options.
 * Accepts path2 or geom2 objects as input. Paths must be closed.
 *
 * @param {Object} options - options for extrude
 * @param {Number} [options.height=1] the height of the extrusion
 * @param {Number} [options.twistAngle=0] the final rotation (RADIANS) about the origin of the shape (if any)
 * @param {Integer} [options.twistSteps=1] the resolution of the twist about the axis (if any)
 * @param {...Object} objects - the geometries to extrude
 * @return {Object|Array} the extruded geometry, or a list of extruded geometry
 * @alias module:modeling/extrusions.extrudeLinear
 *
 * @example
 * let myshape = extrudeLinear({height: 10}, rectangle({size: [20, 25]}))
 ]]
local function extrudeLinear(
	options,
	...: any --[[ ROBLOX CHECK: check correct type of elements. ]]
)
	local objects = { ... }
	local defaults = { height = 1, twistAngle = 0, twistSteps = 1, repair = true }
	local height, twistAngle, twistSteps, repair
	do
		local ref = Object.assign({}, defaults, options)
		height, twistAngle, twistSteps, repair = ref.height, ref.twistAngle, ref.twistSteps, ref.repair
	end
	objects = flatten(objects)
	if #objects == 0 then
		error(Error.new("wrong number of arguments"))
	end
	options = {
		offset = { 0, 0, height },
		twistAngle = twistAngle,
		twistSteps = twistSteps,
		repair = repair,
	}
	local results = Array.map(objects, function(object)
		if Boolean.toJSBoolean(path2.isA(object)) then
			return extrudeLinearPath2(options, object)
		end
		if Boolean.toJSBoolean(geom2.isA(object)) then
			return extrudeLinearGeom2(options, object)
		end -- if (geom3.isA(object)) return geom3.extrude(options, object)
		return object
	end) --[[ ROBLOX CHECK: check if 'objects' is an Array ]]
	return if #results == 1
		then results[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		]
		else results
end
return extrudeLinear
