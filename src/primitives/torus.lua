-- ROBLOX NOTE: no upstream

local LuauPolyfill = require("@Packages/LuauPolyfill")
local Boolean = LuauPolyfill.Boolean
local Error = LuauPolyfill.Error
local Object = LuauPolyfill.Object
local TAU = require("../maths/constants").TAU
local extrudeRotate = require("../operations/extrusions/extrudeRotate")
local rotate = require("../operations/transforms/rotate").rotate
local translate = require("../operations/transforms/translate").translate
local circle = require("./circle")
local isGT, isGTE
do
	local ref = require("./commonChecks")
	isGT, isGTE = ref.isGT, ref.isGTE
end
--[[*
 * Construct a torus by revolving a small circle (inner) about the circumference of a large (outer) circle.
 * @param {Object} [options] - options for construction
 * @param {Number} [options.innerRadius=1] - radius of small (inner) circle
 * @param {Number} [options.outerRadius=4] - radius of large (outer) circle
 * @param {Integer} [options.innerSegments=32] - number of segments to create per rotation
 * @param {Integer} [options.outerSegments=32] - number of segments to create per rotation
 * @param {Integer} [options.innerRotation=0] - rotation of small (inner) circle in radians
 * @param {Number} [options.outerRotation=TAU] - rotation (outer) of the torus (RADIANS)
 * @param {Number} [options.startAngle=0] - start angle of the torus (RADIANS)
 * @returns {geom3} new 3D geometry
 * @alias module:modeling/primitives.torus
 *
 * @example
 * let myshape = torus({ innerRadius: 10, outerRadius: 100 })
 ]]
local function torus(options)
	local defaults = {
		innerRadius = 1,
		innerSegments = 32,
		outerRadius = 4,
		outerSegments = 32,
		innerRotation = 0,
		startAngle = 0,
		outerRotation = TAU,
	}
	local innerRadius, innerSegments, outerRadius, outerSegments, innerRotation, startAngle, outerRotation
	do
		local ref = Object.assign({}, defaults, options)
		innerRadius, innerSegments, outerRadius, outerSegments, innerRotation, startAngle, outerRotation =
			ref.innerRadius,
			ref.innerSegments,
			ref.outerRadius,
			ref.outerSegments,
			ref.innerRotation,
			ref.startAngle,
			ref.outerRotation
	end
	if not Boolean.toJSBoolean(isGT(innerRadius, 0)) then
		error(Error.new("innerRadius must be greater than zero"))
	end
	if not Boolean.toJSBoolean(isGTE(innerSegments, 3)) then
		error(Error.new("innerSegments must be three or more"))
	end
	if not Boolean.toJSBoolean(isGT(outerRadius, 0)) then
		error(Error.new("outerRadius must be greater than zero"))
	end
	if not Boolean.toJSBoolean(isGTE(outerSegments, 3)) then
		error(Error.new("outerSegments must be three or more"))
	end
	if not Boolean.toJSBoolean(isGTE(startAngle, 0)) then
		error(Error.new("startAngle must be positive"))
	end
	if not Boolean.toJSBoolean(isGT(outerRotation, 0)) then
		error(Error.new("outerRotation must be greater than zero"))
	end
	if
		innerRadius
		>= outerRadius --[[ ROBLOX CHECK: operator '>=' works only if either both arguments are strings or both are a number ]]
	then
		error(Error.new("inner circle is two large to rotate about the outer circle"))
	end
	local innerCircle = circle({ radius = innerRadius, segments = innerSegments })
	if innerRotation ~= 0 then
		innerCircle = rotate({ 0, 0, innerRotation }, innerCircle)
	end
	innerCircle = translate({ outerRadius, 0 }, innerCircle)
	local extrudeOptions = { startAngle = startAngle, angle = outerRotation, segments = outerSegments }
	return extrudeRotate(extrudeOptions, innerCircle)
end
return torus
