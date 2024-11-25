-- ROBLOX NOTE: no upstream

local LuauPolyfill = require("@Packages/LuauPolyfill")
local Boolean = LuauPolyfill.Boolean
local Error = LuauPolyfill.Error
local Object = LuauPolyfill.Object
local cuboid = require("./cuboid")
local isGTE = require("./commonChecks").isGTE
--[=[*
 * Construct an axis-aligned solid cube in three dimensional space with six square faces.
 * @see [cuboid]{@link module:modeling/primitives.cuboid} for more options
 * @param {Object} [options] - options for construction
 * @param {Array} [options.center=[0,0,0]] - center of cube
 * @param {Number} [options.size=2] - dimension of cube
 * @returns {geom3} new 3D geometry
 * @alias module:modeling/primitives.cube
 * @example
 * let myshape = cube({size: 10})
 ]=]
local function cube(options)
	local defaults = { center = { 0, 0, 0 }, size = 2 }
	local center, size
	do
		local ref = Object.assign({}, defaults, options)
		center, size = ref.center, ref.size
	end
	if not Boolean.toJSBoolean(isGTE(size, 0)) then
		error(Error.new("size must be positive"))
	end
	size = { size, size, size }
	return cuboid({ center = center, size = size })
end
return cube
