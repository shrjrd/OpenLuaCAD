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
local vec3 = require("../maths/vec3")
local geom3 = require("../geometries/geom3")
local poly3 = require("../geometries/poly3")
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
local cylinder = require("./cylinder")
--[=[*
 * Construct a Z axis-aligned solid cylinder in three dimensional space with rounded ends.
 * @param {Object} [options] - options for construction
 * @param {Array} [options.center=[0,0,0]] - center of cylinder
 * @param {Number} [options.height=2] - height of cylinder
 * @param {Number} [options.radius=1] - radius of cylinder
 * @param {Number} [options.roundRadius=0.2] - radius of rounded edges
 * @param {Number} [options.segments=32] - number of segments to create per full rotation
 * @returns {geom3} new 3D geometry
 * @alias module:modeling/primitives.roundedCylinder
 *
 * @example
 * let myshape = roundedCylinder({ height: 10, radius: 2, roundRadius: 0.5 })
 ]=]
local function roundedCylinder(options)
	local defaults = { center = { 0, 0, 0 }, height = 2, radius = 1, roundRadius = 0.2, segments = 32 }
	local center, height, radius, roundRadius, segments
	do
		local ref = Object.assign({}, defaults, options)
		center, height, radius, roundRadius, segments =
			ref.center, ref.height, ref.radius, ref.roundRadius, ref.segments
	end
	if not Boolean.toJSBoolean(isNumberArray(center, 3)) then
		error(Error.new("center must be an array of X, Y and Z values"))
	end
	if not Boolean.toJSBoolean(isGTE(height, 0)) then
		error(Error.new("height must be positive"))
	end
	if not Boolean.toJSBoolean(isGTE(radius, 0)) then
		error(Error.new("radius must be positive"))
	end
	if not Boolean.toJSBoolean(isGTE(roundRadius, 0)) then
		error(Error.new("roundRadius must be positive"))
	end
	if
		roundRadius
		> radius --[[ ROBLOX CHECK: operator '>' works only if either both arguments are strings or both are a number ]]
	then
		error(Error.new("roundRadius must be smaller than the radius"))
	end
	if not Boolean.toJSBoolean(isGTE(segments, 4)) then
		error(Error.new("segments must be four or more"))
	end -- if size is zero return empty geometry
	if height == 0 or radius == 0 then
		return geom3.create()
	end -- if roundRadius is zero, return cylinder
	if roundRadius == 0 then
		return cylinder({ center = center, height = height, radius = radius })
	end
	local start = { 0, 0, -(height / 2) }
	local end_ = { 0, 0, height / 2 }
	local direction = vec3.subtract(vec3.create(), end_, start)
	local length = vec3.length(direction)
	if
		2 * roundRadius
		> length - EPS --[[ ROBLOX CHECK: operator '>' works only if either both arguments are strings or both are a number ]]
	then
		error(Error.new("height must be larger than twice roundRadius"))
	end
	local defaultnormal
	if
		math.abs(direction[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		])
		> math.abs(direction[
			2 --[[ ROBLOX adaptation: added 1 to array index ]]
		]) --[[ ROBLOX CHECK: operator '>' works only if either both arguments are strings or both are a number ]]
	then
		defaultnormal = vec3.fromValues(0, 1, 0)
	else
		defaultnormal = vec3.fromValues(1, 0, 0)
	end
	local zvector = vec3.scale(vec3.create(), vec3.normalize(vec3.create(), direction), roundRadius)
	local xvector = vec3.scale(
		vec3.create(),
		vec3.normalize(vec3.create(), vec3.cross(vec3.create(), zvector, defaultnormal)),
		radius
	)
	local yvector =
		vec3.scale(vec3.create(), vec3.normalize(vec3.create(), vec3.cross(vec3.create(), xvector, zvector)), radius)
	vec3.add(start, start, zvector)
	vec3.subtract(end_, end_, zvector)
	local qsegments = math.floor(0.25 * segments)
	local function fromPoints(points)
		-- adjust the points to center
		local newpoints = Array.map(points, function(point)
			return vec3.add(point, point, center)
		end) --[[ ROBLOX CHECK: check if 'points' is an Array ]]
		return poly3.create(newpoints)
	end
	local polygons = {}
	local v1 = vec3.create()
	local v2 = vec3.create()
	local prevcylinderpoint
	do
		local slice1 = 0
		while
			slice1
			<= segments --[[ ROBLOX CHECK: operator '<=' works only if either both arguments are strings or both are a number ]]
		do
			local angle = TAU * slice1 / segments
			local cylinderpoint =
				vec3.add(vec3.create(), vec3.scale(v1, xvector, cos(angle)), vec3.scale(v2, yvector, sin(angle)))
			if
				slice1
				> 0 --[[ ROBLOX CHECK: operator '>' works only if either both arguments are strings or both are a number ]]
			then
				-- cylinder wall
				local points = {}
				table.insert(points, vec3.add(vec3.create(), start, cylinderpoint)) --[[ ROBLOX CHECK: check if 'points' is an Array ]]
				table.insert(points, vec3.add(vec3.create(), start, prevcylinderpoint)) --[[ ROBLOX CHECK: check if 'points' is an Array ]]
				table.insert(points, vec3.add(vec3.create(), end_, prevcylinderpoint)) --[[ ROBLOX CHECK: check if 'points' is an Array ]]
				table.insert(points, vec3.add(vec3.create(), end_, cylinderpoint)) --[[ ROBLOX CHECK: check if 'points' is an Array ]]
				table.insert(polygons, fromPoints(points)) --[[ ROBLOX CHECK: check if 'polygons' is an Array ]]
				local prevcospitch, prevsinpitch
				do
					local slice2 = 0
					while
						slice2
						<= qsegments --[[ ROBLOX CHECK: operator '<=' works only if either both arguments are strings or both are a number ]]
					do
						local pitch = TAU / 4 * slice2 / qsegments
						local cospitch = cos(pitch)
						local sinpitch = sin(pitch)
						if
							slice2
							> 0 --[[ ROBLOX CHECK: operator '>' works only if either both arguments are strings or both are a number ]]
						then
							-- cylinder rounding, start
							points = {}
							local point
							point = vec3.add(
								vec3.create(),
								start,
								vec3.subtract(
									v1,
									vec3.scale(v1, prevcylinderpoint, prevcospitch),
									vec3.scale(v2, zvector, prevsinpitch)
								)
							)
							table.insert(points, point) --[[ ROBLOX CHECK: check if 'points' is an Array ]]
							point = vec3.add(
								vec3.create(),
								start,
								vec3.subtract(
									v1,
									vec3.scale(v1, cylinderpoint, prevcospitch),
									vec3.scale(v2, zvector, prevsinpitch)
								)
							)
							table.insert(points, point) --[[ ROBLOX CHECK: check if 'points' is an Array ]]
							if
								slice2
								< qsegments --[[ ROBLOX CHECK: operator '<' works only if either both arguments are strings or both are a number ]]
							then
								point = vec3.add(
									vec3.create(),
									start,
									vec3.subtract(
										v1,
										vec3.scale(v1, cylinderpoint, cospitch),
										vec3.scale(v2, zvector, sinpitch)
									)
								)
								table.insert(points, point) --[[ ROBLOX CHECK: check if 'points' is an Array ]]
							end
							point = vec3.add(
								vec3.create(),
								start,
								vec3.subtract(
									v1,
									vec3.scale(v1, prevcylinderpoint, cospitch),
									vec3.scale(v2, zvector, sinpitch)
								)
							)
							table.insert(points, point) --[[ ROBLOX CHECK: check if 'points' is an Array ]]
							table.insert(polygons, fromPoints(points)) --[[ ROBLOX CHECK: check if 'polygons' is an Array ]] -- cylinder rounding, end
							points = {}
							point = vec3.add(
								vec3.create(),
								vec3.scale(v1, prevcylinderpoint, prevcospitch),
								vec3.scale(v2, zvector, prevsinpitch)
							)
							vec3.add(point, point, end_)
							table.insert(points, point) --[[ ROBLOX CHECK: check if 'points' is an Array ]]
							point = vec3.add(
								vec3.create(),
								vec3.scale(v1, cylinderpoint, prevcospitch),
								vec3.scale(v2, zvector, prevsinpitch)
							)
							vec3.add(point, point, end_)
							table.insert(points, point) --[[ ROBLOX CHECK: check if 'points' is an Array ]]
							if
								slice2
								< qsegments --[[ ROBLOX CHECK: operator '<' works only if either both arguments are strings or both are a number ]]
							then
								point = vec3.add(
									vec3.create(),
									vec3.scale(v1, cylinderpoint, cospitch),
									vec3.scale(v2, zvector, sinpitch)
								)
								vec3.add(point, point, end_)
								table.insert(points, point) --[[ ROBLOX CHECK: check if 'points' is an Array ]]
							end
							point = vec3.add(
								vec3.create(),
								vec3.scale(v1, prevcylinderpoint, cospitch),
								vec3.scale(v2, zvector, sinpitch)
							)
							vec3.add(point, point, end_)
							table.insert(points, point) --[[ ROBLOX CHECK: check if 'points' is an Array ]]
							Array.reverse(points) --[[ ROBLOX CHECK: check if 'points' is an Array ]]
							table.insert(polygons, fromPoints(points)) --[[ ROBLOX CHECK: check if 'polygons' is an Array ]]
						end
						prevcospitch = cospitch
						prevsinpitch = sinpitch
						slice2 += 1
					end
				end
			end
			prevcylinderpoint = cylinderpoint
			slice1 += 1
		end
	end
	local result = geom3.create(polygons)
	return result
end
return roundedCylinder
