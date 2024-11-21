-- ROBLOX NOTE: no upstream
local Packages = game.ReplicatedStorage.Packages
local LuauPolyfill = require(Packages.LuauPolyfill)
local Boolean = LuauPolyfill.Boolean
local Error = LuauPolyfill.Error
local Object = LuauPolyfill.Object
local geom3 = require("../geometries/geom3")
local cylinderElliptic = require("./cylinderElliptic")
local isGTE = require("./commonChecks").isGTE
--[=[*
 * Construct a Z axis-aligned cylinder in three dimensional space.
 * @see [cylinderElliptic]{@link module:modeling/primitives.cylinderElliptic} for more options
 * @param {Object} [options] - options for construction
 * @param {Array} [options.center=[0,0,0]] - center of cylinder
 * @param {Number} [options.height=2] - height of cylinder
 * @param {Number} [options.radius=1] - radius of cylinder (at both start and end)
 * @param {Number} [options.segments=32] - number of segments to create per full rotation
 * @returns {geom3} new geometry
 * @alias module:modeling/primitives.cylinder
 *
 * @example
 * let myshape = cylinder({height: 2, radius: 10})
 ]=]
local function cylinder(options)
	local defaults = { center = { 0, 0, 0 }, height = 2, radius = 1, segments = 32 }
	local center, height, radius, segments
	do
		local ref = Object.assign({}, defaults, options)
		center, height, radius, segments = ref.center, ref.height, ref.radius, ref.segments
	end
	if not Boolean.toJSBoolean(isGTE(radius, 0)) then
		error(Error.new("radius must be positive"))
	end -- if size is zero return empty geometry
	if height == 0 or radius == 0 then
		return geom3.create()
	end
	local newoptions = {
		center = center,
		height = height,
		startRadius = { radius, radius },
		endRadius = { radius, radius },
		segments = segments,
	}
	return cylinderElliptic(newoptions)
end
return cylinder
