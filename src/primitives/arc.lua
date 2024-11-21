-- ROBLOX NOTE: no upstream
local Packages = game.ReplicatedStorage.Packages
local LuauPolyfill = require(Packages.LuauPolyfill)
local Boolean = LuauPolyfill.Boolean
local Error = LuauPolyfill.Error
local Object = LuauPolyfill.Object
local EPS, TAU
do
	local ref = require("../maths/constants")
	EPS, TAU = ref.EPS, ref.TAU
end
local vec2 = require("../maths/vec2")
local path2 = require("../geometries/path2")
local isGT, isGTE, isNumberArray
do
	local ref = require("./commonChecks")
	isGT, isGTE, isNumberArray = ref.isGT, ref.isGTE, ref.isNumberArray
end
--[=[*
 * Construct an arc in two dimensional space where all points are at the same distance from the center.
 * @param {Object} [options] - options for construction
 * @param {Array} [options.center=[0,0]] - center of arc
 * @param {Number} [options.radius=1] - radius of arc
 * @param {Number} [options.startAngle=0] - starting angle of the arc, in radians
 * @param {Number} [options.endAngle=TAU] - ending angle of the arc, in radians
 * @param {Number} [options.segments=32] - number of segments to create per full rotation
 * @param {Boolean} [options.makeTangent=false] - adds line segments at both ends of the arc to ensure that the gradients at the edges are tangent
 * @returns {path2} new 2D path
 * @alias module:modeling/primitives.arc
 ]=]
local function arc(options)
	local defaults = {
		center = { 0, 0 },
		radius = 1,
		startAngle = 0,
		endAngle = TAU,
		makeTangent = false,
		segments = 32,
	}
	local center, radius, startAngle, endAngle, makeTangent, segments
	do
		local ref = Object.assign({}, defaults, options)
		center, radius, startAngle, endAngle, makeTangent, segments =
			ref.center, ref.radius, ref.startAngle, ref.endAngle, ref.makeTangent, ref.segments
	end
	if not Boolean.toJSBoolean(isNumberArray(center, 2)) then
		error(Error.new("center must be an array of X and Y values"))
	end
	if not Boolean.toJSBoolean(isGT(radius, 0)) then
		error(Error.new("radius must be greater than zero"))
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
	local minangle = math.acos((radius * radius + radius * radius - EPS * EPS) / (2 * radius * radius))
	local centerv = vec2.clone(center)
	local point
	local pointArray = {}
	if
		rotation
		< minangle --[[ ROBLOX CHECK: operator '<' works only if either both arguments are strings or both are a number ]]
	then
		-- there is no rotation, just a single point
		point = vec2.fromAngleRadians(vec2.create(), startAngle)
		vec2.scale(point, point, radius)
		vec2.add(point, point, centerv)
		table.insert(pointArray, point) --[[ ROBLOX CHECK: check if 'pointArray' is an Array ]]
	else
		-- note: add one additional step to acheive full rotation
		local numsteps = math.max(1, math.floor(segments * (rotation / TAU))) + 1
		local edgestepsize = numsteps * 0.5 / rotation -- step size for half a degree
		if
			edgestepsize
			> 0.25 --[[ ROBLOX CHECK: operator '>' works only if either both arguments are strings or both are a number ]]
		then
			edgestepsize = 0.25
		end
		local totalsteps = if Boolean.toJSBoolean(makeTangent) then numsteps + 2 else numsteps
		do
			local i = 0
			while
				i
				<= totalsteps --[[ ROBLOX CHECK: operator '<=' works only if either both arguments are strings or both are a number ]]
			do
				local step = i
				if Boolean.toJSBoolean(makeTangent) then
					step = (i - 1) * (numsteps - 2 * edgestepsize) / numsteps + edgestepsize
					if
						step
						< 0 --[[ ROBLOX CHECK: operator '<' works only if either both arguments are strings or both are a number ]]
					then
						step = 0
					end
					if
						step
						> numsteps --[[ ROBLOX CHECK: operator '>' works only if either both arguments are strings or both are a number ]]
					then
						step = numsteps
					end
				end
				local angle = startAngle + step * (rotation / numsteps)
				point = vec2.fromAngleRadians(vec2.create(), angle)
				vec2.scale(point, point, radius)
				vec2.add(point, point, centerv)
				table.insert(pointArray, point) --[[ ROBLOX CHECK: check if 'pointArray' is an Array ]]
				i += 1
			end
		end
	end
	return path2.fromPoints({ closed = false }, pointArray)
end
return arc
