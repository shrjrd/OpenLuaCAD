-- ROBLOX NOTE: no upstream

local LuauPolyfill = require("@Packages/LuauPolyfill")
local Boolean = LuauPolyfill.Boolean
local Error = LuauPolyfill.Error
local Object = LuauPolyfill.Object
local rectangle = require("./rectangle")
local isGTE = require("./commonChecks").isGTE
--[=[*
 * Construct an axis-aligned square in two dimensional space with four equal sides at right angles.
 * @see [rectangle]{@link module:modeling/primitives.rectangle} for more options
 * @param {Object} [options] - options for construction
 * @param {Array} [options.center=[0,0]] - center of square
 * @param {Number} [options.size=2] - dimension of square
 * @returns {geom2} new 2D geometry
 * @alias module:modeling/primitives.square
 *
 * @example
 * let myshape = square({size: 10})
 ]=]
local function square(options)
	local defaults = { center = { 0, 0 }, size = 2 }
	local center, size
	do
		local ref = Object.assign({}, defaults, options)
		center, size = ref.center, ref.size
	end
	if not Boolean.toJSBoolean(isGTE(size, 0)) then
		error(Error.new("size must be positive"))
	end
	size = { size, size }
	return rectangle({ center = center, size = size })
end
return square
