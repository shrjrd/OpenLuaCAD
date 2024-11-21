-- ROBLOX NOTE: no upstream
local Packages = game.ReplicatedStorage.Packages
local LuauPolyfill = require(Packages.LuauPolyfill)
local Boolean = LuauPolyfill.Boolean
local Error = LuauPolyfill.Error
local Object = LuauPolyfill.Object
local ellipsoid = require("./ellipsoid")
local isGTE = require("./commonChecks").isGTE
--[=[*
 * Construct a sphere in three dimensional space where all points are at the same distance from the center.
 * @see [ellipsoid]{@link module:modeling/primitives.ellipsoid} for more options
 * @param {Object} [options] - options for construction
 * @param {Array} [options.center=[0,0,0]] - center of sphere
 * @param {Number} [options.radius=1] - radius of sphere
 * @param {Number} [options.segments=32] - number of segments to create per full rotation
 * @param {Array} [options.axes] -  an array with three vectors for the x, y and z base vectors
 * @returns {geom3} new 3D geometry
 * @alias module:modeling/primitives.sphere
 *
 * @example
 * let myshape = sphere({radius: 5})
 ]=]
local function sphere(options)
	local defaults = {
		center = { 0, 0, 0 },
		radius = 1,
		segments = 32,
		axes = { { 1, 0, 0 }, { 0, -1, 0 }, { 0, 0, 1 } },
	}
	local center, radius, segments, axes
	do
		local ref = Object.assign({}, defaults, options)
		center, radius, segments, axes = ref.center, ref.radius, ref.segments, ref.axes
	end
	if not Boolean.toJSBoolean(isGTE(radius, 0)) then
		error(Error.new("radius must be positive"))
	end
	radius = { radius, radius, radius }
	return ellipsoid({ center = center, radius = radius, segments = segments, axes = axes })
end
return sphere
