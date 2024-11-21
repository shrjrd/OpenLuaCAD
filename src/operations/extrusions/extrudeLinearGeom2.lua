-- ROBLOX NOTE: no upstream
local Packages = game.ReplicatedStorage.Packages
local LuauPolyfill = require(Packages.LuauPolyfill)
local Array = LuauPolyfill.Array
local Error = LuauPolyfill.Error
local Object = LuauPolyfill.Object
local mat4 = require("../../maths/mat4")
local vec3 = require("../../maths/vec3")
local geom2 = require("../../geometries/geom2")
local slice = require("./slice")
local extrudeFromSlices = require("./extrudeFromSlices")
--[[
 * Extrude the given geometry using the given options.
 *
 * @param {Object} [options] - options for extrude
 * @param {Array} [options.offset] - the direction of the extrusion as a 3D vector
 * @param {Number} [options.twistAngle] - the final rotation (RADIANS) about the origin
 * @param {Integer} [options.twistSteps] - the number of steps created to produce the twist (if any)
 * @param {Boolean} [options.repair] - repair gaps in the geometry
 * @param {geom2} geometry - the geometry to extrude
 * @returns {geom3} the extruded 3D geometry
]]
local function extrudeGeom2(options, geometry)
	local defaults = { offset = { 0, 0, 1 }, twistAngle = 0, twistSteps = 12, repair = true }
	local offset, twistAngle, twistSteps, repair
	do
		local ref = Object.assign({}, defaults, options)
		offset, twistAngle, twistSteps, repair = ref.offset, ref.twistAngle, ref.twistSteps, ref.repair
	end
	if
		twistSteps
		< 1 --[[ ROBLOX CHECK: operator '<' works only if either both arguments are strings or both are a number ]]
	then
		error(Error.new("twistSteps must be 1 or more"))
	end
	if twistAngle == 0 then
		twistSteps = 1
	end -- convert to vector in order to perform transforms
	local offsetv = vec3.clone(offset)
	local baseSides = geom2.toSides(geometry)
	if #baseSides == 0 then
		error(Error.new("the given geometry cannot be empty"))
	end
	local baseSlice = slice.fromSides(baseSides)
	if
		offsetv[
			3 --[[ ROBLOX adaptation: added 1 to array index ]]
		]
		< 0 --[[ ROBLOX CHECK: operator '<' works only if either both arguments are strings or both are a number ]]
	then
		Array.reverse(slice, baseSlice, baseSlice) --[[ ROBLOX CHECK: check if 'slice' is an Array ]]
	end
	local matrix = mat4.create()
	local function createTwist(progress, index, base)
		local Zrotation = index / twistSteps * twistAngle
		local Zoffset = vec3.scale(vec3.create(), offsetv, index / twistSteps)
		mat4.multiply(matrix, mat4.fromZRotation(matrix, Zrotation), mat4.fromTranslation(mat4.create(), Zoffset))
		return slice.transform(matrix, base)
	end
	options = {
		numberOfSlices = twistSteps + 1,
		capStart = true,
		capEnd = true,
		repair = repair,
		callback = createTwist,
	}
	return extrudeFromSlices(options, baseSlice)
end
return extrudeGeom2
