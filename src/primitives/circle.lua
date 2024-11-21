-- ROBLOX NOTE: no upstream
local Packages = game.ReplicatedStorage.Packages
local LuauPolyfill = require(Packages.LuauPolyfill)
local Boolean = LuauPolyfill.Boolean
local Error = LuauPolyfill.Error
local Object = LuauPolyfill.Object
local TAU = require("../maths/constants").TAU
local ellipse = require("./ellipse")
local isGTE = require("./commonChecks").isGTE
--[=[*
 * Construct a circle in two dimensional space where all points are at the same distance from the center.
 * @see [ellipse]{@link module:modeling/primitives.ellipse} for more options
 * @param {Object} [options] - options for construction
 * @param {Array} [options.center=[0,0]] - center of circle
 * @param {Number} [options.radius=1] - radius of circle
 * @param {Number} [options.startAngle=0] - start angle of circle, in radians
 * @param {Number} [options.endAngle=TAU] - end angle of circle, in radians
 * @param {Number} [options.segments=32] - number of segments to create per full rotation
 * @returns {geom2} new 2D geometry
 * @alias module:modeling/primitives.circle
 * @example
 * let myshape = circle({radius: 10})
 ]=]
local function circle(options)
	local defaults = { center = { 0, 0 }, radius = 1, startAngle = 0, endAngle = TAU, segments = 32 }
	local center, radius, startAngle, endAngle, segments
	do
		local ref = Object.assign({}, defaults, options)
		center, radius, startAngle, endAngle, segments =
			ref.center, ref.radius, ref.startAngle, ref.endAngle, ref.segments
	end
	if not Boolean.toJSBoolean(isGTE(radius, 0)) then
		error(Error.new("radius must be positive"))
	end
	radius = { radius, radius }
	return ellipse({
		center = center,
		radius = radius,
		startAngle = startAngle,
		endAngle = endAngle,
		segments = segments,
	})
end
return circle
