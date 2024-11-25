-- ROBLOX NOTE: no upstream

local LuauPolyfill = require("@Packages/LuauPolyfill")
local Array = LuauPolyfill.Array
local Boolean = LuauPolyfill.Boolean
local Error = LuauPolyfill.Error
local Math = LuauPolyfill.Math
local Object = LuauPolyfill.Object
local TAU = require("../maths/constants").TAU
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
--[=[*
 * Construct an axis-aligned ellipsoid in three dimensional space.
 * @param {Object} [options] - options for construction
 * @param {Array} [options.center=[0,0,0]] - center of ellipsoid
 * @param {Array} [options.radius=[1,1,1]] - radius of ellipsoid, along X, Y and Z
 * @param {Number} [options.segments=32] - number of segments to create per full rotation
 * @param {Array} [options.axes] -  an array with three vectors for the x, y and z base vectors
 * @returns {geom3} new 3D geometry
 * @alias module:modeling/primitives.ellipsoid
 *
 * @example
 * let myshape = ellipsoid({radius: [5, 10, 20]})
]=]
local function ellipsoid(options)
	local defaults = {
		center = { 0, 0, 0 },
		radius = { 1, 1, 1 },
		segments = 32,
		axes = { { 1, 0, 0 }, { 0, -1, 0 }, { 0, 0, 1 } },
	}
	local center, radius, segments, axes
	do
		local ref = Object.assign({}, defaults, options)
		center, radius, segments, axes = ref.center, ref.radius, ref.segments, ref.axes
	end
	if not Boolean.toJSBoolean(isNumberArray(center, 3)) then
		error(Error.new("center must be an array of X, Y and Z values"))
	end
	if not Boolean.toJSBoolean(isNumberArray(radius, 3)) then
		error(Error.new("radius must be an array of X, Y and Z values"))
	end
	if
		not Boolean.toJSBoolean(Array.every(radius, function(n)
			return n >= 0 --[[ ROBLOX CHECK: operator '>=' works only if either both arguments are strings or both are a number ]]
		end) --[[ ROBLOX CHECK: check if 'radius' is an Array ]])
	then
		error(Error.new("radius values must be positive"))
	end
	if not Boolean.toJSBoolean(isGTE(segments, 4)) then
		error(Error.new("segments must be four or more"))
	end -- if any radius is zero return empty geometry
	if
		radius[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		] == 0
		or radius[
			2 --[[ ROBLOX adaptation: added 1 to array index ]]
		] == 0
		or radius[
			3 --[[ ROBLOX adaptation: added 1 to array index ]]
		] == 0
	then
		return geom3.create()
	end
	local xvector = vec3.scale(
		vec3.create(),
		vec3.normalize(
			vec3.create(),
			axes[
				1 --[[ ROBLOX adaptation: added 1 to array index ]]
			]
		),
		radius[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		]
	)
	local yvector = vec3.scale(
		vec3.create(),
		vec3.normalize(
			vec3.create(),
			axes[
				2 --[[ ROBLOX adaptation: added 1 to array index ]]
			]
		),
		radius[
			2 --[[ ROBLOX adaptation: added 1 to array index ]]
		]
	)
	local zvector = vec3.scale(
		vec3.create(),
		vec3.normalize(
			vec3.create(),
			axes[
				3 --[[ ROBLOX adaptation: added 1 to array index ]]
			]
		),
		radius[
			3 --[[ ROBLOX adaptation: added 1 to array index ]]
		]
	)
	local qsegments = Math.round(segments / 4) --[[ ROBLOX NOTE: Math.round is currently not supported by the Luau Math polyfill, please add your own implementation or file a ticket on the same ]]
	local prevcylinderpoint
	local polygons = {}
	local p1 = vec3.create()
	local p2 = vec3.create()
	do
		local slice1 = 0
		while
			slice1
			<= segments --[[ ROBLOX CHECK: operator '<=' works only if either both arguments are strings or both are a number ]]
		do
			local angle = TAU * slice1 / segments
			local cylinderpoint =
				vec3.add(vec3.create(), vec3.scale(p1, xvector, cos(angle)), vec3.scale(p2, yvector, sin(angle)))
			if
				slice1
				> 0 --[[ ROBLOX CHECK: operator '>' works only if either both arguments are strings or both are a number ]]
			then
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
							local points = {}
							local point
							point = vec3.subtract(
								vec3.create(),
								vec3.scale(p1, prevcylinderpoint, prevcospitch),
								vec3.scale(p2, zvector, prevsinpitch)
							)
							table.insert(points, vec3.add(point, point, center)) --[[ ROBLOX CHECK: check if 'points' is an Array ]]
							point = vec3.subtract(
								vec3.create(),
								vec3.scale(p1, cylinderpoint, prevcospitch),
								vec3.scale(p2, zvector, prevsinpitch)
							)
							table.insert(points, vec3.add(point, point, center)) --[[ ROBLOX CHECK: check if 'points' is an Array ]]
							if
								slice2
								< qsegments --[[ ROBLOX CHECK: operator '<' works only if either both arguments are strings or both are a number ]]
							then
								point = vec3.subtract(
									vec3.create(),
									vec3.scale(p1, cylinderpoint, cospitch),
									vec3.scale(p2, zvector, sinpitch)
								)
								table.insert(points, vec3.add(point, point, center)) --[[ ROBLOX CHECK: check if 'points' is an Array ]]
							end
							point = vec3.subtract(
								vec3.create(),
								vec3.scale(p1, prevcylinderpoint, cospitch),
								vec3.scale(p2, zvector, sinpitch)
							)
							table.insert(points, vec3.add(point, point, center)) --[[ ROBLOX CHECK: check if 'points' is an Array ]]
							table.insert(polygons, poly3.create(points)) --[[ ROBLOX CHECK: check if 'polygons' is an Array ]]
							points = {}
							point = vec3.add(
								vec3.create(),
								vec3.scale(p1, prevcylinderpoint, prevcospitch),
								vec3.scale(p2, zvector, prevsinpitch)
							)
							table.insert(points, vec3.add(vec3.create(), center, point)) --[[ ROBLOX CHECK: check if 'points' is an Array ]]
							point = vec3.add(
								point,
								vec3.scale(p1, cylinderpoint, prevcospitch),
								vec3.scale(p2, zvector, prevsinpitch)
							)
							table.insert(points, vec3.add(vec3.create(), center, point)) --[[ ROBLOX CHECK: check if 'points' is an Array ]]
							if
								slice2
								< qsegments --[[ ROBLOX CHECK: operator '<' works only if either both arguments are strings or both are a number ]]
							then
								point = vec3.add(
									point,
									vec3.scale(p1, cylinderpoint, cospitch),
									vec3.scale(p2, zvector, sinpitch)
								)
								table.insert(points, vec3.add(vec3.create(), center, point)) --[[ ROBLOX CHECK: check if 'points' is an Array ]]
							end
							point = vec3.add(
								point,
								vec3.scale(p1, prevcylinderpoint, cospitch),
								vec3.scale(p2, zvector, sinpitch)
							)
							table.insert(points, vec3.add(vec3.create(), center, point)) --[[ ROBLOX CHECK: check if 'points' is an Array ]]
							Array.reverse(points) --[[ ROBLOX CHECK: check if 'points' is an Array ]]
							table.insert(polygons, poly3.create(points)) --[[ ROBLOX CHECK: check if 'polygons' is an Array ]]
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
	return geom3.create(polygons)
end
return ellipsoid
