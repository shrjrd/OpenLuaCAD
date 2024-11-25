-- ROBLOX NOTE: no upstream

local LuauPolyfill = require("@Packages/LuauPolyfill")
local Array = LuauPolyfill.Array
local Boolean = LuauPolyfill.Boolean
local Error = LuauPolyfill.Error
local Object = LuauPolyfill.Object
local EPS, TAU
do
	local ref = require("../maths/constants")
	EPS, TAU = ref.EPS, ref.TAU
end
local vec3 = require("../maths/vec3")
local geom3 = require("../geometries/geom3")
local poly3 = require("../geometries/poly3")
local sin, cos
do
	local ref = require("../maths/utils/trigonometry")
	sin, cos = ref.sin, ref.cos
end
local isGT, isGTE, isNumberArray
do
	local ref = require("./commonChecks")
	isGT, isGTE, isNumberArray = ref.isGT, ref.isGTE, ref.isNumberArray
end
--[=[*
 * Construct a Z axis-aligned elliptic cylinder in three dimensional space.
 * @param {Object} [options] - options for construction
 * @param {Array} [options.center=[0,0,0]] - center of cylinder
 * @param {Number} [options.height=2] - height of cylinder
 * @param {Array} [options.startRadius=[1,1]] - radius of rounded start, must be two dimensional array
 * @param {Number} [options.startAngle=0] - start angle of cylinder, in radians
 * @param {Array} [options.endRadius=[1,1]] - radius of rounded end, must be two dimensional array
 * @param {Number} [options.endAngle=TAU] - end angle of cylinder, in radians
 * @param {Number} [options.segments=32] - number of segments to create per full rotation
 * @returns {geom3} new geometry
 * @alias module:modeling/primitives.cylinderElliptic
 *
 * @example
 * let myshape = cylinderElliptic({height: 2, startRadius: [10,5], endRadius: [8,3]})
 ]=]
local function cylinderElliptic(options)
	local defaults = {
		center = { 0, 0, 0 },
		height = 2,
		startRadius = { 1, 1 },
		startAngle = 0,
		endRadius = { 1, 1 },
		endAngle = TAU,
		segments = 32,
	}
	local center, height, startRadius, startAngle, endRadius, endAngle, segments
	do
		local ref = Object.assign({}, defaults, options)
		center, height, startRadius, startAngle, endRadius, endAngle, segments =
			ref.center, ref.height, ref.startRadius, ref.startAngle, ref.endRadius, ref.endAngle, ref.segments
	end
	if not Boolean.toJSBoolean(isNumberArray(center, 3)) then
		error(Error.new("center must be an array of X, Y and Z values"))
	end
	if not Boolean.toJSBoolean(isGT(height, 0)) then
		error(Error.new("height must be greater then zero"))
	end
	if not Boolean.toJSBoolean(isNumberArray(startRadius, 2)) then
		error(Error.new("startRadius must be an array of X and Y values"))
	end
	if
		not Boolean.toJSBoolean(Array.every(startRadius, function(n)
			return n >= 0 --[[ ROBLOX CHECK: operator '>=' works only if either both arguments are strings or both are a number ]]
		end) --[[ ROBLOX CHECK: check if 'startRadius' is an Array ]])
	then
		error(Error.new("startRadius values must be positive"))
	end
	if not Boolean.toJSBoolean(isNumberArray(endRadius, 2)) then
		error(Error.new("endRadius must be an array of X and Y values"))
	end
	if
		not Boolean.toJSBoolean(Array.every(endRadius, function(n)
			return n >= 0 --[[ ROBLOX CHECK: operator '>=' works only if either both arguments are strings or both are a number ]]
		end) --[[ ROBLOX CHECK: check if 'endRadius' is an Array ]])
	then
		error(Error.new("endRadius values must be positive"))
	end
	if
		Boolean.toJSBoolean((function()
			local ref = Array.every(endRadius, function(n)
				return n == 0
			end) --[[ ROBLOX CHECK: check if 'endRadius' is an Array ]]
			return if Boolean.toJSBoolean(ref)
				then Array.every(startRadius, function(n)
					return n == 0
				end) --[[ ROBLOX CHECK: check if 'startRadius' is an Array ]]
				else ref
		end)())
	then
		error(Error.new("at least one radius must be positive"))
	end
	if not Boolean.toJSBoolean(isGTE(startAngle, 0)) then
		error(Error.new("startAngle must be positive"))
	end
	if not Boolean.toJSBoolean(isGTE(endAngle, 0)) then
		error(Error.new("endAngle must be positive"))
	end
	if not Boolean.toJSBoolean(isGTE(segments, 4)) then
		error(Error.new("segments must be four or more"))
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
		startRadius[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		],
		startRadius[
			2 --[[ ROBLOX adaptation: added 1 to array index ]]
		],
		endRadius[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		],
		endRadius[
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
	local slices = math.floor(segments * (rotation / TAU))
	local start = vec3.fromValues(0, 0, -(height / 2))
	local end_ = vec3.fromValues(0, 0, height / 2)
	local ray = vec3.subtract(vec3.create(), end_, start)
	local axisX = vec3.fromValues(1, 0, 0)
	local axisY = vec3.fromValues(0, 1, 0)
	local v1 = vec3.create()
	local v2 = vec3.create()
	local v3 = vec3.create()
	local function point(stack, slice, radius)
		local angle = slice * rotation + startAngle
		vec3.scale(v1, axisX, radius[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		] * cos(angle))
		vec3.scale(v2, axisY, radius[
			2 --[[ ROBLOX adaptation: added 1 to array index ]]
		] * sin(angle))
		vec3.add(v1, v1, v2)
		vec3.scale(v3, ray, stack)
		vec3.add(v3, v3, start)
		return vec3.add(vec3.create(), v1, v3)
	end -- adjust the points to center
	local function fromPoints(
		...: any --[[ ROBLOX CHECK: check correct type of elements. ]]
	)
		local points = { ... }
		local newpoints = Array.map(points, function(point)
			return vec3.add(vec3.create(), point, center)
		end) --[[ ROBLOX CHECK: check if 'points' is an Array ]]
		return poly3.create(newpoints)
	end
	local polygons = {}
	do
		local i = 0
		while
			i
			< slices --[[ ROBLOX CHECK: operator '<' works only if either both arguments are strings or both are a number ]]
		do
			local t0 = i / slices
			local t1 = (i + 1) / slices -- fix rounding error when rotating TAU radians
			if rotation == TAU and i == slices - 1 then
				t1 = 0
			end
			if
				endRadius[
						1 --[[ ROBLOX adaptation: added 1 to array index ]]
					]
					== startRadius[
						1 --[[ ROBLOX adaptation: added 1 to array index ]]
					]
				and endRadius[
						2 --[[ ROBLOX adaptation: added 1 to array index ]]
					]
					== startRadius[
						2 --[[ ROBLOX adaptation: added 1 to array index ]]
					]
			then
				table.insert(polygons, fromPoints(start, point(0, t1, endRadius), point(0, t0, endRadius))) --[[ ROBLOX CHECK: check if 'polygons' is an Array ]]
				table.insert(
					polygons,
					fromPoints(
						point(0, t1, endRadius),
						point(1, t1, endRadius),
						point(1, t0, endRadius),
						point(0, t0, endRadius)
					)
				) --[[ ROBLOX CHECK: check if 'polygons' is an Array ]]
				table.insert(polygons, fromPoints(end_, point(1, t0, endRadius), point(1, t1, endRadius))) --[[ ROBLOX CHECK: check if 'polygons' is an Array ]]
			else
				if
					startRadius[
						1 --[[ ROBLOX adaptation: added 1 to array index ]]
					] > 0 --[[ ROBLOX CHECK: operator '>' works only if either both arguments are strings or both are a number ]]
					and startRadius[
						2 --[[ ROBLOX adaptation: added 1 to array index ]]
					] > 0 --[[ ROBLOX CHECK: operator '>' works only if either both arguments are strings or both are a number ]]
				then
					table.insert(polygons, fromPoints(start, point(0, t1, startRadius), point(0, t0, startRadius))) --[[ ROBLOX CHECK: check if 'polygons' is an Array ]]
				end
				if
					startRadius[
						1 --[[ ROBLOX adaptation: added 1 to array index ]]
					] > 0 --[[ ROBLOX CHECK: operator '>' works only if either both arguments are strings or both are a number ]]
					or startRadius[
						2 --[[ ROBLOX adaptation: added 1 to array index ]]
					] > 0 --[[ ROBLOX CHECK: operator '>' works only if either both arguments are strings or both are a number ]]
				then
					table.insert(
						polygons,
						fromPoints(point(0, t0, startRadius), point(0, t1, startRadius), point(1, t0, endRadius))
					) --[[ ROBLOX CHECK: check if 'polygons' is an Array ]]
				end
				if
					endRadius[
						1 --[[ ROBLOX adaptation: added 1 to array index ]]
					] > 0 --[[ ROBLOX CHECK: operator '>' works only if either both arguments are strings or both are a number ]]
					and endRadius[
						2 --[[ ROBLOX adaptation: added 1 to array index ]]
					] > 0 --[[ ROBLOX CHECK: operator '>' works only if either both arguments are strings or both are a number ]]
				then
					table.insert(polygons, fromPoints(end_, point(1, t0, endRadius), point(1, t1, endRadius))) --[[ ROBLOX CHECK: check if 'polygons' is an Array ]]
				end
				if
					endRadius[
						1 --[[ ROBLOX adaptation: added 1 to array index ]]
					] > 0 --[[ ROBLOX CHECK: operator '>' works only if either both arguments are strings or both are a number ]]
					or endRadius[
						2 --[[ ROBLOX adaptation: added 1 to array index ]]
					] > 0 --[[ ROBLOX CHECK: operator '>' works only if either both arguments are strings or both are a number ]]
				then
					table.insert(
						polygons,
						fromPoints(point(1, t0, endRadius), point(0, t1, startRadius), point(1, t1, endRadius))
					) --[[ ROBLOX CHECK: check if 'polygons' is an Array ]]
				end
			end
			i += 1
		end
	end
	if
		rotation
		< TAU --[[ ROBLOX CHECK: operator '<' works only if either both arguments are strings or both are a number ]]
	then
		table.insert(polygons, fromPoints(start, point(0, 0, startRadius), end_)) --[[ ROBLOX CHECK: check if 'polygons' is an Array ]]
		table.insert(polygons, fromPoints(point(0, 0, startRadius), point(1, 0, endRadius), end_)) --[[ ROBLOX CHECK: check if 'polygons' is an Array ]]
		table.insert(polygons, fromPoints(start, end_, point(0, 1, startRadius))) --[[ ROBLOX CHECK: check if 'polygons' is an Array ]]
		table.insert(polygons, fromPoints(point(0, 1, startRadius), end_, point(1, 1, endRadius))) --[[ ROBLOX CHECK: check if 'polygons' is an Array ]]
	end
	local result = geom3.create(polygons)
	return result
end
return cylinderElliptic
