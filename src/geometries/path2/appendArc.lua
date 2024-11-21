-- ROBLOX NOTE: no upstream
local Packages = game.ReplicatedStorage.Packages
local LuauPolyfill = require(Packages.LuauPolyfill)
local Array = LuauPolyfill.Array
local Boolean = LuauPolyfill.Boolean
local Error = LuauPolyfill.Error
local Math = LuauPolyfill.Math
local Object = LuauPolyfill.Object
local TAU = require("../../maths/constants").TAU
local vec2 = require("../../maths/vec2")
local fromPoints = require("./fromPoints")
local toPoints = require("./toPoints")
--[=[*
 * Append a series of points to the given geometry that represent an arc.
 * This implementation follows the SVG specifications.
 * @see http://www.w3.org/TR/SVG/paths.html#PathDataEllipticalArcCommands
 * @param {Object} options - options for construction
 * @param {vec2} options.endpoint - end point of arc (REQUIRED)
 * @param {vec2} [options.radius=[0,0]] - radius of arc (X and Y)
 * @param {Number} [options.xaxisrotation=0] - rotation (RADIANS) of the X axis of the arc with respect to the X axis of the coordinate system
 * @param {Boolean} [options.clockwise=false] - draw an arc clockwise with respect to the center point
 * @param {Boolean} [options.large=false] - draw an arc longer than TAU / 2 radians
 * @param {Number} [options.segments=16] - number of segments per full rotation
 * @param {path2} geometry - the path of which to append the arc
 * @returns {path2} a new path with the appended points
 * @alias module:modeling/geometries/path2.appendArc
 *
 * @example
 * let p1 = path2.fromPoints({}, [[27.5,-22.96875]]);
 * p1 = path2.appendPoints([[27.5,-3.28125]], p1);
 * p1 = path2.appendArc({endpoint: [12.5, -22.96875], radius: [15, -19.6875]}, p1);
 ]=]
local function appendArc(options, geometry)
	local defaults = {
		radius = { 0, 0 },
		-- X and Y radius
		xaxisrotation = 0,
		clockwise = false,
		large = false,
		segments = 16,
	}
	local endpoint, radius, xaxisrotation, clockwise, large, segments
	do
		local ref = Object.assign({}, defaults, options)
		endpoint, radius, xaxisrotation, clockwise, large, segments =
			ref.endpoint, ref.radius, ref.xaxisrotation, ref.clockwise, ref.large, ref.segments
	end -- validate the given options
	if not Boolean.toJSBoolean(Array.isArray(endpoint)) then
		error(Error.new("endpoint must be an array of X and Y values"))
	end
	if
		#endpoint
		< 2 --[[ ROBLOX CHECK: operator '<' works only if either both arguments are strings or both are a number ]]
	then
		error(Error.new("endpoint must contain X and Y values"))
	end
	endpoint = vec2.clone(endpoint)
	if not Boolean.toJSBoolean(Array.isArray(radius)) then
		error(Error.new("radius must be an array of X and Y values"))
	end
	if
		#radius
		< 2 --[[ ROBLOX CHECK: operator '<' works only if either both arguments are strings or both are a number ]]
	then
		error(Error.new("radius must contain X and Y values"))
	end
	if
		segments
		< 4 --[[ ROBLOX CHECK: operator '<' works only if either both arguments are strings or both are a number ]]
	then
		error(Error.new("segments must be four or more"))
	end
	local decimals = 100000 -- validate the given geometry
	if Boolean.toJSBoolean(geometry.isClosed) then
		error(Error.new("the given path cannot be closed"))
	end
	local points = toPoints(geometry)
	if
		#points
		< 1 --[[ ROBLOX CHECK: operator '<' works only if either both arguments are strings or both are a number ]]
	then
		error(Error.new("the given path must contain one or more points (as the starting point for the arc)"))
	end
	local xradius = radius[
		1 --[[ ROBLOX adaptation: added 1 to array index ]]
	]
	local yradius = radius[
		2 --[[ ROBLOX adaptation: added 1 to array index ]]
	]
	local startpoint = points[(#points - 1)] -- round to precision in order to have determinate calculations
	xradius = Math.round(xradius * decimals) --[[ ROBLOX NOTE: Math.round is currently not supported by the Luau Math polyfill, please add your own implementation or file a ticket on the same ]]
		/ decimals
	yradius = Math.round(yradius * decimals) --[[ ROBLOX NOTE: Math.round is currently not supported by the Luau Math polyfill, please add your own implementation or file a ticket on the same ]]
		/ decimals
	endpoint = vec2.fromValues(
		Math.round(endpoint[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		] * decimals) --[[ ROBLOX NOTE: Math.round is currently not supported by the Luau Math polyfill, please add your own implementation or file a ticket on the same ]]
			/ decimals,
		Math.round(endpoint[
			2 --[[ ROBLOX adaptation: added 1 to array index ]]
		] * decimals) --[[ ROBLOX NOTE: Math.round is currently not supported by the Luau Math polyfill, please add your own implementation or file a ticket on the same ]]
			/ decimals
	)
	local sweepFlag = not Boolean.toJSBoolean(clockwise)
	local newpoints = {}
	if xradius == 0 or yradius == 0 then
		-- http://www.w3.org/TR/SVG/implnote.html#ArcImplementationNotes:
		-- If rx = 0 or ry = 0, then treat this as a straight line from (x1, y1) to (x2, y2) and stop
		table.insert(newpoints, endpoint) --[[ ROBLOX CHECK: check if 'newpoints' is an Array ]]
	else
		xradius = math.abs(xradius)
		yradius = math.abs(yradius) -- see http://www.w3.org/TR/SVG/implnote.html#ArcImplementationNotes :
		local phi = xaxisrotation
		local cosphi = math.cos(phi)
		local sinphi = math.sin(phi)
		local minushalfdistance = vec2.subtract(vec2.create(), startpoint, endpoint)
		vec2.scale(minushalfdistance, minushalfdistance, 0.5) -- F.6.5.1:
		-- round to precision in order to have determinate calculations
		local x = Math.round((cosphi * minushalfdistance[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		] + sinphi * minushalfdistance[
			2 --[[ ROBLOX adaptation: added 1 to array index ]]
		]) * decimals) --[[ ROBLOX NOTE: Math.round is currently not supported by the Luau Math polyfill, please add your own implementation or file a ticket on the same ]]
			/ decimals
		local y = Math.round((-sinphi * minushalfdistance[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		] + cosphi * minushalfdistance[
			2 --[[ ROBLOX adaptation: added 1 to array index ]]
		]) * decimals) --[[ ROBLOX NOTE: Math.round is currently not supported by the Luau Math polyfill, please add your own implementation or file a ticket on the same ]]
			/ decimals
		local startTranslated = vec2.fromValues(x, y) -- F.6.6.2:
		local biglambda = startTranslated[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		]
				* startTranslated[
					1 --[[ ROBLOX adaptation: added 1 to array index ]]
				]
				/ (xradius * xradius)
			+ startTranslated[
					2 --[[ ROBLOX adaptation: added 1 to array index ]]
				]
				* startTranslated[
					2 --[[ ROBLOX adaptation: added 1 to array index ]]
				]
				/ (yradius * yradius)
		if
			biglambda
			> 1.0 --[[ ROBLOX CHECK: operator '>' works only if either both arguments are strings or both are a number ]]
		then
			-- F.6.6.3:
			local sqrtbiglambda = math.sqrt(biglambda)
			xradius *= sqrtbiglambda
			yradius *= sqrtbiglambda -- round to precision in order to have determinate calculations
			xradius = Math.round(xradius * decimals) --[[ ROBLOX NOTE: Math.round is currently not supported by the Luau Math polyfill, please add your own implementation or file a ticket on the same ]]
				/ decimals
			yradius = Math.round(yradius * decimals) --[[ ROBLOX NOTE: Math.round is currently not supported by the Luau Math polyfill, please add your own implementation or file a ticket on the same ]]
				/ decimals
		end -- F.6.5.2:
		local multiplier1 = math.sqrt((xradius * xradius * yradius * yradius - xradius * xradius * startTranslated[
			2 --[[ ROBLOX adaptation: added 1 to array index ]]
		] * startTranslated[
			2 --[[ ROBLOX adaptation: added 1 to array index ]]
		] - yradius * yradius * startTranslated[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		] * startTranslated[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		]) / (xradius * xradius * startTranslated[
			2 --[[ ROBLOX adaptation: added 1 to array index ]]
		] * startTranslated[
			2 --[[ ROBLOX adaptation: added 1 to array index ]]
		] + yradius * yradius * startTranslated[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		] * startTranslated[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		]))
		if sweepFlag == large then
			multiplier1 = -multiplier1
		end
		local centerTranslated = vec2.fromValues(xradius * startTranslated[
			2 --[[ ROBLOX adaptation: added 1 to array index ]]
		] / yradius, -yradius * startTranslated[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		] / xradius)
		vec2.scale(centerTranslated, centerTranslated, multiplier1) -- F.6.5.3:
		local center = vec2.fromValues(cosphi * centerTranslated[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		] - sinphi * centerTranslated[
			2 --[[ ROBLOX adaptation: added 1 to array index ]]
		], sinphi * centerTranslated[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		] + cosphi * centerTranslated[
			2 --[[ ROBLOX adaptation: added 1 to array index ]]
		])
		center = vec2.add(center, center, vec2.scale(vec2.create(), vec2.add(vec2.create(), startpoint, endpoint), 0.5)) -- F.6.5.5:
		local vector1 = vec2.fromValues((startTranslated[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		] - centerTranslated[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		]) / xradius, (startTranslated[
			2 --[[ ROBLOX adaptation: added 1 to array index ]]
		] - centerTranslated[
			2 --[[ ROBLOX adaptation: added 1 to array index ]]
		]) / yradius)
		local vector2 = vec2.fromValues((-startTranslated[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		] - centerTranslated[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		]) / xradius, (-startTranslated[
			2 --[[ ROBLOX adaptation: added 1 to array index ]]
		] - centerTranslated[
			2 --[[ ROBLOX adaptation: added 1 to array index ]]
		]) / yradius)
		local theta1 = vec2.angleRadians(vector1)
		local theta2 = vec2.angleRadians(vector2)
		local deltatheta = theta2 - theta1
		deltatheta = deltatheta % TAU
		if
			not Boolean.toJSBoolean(sweepFlag)
			and deltatheta > 0 --[[ ROBLOX CHECK: operator '>' works only if either both arguments are strings or both are a number ]]
		then
			deltatheta -= TAU
		elseif
			Boolean.toJSBoolean(if Boolean.toJSBoolean(sweepFlag)
				then deltatheta
					< 0 --[[ ROBLOX CHECK: operator '<' works only if either both arguments are strings or both are a number ]]
				else sweepFlag)
		then
			deltatheta += TAU
		end -- Ok, we have the center point and angle range (from theta1, deltatheta radians) so we can create the ellipse
		local numsteps = math.ceil(math.abs(deltatheta) / TAU * segments) + 1
		if
			numsteps
			< 1 --[[ ROBLOX CHECK: operator '<' works only if either both arguments are strings or both are a number ]]
		then
			numsteps = 1
		end
		do
			local step = 1
			while
				step
				< numsteps --[[ ROBLOX CHECK: operator '<' works only if either both arguments are strings or both are a number ]]
			do
				local theta = theta1 + step / numsteps * deltatheta
				local costheta = math.cos(theta)
				local sintheta = math.sin(theta) -- F.6.3.1:
				local point = vec2.fromValues(
					cosphi * xradius * costheta - sinphi * yradius * sintheta,
					sinphi * xradius * costheta + cosphi * yradius * sintheta
				)
				vec2.add(point, point, center)
				table.insert(newpoints, point) --[[ ROBLOX CHECK: check if 'newpoints' is an Array ]]
				step += 1
			end
		end -- ensure end point is precisely what user gave as parameter
		if Boolean.toJSBoolean(numsteps) then
			table.insert(newpoints, options.endpoint) --[[ ROBLOX CHECK: check if 'newpoints' is an Array ]]
		end
	end
	newpoints = Array.concat(points, newpoints) --[[ ROBLOX CHECK: check if 'points' is an Array ]]
	local result = fromPoints({}, newpoints)
	return result
end
return appendArc
