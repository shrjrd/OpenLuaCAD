-- ROBLOX NOTE: no upstream
local Packages = game.ReplicatedStorage.Packages
local LuauPolyfill = require(Packages.LuauPolyfill)
local Array = LuauPolyfill.Array
local Boolean = LuauPolyfill.Boolean
local Error = LuauPolyfill.Error
local Object = LuauPolyfill.Object
local EPS, TAU
do
	local ref = require("../maths/constants")
	EPS, TAU = ref.EPS, ref.TAU
end
local vec2 = require("../maths/vec2")
local geom2 = require("../geometries/geom2")
local isGTE, isNumberArray
do
	local ref = require("./commonChecks")
	isGTE, isNumberArray = ref.isGTE, ref.isNumberArray
end
local rectangle = require("./rectangle")
--[=[*
 * Construct an axis-aligned rectangle in two dimensional space with rounded corners.
 * @param {Object} [options] - options for construction
 * @param {Array} [options.center=[0,0]] - center of rounded rectangle
 * @param {Array} [options.size=[2,2]] - dimension of rounded rectangle; width and length
 * @param {Number} [options.roundRadius=0.2] - round radius of corners
 * @param {Number} [options.segments=32] - number of segments to create per full rotation
 * @returns {geom2} new 2D geometry
 * @alias module:modeling/primitives.roundedRectangle
 *
 * @example
 * let myshape = roundedRectangle({size: [10, 20], roundRadius: 2})
 ]=]
local function roundedRectangle(options)
	local defaults = { center = { 0, 0 }, size = { 2, 2 }, roundRadius = 0.2, segments = 32 }
	local center, size, roundRadius, segments
	do
		local ref = Object.assign({}, defaults, options)
		center, size, roundRadius, segments = ref.center, ref.size, ref.roundRadius, ref.segments
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
	end
	if not Boolean.toJSBoolean(isGTE(roundRadius, 0)) then
		error(Error.new("roundRadius must be positive"))
	end
	if not Boolean.toJSBoolean(isGTE(segments, 4)) then
		error(Error.new("segments must be four or more"))
	end -- if any size is zero return empty geometry
	if
		size[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		] == 0 or size[
			2 --[[ ROBLOX adaptation: added 1 to array index ]]
		] == 0
	then
		return geom2.create()
	end -- if roundRadius is zero, return rectangle
	if roundRadius == 0 then
		return rectangle({ center = center, size = size })
	end
	size = Array.map(size, function(v)
		return v / 2
	end) --[[ ROBLOX CHECK: check if 'size' is an Array ]] -- convert to radius
	if
		roundRadius > size[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		] - EPS --[[ ROBLOX CHECK: operator '>' works only if either both arguments are strings or both are a number ]]
		or roundRadius > size[
			2 --[[ ROBLOX adaptation: added 1 to array index ]]
		] - EPS --[[ ROBLOX CHECK: operator '>' works only if either both arguments are strings or both are a number ]]
	then
		error(Error.new("roundRadius must be smaller than the radius of all dimensions"))
	end
	local cornersegments = math.floor(segments / 4) -- create sets of points that define the corners
	local corner0 = vec2.add(vec2.create(), center, {
		size[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		] - roundRadius,
		size[
			2 --[[ ROBLOX adaptation: added 1 to array index ]]
		] - roundRadius,
	})
	local corner1 = vec2.add(vec2.create(), center, {
		roundRadius - size[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		],
		size[
			2 --[[ ROBLOX adaptation: added 1 to array index ]]
		] - roundRadius,
	})
	local corner2 = vec2.add(vec2.create(), center, {
		roundRadius - size[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		],
		roundRadius - size[
			2 --[[ ROBLOX adaptation: added 1 to array index ]]
		],
	})
	local corner3 = vec2.add(vec2.create(), center, {
		size[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		] - roundRadius,
		roundRadius - size[
			2 --[[ ROBLOX adaptation: added 1 to array index ]]
		],
	})
	local corner0Points = {}
	local corner1Points = {}
	local corner2Points = {}
	local corner3Points = {}
	do
		local i = 0
		while
			i
			<= cornersegments --[[ ROBLOX CHECK: operator '<=' works only if either both arguments are strings or both are a number ]]
		do
			local radians = TAU / 4 * i / cornersegments
			local point = vec2.fromAngleRadians(vec2.create(), radians)
			vec2.scale(point, point, roundRadius)
			table.insert(corner0Points, vec2.add(vec2.create(), corner0, point)) --[[ ROBLOX CHECK: check if 'corner0Points' is an Array ]]
			vec2.rotate(point, point, vec2.create(), TAU / 4)
			table.insert(corner1Points, vec2.add(vec2.create(), corner1, point)) --[[ ROBLOX CHECK: check if 'corner1Points' is an Array ]]
			vec2.rotate(point, point, vec2.create(), TAU / 4)
			table.insert(corner2Points, vec2.add(vec2.create(), corner2, point)) --[[ ROBLOX CHECK: check if 'corner2Points' is an Array ]]
			vec2.rotate(point, point, vec2.create(), TAU / 4)
			table.insert(corner3Points, vec2.add(vec2.create(), corner3, point)) --[[ ROBLOX CHECK: check if 'corner3Points' is an Array ]]
			i += 1
		end
	end
	return geom2.fromPoints(
		Array.concat(corner0Points, corner1Points, corner2Points, corner3Points) --[[ ROBLOX CHECK: check if 'corner0Points' is an Array ]]
	)
end
return roundedRectangle
