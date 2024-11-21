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
local cuboid = require("./cuboid")
local function createCorners(center, size, radius, segments, slice, positive)
	local pitch = TAU / 4 * slice / segments
	local cospitch = cos(pitch)
	local sinpitch = sin(pitch)
	local layersegments = segments - slice
	local layerradius = radius * cospitch
	local layeroffset = size[
		3 --[[ ROBLOX adaptation: added 1 to array index ]]
	] - (radius - radius * sinpitch)
	if not Boolean.toJSBoolean(positive) then
		layeroffset = radius - radius * sinpitch - size[
			3 --[[ ROBLOX adaptation: added 1 to array index ]]
		]
	end
	layerradius = if layerradius
			> EPS --[[ ROBLOX CHECK: operator '>' works only if either both arguments are strings or both are a number ]]
		then layerradius
		else 0
	local corner0 = vec3.add(vec3.create(), center, {
		size[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		] - radius,
		size[
			2 --[[ ROBLOX adaptation: added 1 to array index ]]
		] - radius,
		layeroffset,
	})
	local corner1 = vec3.add(vec3.create(), center, {
		radius - size[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		],
		size[
			2 --[[ ROBLOX adaptation: added 1 to array index ]]
		] - radius,
		layeroffset,
	})
	local corner2 = vec3.add(vec3.create(), center, {
		radius - size[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		],
		radius - size[
			2 --[[ ROBLOX adaptation: added 1 to array index ]]
		],
		layeroffset,
	})
	local corner3 = vec3.add(vec3.create(), center, {
		size[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		] - radius,
		radius - size[
			2 --[[ ROBLOX adaptation: added 1 to array index ]]
		],
		layeroffset,
	})
	local corner0Points = {}
	local corner1Points = {}
	local corner2Points = {}
	local corner3Points = {}
	do
		local i = 0
		while
			i
			<= layersegments --[[ ROBLOX CHECK: operator '<=' works only if either both arguments are strings or both are a number ]]
		do
			local radians = if layersegments
					> 0 --[[ ROBLOX CHECK: operator '>' works only if either both arguments are strings or both are a number ]]
				then TAU / 4 * i / layersegments
				else 0
			local point2d = vec2.fromAngleRadians(vec2.create(), radians)
			vec2.scale(point2d, point2d, layerradius)
			local point3d = vec3.fromVec2(vec3.create(), point2d)
			table.insert(corner0Points, vec3.add(vec3.create(), corner0, point3d)) --[[ ROBLOX CHECK: check if 'corner0Points' is an Array ]]
			vec3.rotateZ(point3d, point3d, { 0, 0, 0 }, TAU / 4)
			table.insert(corner1Points, vec3.add(vec3.create(), corner1, point3d)) --[[ ROBLOX CHECK: check if 'corner1Points' is an Array ]]
			vec3.rotateZ(point3d, point3d, { 0, 0, 0 }, TAU / 4)
			table.insert(corner2Points, vec3.add(vec3.create(), corner2, point3d)) --[[ ROBLOX CHECK: check if 'corner2Points' is an Array ]]
			vec3.rotateZ(point3d, point3d, { 0, 0, 0 }, TAU / 4)
			table.insert(corner3Points, vec3.add(vec3.create(), corner3, point3d)) --[[ ROBLOX CHECK: check if 'corner3Points' is an Array ]]
			i += 1
		end
	end
	if not Boolean.toJSBoolean(positive) then
		Array.reverse(corner0Points) --[[ ROBLOX CHECK: check if 'corner0Points' is an Array ]]
		Array.reverse(corner1Points) --[[ ROBLOX CHECK: check if 'corner1Points' is an Array ]]
		Array.reverse(corner2Points) --[[ ROBLOX CHECK: check if 'corner2Points' is an Array ]]
		Array.reverse(corner3Points) --[[ ROBLOX CHECK: check if 'corner3Points' is an Array ]]
		return { corner3Points, corner2Points, corner1Points, corner0Points }
	end
	return { corner0Points, corner1Points, corner2Points, corner3Points }
end
local function stitchCorners(previousCorners, currentCorners)
	local polygons = {}
	do
		local i = 0
		while
			i
			< #previousCorners --[[ ROBLOX CHECK: operator '<' works only if either both arguments are strings or both are a number ]]
		do
			local previous = previousCorners[i]
			local current = currentCorners[i]
			do
				local j = 0
				while
					j
					< #previous - 1 --[[ ROBLOX CHECK: operator '<' works only if either both arguments are strings or both are a number ]]
				do
					table.insert(
						polygons,
						poly3.create({
							previous[j],
							previous[(j + 1)],
							current[j],
						})
					) --[[ ROBLOX CHECK: check if 'polygons' is an Array ]]
					if
						j
						< #current - 1 --[[ ROBLOX CHECK: operator '<' works only if either both arguments are strings or both are a number ]]
					then
						table.insert(
							polygons,
							poly3.create({
								current[j],
								previous[(j + 1)],
								current[(j + 1)],
							})
						) --[[ ROBLOX CHECK: check if 'polygons' is an Array ]]
					end
					j += 1
				end
			end
			i += 1
		end
	end
	return polygons
end
local function stitchWalls(previousCorners, currentCorners)
	local polygons = {}
	do
		local i = 0
		while
			i
			< #previousCorners --[[ ROBLOX CHECK: operator '<' works only if either both arguments are strings or both are a number ]]
		do
			local previous = previousCorners[i]
			local current = currentCorners[i]
			local p0 = previous[(#previous - 1)]
			local c0 = current[(#current - 1)]
			local j = (i + 1) % #previousCorners
			previous = previousCorners[j]
			current = currentCorners[j]
			local p1 = previous[
				1 --[[ ROBLOX adaptation: added 1 to array index ]]
			]
			local c1 = current[
				1 --[[ ROBLOX adaptation: added 1 to array index ]]
			]
			table.insert(polygons, poly3.create({ p0, p1, c1, c0 })) --[[ ROBLOX CHECK: check if 'polygons' is an Array ]]
			i += 1
		end
	end
	return polygons
end
local function stitchSides(bottomCorners, topCorners)
	-- make a copy and reverse the bottom corners
	bottomCorners = {
		bottomCorners[
			4 --[[ ROBLOX adaptation: added 1 to array index ]]
		],
		bottomCorners[
			3 --[[ ROBLOX adaptation: added 1 to array index ]]
		],
		bottomCorners[
			2 --[[ ROBLOX adaptation: added 1 to array index ]]
		],
		bottomCorners[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		],
	}
	bottomCorners = Array.map(bottomCorners, function(corner)
		return Array.reverse(Array.slice(corner) --[[ ROBLOX CHECK: check if 'corner' is an Array ]])
	end) --[[ ROBLOX CHECK: check if 'bottomCorners' is an Array ]]
	local bottomPoints = {}
	Array.forEach(bottomCorners, function(corner)
		Array.forEach(corner, function(point)
			return table.insert(bottomPoints, point) --[[ ROBLOX CHECK: check if 'bottomPoints' is an Array ]]
		end) --[[ ROBLOX CHECK: check if 'corner' is an Array ]]
	end) --[[ ROBLOX CHECK: check if 'bottomCorners' is an Array ]]
	local topPoints = {}
	Array.forEach(topCorners, function(corner)
		Array.forEach(corner, function(point)
			return table.insert(topPoints, point) --[[ ROBLOX CHECK: check if 'topPoints' is an Array ]]
		end) --[[ ROBLOX CHECK: check if 'corner' is an Array ]]
	end) --[[ ROBLOX CHECK: check if 'topCorners' is an Array ]]
	local polygons = {}
	do
		local i = 0
		while
			i
			< #topPoints --[[ ROBLOX CHECK: operator '<' works only if either both arguments are strings or both are a number ]]
		do
			local j = (i + 1) % #topPoints
			table.insert(
				polygons,
				poly3.create({
					bottomPoints[i],
					bottomPoints[j],
					topPoints[j],
					topPoints[i],
				})
			) --[[ ROBLOX CHECK: check if 'polygons' is an Array ]]
			i += 1
		end
	end
	return polygons
end
--[=[*
 * Construct an axis-aligned solid cuboid in three dimensional space with rounded corners.
 * @param {Object} [options] - options for construction
 * @param {Array} [options.center=[0,0,0]] - center of rounded cube
 * @param {Array} [options.size=[2,2,2]] - dimension of rounded cube; width, depth, height
 * @param {Number} [options.roundRadius=0.2] - radius of rounded edges
 * @param {Number} [options.segments=32] - number of segments to create per full rotation
 * @returns {geom3} new 3D geometry
 * @alias module:modeling/primitives.roundedCuboid
 *
 * @example
 * let mycube = roundedCuboid({size: [10, 20, 10], roundRadius: 2, segments: 16})
 ]=]
local function roundedCuboid(options)
	local defaults = { center = { 0, 0, 0 }, size = { 2, 2, 2 }, roundRadius = 0.2, segments = 32 }
	local center, size, roundRadius, segments
	do
		local ref = Object.assign({}, defaults, options)
		center, size, roundRadius, segments = ref.center, ref.size, ref.roundRadius, ref.segments
	end
	if not Boolean.toJSBoolean(isNumberArray(center, 3)) then
		error(Error.new("center must be an array of X, Y and Z values"))
	end
	if not Boolean.toJSBoolean(isNumberArray(size, 3)) then
		error(Error.new("size must be an array of X, Y and Z values"))
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
		] == 0
		or size[
			2 --[[ ROBLOX adaptation: added 1 to array index ]]
		] == 0
		or size[
			3 --[[ ROBLOX adaptation: added 1 to array index ]]
		] == 0
	then
		return geom3.create()
	end -- if roundRadius is zero, return cuboid
	if roundRadius == 0 then
		return cuboid({ center = center, size = size })
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
		or roundRadius > size[
			3 --[[ ROBLOX adaptation: added 1 to array index ]]
		] - EPS --[[ ROBLOX CHECK: operator '>' works only if either both arguments are strings or both are a number ]]
	then
		error(Error.new("roundRadius must be smaller than the radius of all dimensions"))
	end
	segments = math.floor(segments / 4)
	local prevCornersPos = nil
	local prevCornersNeg = nil
	local polygons = {}
	do
		local slice = 0
		while
			slice
			<= segments --[[ ROBLOX CHECK: operator '<=' works only if either both arguments are strings or both are a number ]]
		do
			local cornersPos = createCorners(center, size, roundRadius, segments, slice, true)
			local cornersNeg = createCorners(center, size, roundRadius, segments, slice, false)
			if slice == 0 then
				polygons = Array.concat(polygons, stitchSides(cornersNeg, cornersPos)) --[[ ROBLOX CHECK: check if 'polygons' is an Array ]]
			end
			if Boolean.toJSBoolean(prevCornersPos) then
				polygons = Array.concat(
					polygons,
					stitchCorners(prevCornersPos, cornersPos),
					stitchWalls(prevCornersPos, cornersPos)
				) --[[ ROBLOX CHECK: check if 'polygons' is an Array ]]
			end
			if Boolean.toJSBoolean(prevCornersNeg) then
				polygons = Array.concat(
					polygons,
					stitchCorners(prevCornersNeg, cornersNeg),
					stitchWalls(prevCornersNeg, cornersNeg)
				) --[[ ROBLOX CHECK: check if 'polygons' is an Array ]]
			end
			if slice == segments then
				-- add the top
				local points = Array.map(cornersPos, function(corner)
					return corner[
						1 --[[ ROBLOX adaptation: added 1 to array index ]]
					]
				end) --[[ ROBLOX CHECK: check if 'cornersPos' is an Array ]]
				table.insert(polygons, poly3.create(points)) --[[ ROBLOX CHECK: check if 'polygons' is an Array ]] -- add the bottom
				points = Array.map(cornersNeg, function(corner)
					return corner[
						1 --[[ ROBLOX adaptation: added 1 to array index ]]
					]
				end) --[[ ROBLOX CHECK: check if 'cornersNeg' is an Array ]]
				table.insert(polygons, poly3.create(points)) --[[ ROBLOX CHECK: check if 'polygons' is an Array ]]
			end
			prevCornersPos = cornersPos
			prevCornersNeg = cornersNeg
			slice += 1
		end
	end
	return geom3.create(polygons)
end
return roundedCuboid
