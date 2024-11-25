-- ROBLOX NOTE: no upstream

local LuauPolyfill = require("@Packages/LuauPolyfill")
local Boolean = LuauPolyfill.Boolean
local Error = LuauPolyfill.Error
local Object = LuauPolyfill.Object
local TAU = require("../maths/constants").TAU
local vec2 = require("../maths/vec2")
local geom2 = require("../geometries/geom2")
local isGT, isGTE, isNumberArray
do
	local ref = require("./commonChecks")
	isGT, isGTE, isNumberArray = ref.isGT, ref.isGTE, ref.isNumberArray
end -- @see http://www.jdawiseman.com/papers/easymath/surds_star_inner_radius.html
local function getRadiusRatio(vertices, density)
	if
		vertices > 0 --[[ ROBLOX CHECK: operator '>' works only if either both arguments are strings or both are a number ]]
		and density > 1 --[[ ROBLOX CHECK: operator '>' works only if either both arguments are strings or both are a number ]]
		and density < vertices / 2 --[[ ROBLOX CHECK: operator '<' works only if either both arguments are strings or both are a number ]]
	then
		return math.cos(math.pi * density / vertices) / math.cos(math.pi * (density - 1) / vertices)
	end
	return 0
end
local function getPoints(vertices, radius, startAngle, center)
	local a = TAU / vertices
	local points = {}
	do
		local i = 0
		while
			i
			< vertices --[[ ROBLOX CHECK: operator '<' works only if either both arguments are strings or both are a number ]]
		do
			local point = vec2.fromAngleRadians(vec2.create(), a * i + startAngle)
			vec2.scale(point, point, radius)
			vec2.add(point, center, point)
			table.insert(points, point) --[[ ROBLOX CHECK: check if 'points' is an Array ]]
			i += 1
		end
	end
	return points
end
--[=[*
 * Construct a star in two dimensional space.
 * @see https://en.wikipedia.org/wiki/Star_polygon
 * @param {Object} [options] - options for construction
 * @param {Array} [options.center=[0,0]] - center of star
 * @param {Number} [options.vertices=5] - number of vertices (P) on the star
 * @param {Number} [options.density=2] - density (Q) of star
 * @param {Number} [options.outerRadius=1] - outer radius of vertices
 * @param {Number} [options.innerRadius=0] - inner radius of vertices, or zero to calculate
 * @param {Number} [options.startAngle=0] - starting angle for first vertice, in radians
 * @returns {geom2} new 2D geometry
 * @alias module:modeling/primitives.star
 *
 * @example
 * let star1 = star({vertices: 8, outerRadius: 10}) // star with 8/2 density
 * let star2 = star({vertices: 12, outerRadius: 40, innerRadius: 20}) // star with given radius
 ]=]
local function star(options)
	local defaults = {
		center = { 0, 0 },
		vertices = 5,
		outerRadius = 1,
		innerRadius = 0,
		density = 2,
		startAngle = 0,
	}
	local center, vertices, outerRadius, innerRadius, density, startAngle
	do
		local ref = Object.assign({}, defaults, options)
		center, vertices, outerRadius, innerRadius, density, startAngle =
			ref.center, ref.vertices, ref.outerRadius, ref.innerRadius, ref.density, ref.startAngle
	end
	if not Boolean.toJSBoolean(isNumberArray(center, 2)) then
		error(Error.new("center must be an array of X and Y values"))
	end
	if not Boolean.toJSBoolean(isGTE(vertices, 2)) then
		error(Error.new("vertices must be two or more"))
	end
	if not Boolean.toJSBoolean(isGT(outerRadius, 0)) then
		error(Error.new("outerRadius must be greater than zero"))
	end
	if not Boolean.toJSBoolean(isGTE(innerRadius, 0)) then
		error(Error.new("innerRadius must be greater than zero"))
	end
	if not Boolean.toJSBoolean(isGTE(startAngle, 0)) then
		error(Error.new("startAngle must be greater than zero"))
	end -- force integers
	vertices = math.floor(vertices)
	density = math.floor(density)
	startAngle = startAngle % TAU
	if innerRadius == 0 then
		if not Boolean.toJSBoolean(isGTE(density, 2)) then
			error(Error.new("density must be two or more"))
		end
		innerRadius = outerRadius * getRadiusRatio(vertices, density)
	end
	local centerv = vec2.clone(center)
	local outerPoints = getPoints(vertices, outerRadius, startAngle, centerv)
	local innerPoints = getPoints(vertices, innerRadius, startAngle + math.pi / vertices, centerv)
	local allPoints = {}
	do
		local i = 0
		while
			i
			< vertices --[[ ROBLOX CHECK: operator '<' works only if either both arguments are strings or both are a number ]]
		do
			table.insert(allPoints, outerPoints[i]) --[[ ROBLOX CHECK: check if 'allPoints' is an Array ]]
			table.insert(allPoints, innerPoints[i]) --[[ ROBLOX CHECK: check if 'allPoints' is an Array ]]
			i += 1
		end
	end
	return geom2.fromPoints(allPoints)
end
return star
