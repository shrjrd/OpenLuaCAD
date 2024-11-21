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
local sin, cos
do
	local ref = require("../maths/utils/trigonometry")
	sin, cos = ref.sin, ref.cos
end
local isGTE, isNumberArray
do
	local ref = require("./commonChecks")
	isGTE, isNumberArray = ref.isGTE, ref.isNumberArray
end
--[=[*
 * Construct an axis-aligned ellipse in two dimensional space.
 * @see https://en.wikipedia.org/wiki/Ellipse
 * @param {Object} [options] - options for construction
 * @param {Array} [options.center=[0,0]] - center of ellipse
 * @param {Array} [options.radius=[1,1]] - radius of ellipse, along X and Y
 * @param {Number} [options.startAngle=0] - start angle of ellipse, in radians
 * @param {Number} [options.endAngle=TAU] - end angle of ellipse, in radians
 * @param {Number} [options.segments=32] - number of segments to create per full rotation
 * @returns {geom2} new 2D geometry
 * @alias module:modeling/primitives.ellipse
 * @example
 * let myshape = ellipse({radius: [5,10]})
 ]=]
local function ellipse(options)
	local defaults = { center = { 0, 0 }, radius = { 1, 1 }, startAngle = 0, endAngle = TAU, segments = 32 }
	local center, radius, startAngle, endAngle, segments
	do
		local ref = Object.assign({}, defaults, options)
		center, radius, startAngle, endAngle, segments =
			ref.center, ref.radius, ref.startAngle, ref.endAngle, ref.segments
	end
	if not Boolean.toJSBoolean(isNumberArray(center, 2)) then
		error(Error.new("center must be an array of X and Y values"))
	end
	if not Boolean.toJSBoolean(isNumberArray(radius, 2)) then
		error(Error.new("radius must be an array of X and Y values"))
	end
	if
		not Boolean.toJSBoolean(Array.every(radius, function(n)
			return n >= 0 --[[ ROBLOX CHECK: operator '>=' works only if either both arguments are strings or both are a number ]]
		end) --[[ ROBLOX CHECK: check if 'radius' is an Array ]])
	then
		error(Error.new("radius values must be positive"))
	end
	if not Boolean.toJSBoolean(isGTE(startAngle, 0)) then
		error(Error.new("startAngle must be positive"))
	end
	if not Boolean.toJSBoolean(isGTE(endAngle, 0)) then
		error(Error.new("endAngle must be positive"))
	end
	if not Boolean.toJSBoolean(isGTE(segments, 3)) then
		error(Error.new("segments must be three or more"))
	end -- if any radius is zero return empty geometry
	if
		radius[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		] == 0 or radius[
			2 --[[ ROBLOX adaptation: added 1 to array index ]]
		] == 0
	then
		return geom2.create()
	end
	startAngle = startAngle % TAU
	endAngle = endAngle % TAU
	local rotation = TAU
	if
		startAngle
		< endAngle --[[ ROBLOX CHECK: operator '<' works only if either both arguments are strings or both are a number ]]
	then
		rotation = endAngle - startAngle
	end
	if
		startAngle
		> endAngle --[[ ROBLOX CHECK: operator '>' works only if either both arguments are strings or both are a number ]]
	then
		rotation = endAngle + (TAU - startAngle)
	end
	local minradius = math.min(
		radius[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		],
		radius[
			2 --[[ ROBLOX adaptation: added 1 to array index ]]
		]
	)
	local minangle =
		math.acos((minradius * minradius + minradius * minradius - EPS * EPS) / (2 * minradius * minradius))
	if
		rotation
		< minangle --[[ ROBLOX CHECK: operator '<' works only if either both arguments are strings or both are a number ]]
	then
		error(Error.new("startAngle and endAngle do not define a significant rotation"))
	end
	segments = math.floor(segments * (rotation / TAU))
	local centerv = vec2.clone(center)
	local step = rotation / segments -- radians per segment
	local points = {}
	segments = if rotation
			< TAU --[[ ROBLOX CHECK: operator '<' works only if either both arguments are strings or both are a number ]]
		then segments + 1
		else segments
	do
		local i = 0
		while
			i
			< segments --[[ ROBLOX CHECK: operator '<' works only if either both arguments are strings or both are a number ]]
		do
			local angle = step * i + startAngle
			local point = vec2.fromValues(radius[
				1 --[[ ROBLOX adaptation: added 1 to array index ]]
			] * cos(angle), radius[
				2 --[[ ROBLOX adaptation: added 1 to array index ]]
			] * sin(angle))
			vec2.add(point, centerv, point)
			table.insert(points, point) --[[ ROBLOX CHECK: check if 'points' is an Array ]]
			i += 1
		end
	end
	if
		rotation
		< TAU --[[ ROBLOX CHECK: operator '<' works only if either both arguments are strings or both are a number ]]
	then
		table.insert(points, centerv) --[[ ROBLOX CHECK: check if 'points' is an Array ]]
	end
	return geom2.fromPoints(points)
end
return ellipse
