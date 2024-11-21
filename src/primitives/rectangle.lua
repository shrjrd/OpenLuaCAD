-- ROBLOX NOTE: no upstream
local Packages = game.ReplicatedStorage.Packages
local LuauPolyfill = require(Packages.LuauPolyfill)
local Array = LuauPolyfill.Array
local Boolean = LuauPolyfill.Boolean
local Error = LuauPolyfill.Error
local Object = LuauPolyfill.Object
local vec2 = require("../maths/vec2")
local geom2 = require("../geometries/geom2")
local isNumberArray = require("./commonChecks").isNumberArray
--[=[*
 * Construct an axis-aligned rectangle in two dimensional space with four sides at right angles.
 * @param {Object} [options] - options for construction
 * @param {Array} [options.center=[0,0]] - center of rectangle
 * @param {Array} [options.size=[2,2]] - dimension of rectangle, width and length
 * @returns {geom2} new 2D geometry
 * @alias module:modeling/primitives.rectangle
 *
 * @example
 * let myshape = rectangle({size: [10, 20]})
 ]=]
local function rectangle(options)
	local defaults = { center = { 0, 0 }, size = { 2, 2 } }
	local center, size
	do
		local ref = Object.assign({}, defaults, options)
		center, size = ref.center, ref.size
	end
	if not Boolean.toJSBoolean(isNumberArray(center, 2)) then
		error(Error.new("center must be an array of X and Y values"))
	end
	if not Boolean.toJSBoolean(isNumberArray(size, 2)) then
		error(Error.new("size must be an array of X and Y values"))
	end
	if
		not Boolean.toJSBoolean(Array.every(size, function(n)
			return n >= 0 --[[ ROBLOX CHECK: operator '>=' works only if either both arguments are strings or both are a number ]]
		end) --[[ ROBLOX CHECK: check if 'size' is an Array ]])
	then
		error(Error.new("size values must be positive"))
	end -- if any size is zero return empty geometry
	if
		size[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		] == 0 or size[
			2 --[[ ROBLOX adaptation: added 1 to array index ]]
		] == 0
	then
		return geom2.create()
	end
	local point = {
		size[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		] / 2,
		size[
			2 --[[ ROBLOX adaptation: added 1 to array index ]]
		] / 2,
	}
	local pswap = {
		point[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		],
		-point[
			2 --[[ ROBLOX adaptation: added 1 to array index ]]
		],
	}
	local points = {
		vec2.subtract(vec2.create(), center, point),
		vec2.add(vec2.create(), center, pswap),
		vec2.add(vec2.create(), center, point),
		vec2.subtract(vec2.create(), center, pswap),
	}
	return geom2.fromPoints(points)
end
return rectangle
