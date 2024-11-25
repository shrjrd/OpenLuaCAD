-- ROBLOX NOTE: no upstream

local LuauPolyfill = require("@Packages/LuauPolyfill")
local Array = LuauPolyfill.Array
local Boolean = LuauPolyfill.Boolean
local Error = LuauPolyfill.Error
local Object = LuauPolyfill.Object
local TAU = require("../../maths/constants").TAU
local vec2 = require("../../maths/vec2")
local vec3 = require("../../maths/vec2")
local appendPoints = require("./appendPoints")
local toPoints = require("./toPoints")
--[=[*
 * Append a series of points to the given geometry that represent a Bezier curve.
 * The Bézier curve starts at the last point in the given geometry, and ends at the last control point.
 * The other control points are intermediate control points to transition the curve from start to end points.
 * The first control point may be null to ensure a smooth transition occurs. In this case,
 * the second to last point of the given geometry is mirrored into the control points of the Bezier curve.
 * In other words, the trailing gradient of the geometry matches the new gradient of the curve.
 * @param {Object} options - options for construction
 * @param {Array} options.controlPoints - list of control points (2D) for the bezier curve
 * @param {Number} [options.segment=16] - number of segments per 360 rotation
 * @param {path2} geometry - the path of which to appended points
 * @returns {path2} a new path with the appended points
 * @alias module:modeling/geometries/path2.appendBezier
 *
 * @example
 * let p5 = path2.create({}, [[10,-20]])
 * p5 = path2.appendBezier({controlPoints: [[10,-10],[25,-10],[25,-20]]}, p5);
 * p5 = path2.appendBezier({controlPoints: [null, [25,-30],[40,-30],[40,-20]]}, p5)
 ]=]
local function appendBezier(options, geometry)
	local defaults = { segments = 16 }
	local controlPoints, segments
	do
		local ref = Object.assign({}, defaults, options)
		controlPoints, segments = ref.controlPoints, ref.segments
	end -- validate the given options
	if not Boolean.toJSBoolean(Array.isArray(controlPoints)) then
		error(Error.new("controlPoints must be an array of one or more points"))
	end
	if
		#controlPoints
		< 1 --[[ ROBLOX CHECK: operator '<' works only if either both arguments are strings or both are a number ]]
	then
		error(Error.new("controlPoints must be an array of one or more points"))
	end
	if
		segments
		< 4 --[[ ROBLOX CHECK: operator '<' works only if either both arguments are strings or both are a number ]]
	then
		error(Error.new("segments must be four or more"))
	end -- validate the given geometry
	if Boolean.toJSBoolean(geometry.isClosed) then
		error(Error.new("the given geometry cannot be closed"))
	end
	local points = toPoints(geometry)
	if
		#points
		< 1 --[[ ROBLOX CHECK: operator '<' works only if either both arguments are strings or both are a number ]]
	then
		error(Error.new("the given path must contain one or more points (as the starting point for the bezier curve)"))
	end -- make a copy of the control points
	controlPoints = Array.slice(controlPoints) --[[ ROBLOX CHECK: check if 'controlPoints' is an Array ]] -- special handling of null control point (only first is allowed)
	local firstControlPoint = controlPoints[
		1 --[[ ROBLOX adaptation: added 1 to array index ]]
	]
	if firstControlPoint == nil then
		if
			#controlPoints
			< 2 --[[ ROBLOX CHECK: operator '<' works only if either both arguments are strings or both are a number ]]
		then
			error(Error.new("a null control point must be passed with one more control points"))
		end -- special handling of a previous bezier curve
		local lastBezierControlPoint = points[(#points - 2)]
		if Array.indexOf(Object.keys(geometry), "lastBezierControlPoint") ~= -1 then
			lastBezierControlPoint = geometry.lastBezierControlPoint
		end
		if not Boolean.toJSBoolean(Array.isArray(lastBezierControlPoint)) then
			error(Error.new("the given path must contain TWO or more points if given a null control point"))
		end -- replace the first control point with the mirror of the last bezier control point
		local controlpoint = vec2.scale(vec2.create(), points[(#points - 1)], 2)
		vec2.subtract(controlpoint, controlpoint, lastBezierControlPoint)
		controlPoints[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		] = controlpoint
	end -- add a control point for the previous end point
	table.insert(controlPoints, 1, points[(#points - 1)]) --[[ ROBLOX CHECK: check if 'controlPoints' is an Array ]]
	local bezierOrder = #controlPoints - 1
	local factorials = {}
	local fact = 1
	do
		local i = 0
		while
			i
			<= bezierOrder --[[ ROBLOX CHECK: operator '<=' works only if either both arguments are strings or both are a number ]]
		do
			if
				i
				> 0 --[[ ROBLOX CHECK: operator '>' works only if either both arguments are strings or both are a number ]]
			then
				fact *= i
			end
			table.insert(factorials, fact) --[[ ROBLOX CHECK: check if 'factorials' is an Array ]]
			i += 1
		end
	end
	local binomials = {}
	do
		local i = 0
		while
			i
			<= bezierOrder --[[ ROBLOX CHECK: operator '<=' works only if either both arguments are strings or both are a number ]]
		do
			local binomial = factorials[bezierOrder] / (factorials[i] * factorials[(bezierOrder - i)])
			table.insert(binomials, binomial) --[[ ROBLOX CHECK: check if 'binomials' is an Array ]]
			i += 1
		end
	end
	local v0 = vec2.create()
	local v1 = vec2.create()
	local v3 = vec3.create()
	local function getPointForT(t)
		local tk = 1 -- = pow(t,k)
		local oneMinusTNMinusK = math.pow(1 - t, bezierOrder) -- = pow( 1-t, bezierOrder - k)
		local invOneMinusT = if t ~= 1 then 1 / (1 - t) else 1
		local point = vec2.create() -- 0, 0, 0
		do
			local k = 0
			while
				k
				<= bezierOrder --[[ ROBLOX CHECK: operator '<=' works only if either both arguments are strings or both are a number ]]
			do
				if k == bezierOrder then
					oneMinusTNMinusK = 1
				end
				local bernsteinCoefficient = binomials[k] * tk * oneMinusTNMinusK
				local derivativePoint = vec2.scale(v0, controlPoints[k], bernsteinCoefficient)
				vec2.add(point, point, derivativePoint)
				tk *= t
				oneMinusTNMinusK *= invOneMinusT
				k += 1
			end
		end
		return point
	end
	local newpoints = {}
	local newpointsT = {}
	local numsteps = bezierOrder + 1
	do
		local i = 0
		while
			i
			< numsteps --[[ ROBLOX CHECK: operator '<' works only if either both arguments are strings or both are a number ]]
		do
			local t = i / (numsteps - 1)
			local point = getPointForT(t)
			table.insert(newpoints, point) --[[ ROBLOX CHECK: check if 'newpoints' is an Array ]]
			table.insert(newpointsT, t) --[[ ROBLOX CHECK: check if 'newpointsT' is an Array ]]
			i += 1
		end
	end -- subdivide each segment until the angle at each vertex becomes small enough:
	local subdivideBase = 1
	local maxangle = TAU / segments
	local maxsinangle = math.sin(maxangle)
	while
		subdivideBase
		< #newpoints - 1 --[[ ROBLOX CHECK: operator '<' works only if either both arguments are strings or both are a number ]]
	do
		local dir1 = vec2.subtract(v0, newpoints[subdivideBase], newpoints[(subdivideBase - 1)])
		vec2.normalize(dir1, dir1)
		local dir2 = vec2.subtract(v1, newpoints[(subdivideBase + 1)], newpoints[subdivideBase])
		vec2.normalize(dir2, dir2)
		local sinangle = vec2.cross(v3, dir1, dir2) -- the sine of the angle
		if
			math.abs(sinangle[
				3 --[[ ROBLOX adaptation: added 1 to array index ]]
			])
			> maxsinangle --[[ ROBLOX CHECK: operator '>' works only if either both arguments are strings or both are a number ]]
		then
			-- angle is too big, we need to subdivide
			local t0 = newpointsT[(subdivideBase - 1)]
			local t1 = newpointsT[(subdivideBase + 1)]
			local newt0 = t0 + (t1 - t0) * 1 / 3
			local newt1 = t0 + (t1 - t0) * 2 / 3
			local point0 = getPointForT(newt0)
			local point1 = getPointForT(newt1) -- remove the point at subdivideBase and replace with 2 new points:
			Array.splice(newpoints, subdivideBase, 1, point0, point1) --[[ ROBLOX CHECK: check if 'newpoints' is an Array ]]
			Array.splice(newpointsT, subdivideBase, 1, newt0, newt1) --[[ ROBLOX CHECK: check if 'newpointsT' is an Array ]] -- re - evaluate the angles, starting at the previous junction since it has changed:
			subdivideBase -= 1
			if
				subdivideBase
				< 1 --[[ ROBLOX CHECK: operator '<' works only if either both arguments are strings or both are a number ]]
			then
				subdivideBase = 1
			end
		else
			subdivideBase += 1
		end
	end -- append to the new points to the given path
	-- but skip the first new point because it is identical to the last point in the given path
	table.remove(newpoints, 1) --[[ ROBLOX CHECK: check if 'newpoints' is an Array ]]
	local result = appendPoints(newpoints, geometry)
	result.lastBezierControlPoint = controlPoints[(#controlPoints - 2)]
	return result
end
return appendBezier
