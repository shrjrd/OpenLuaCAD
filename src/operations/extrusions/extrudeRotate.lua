-- ROBLOX NOTE: no upstream

local LuauPolyfill = require("@Packages/LuauPolyfill")
local Array = LuauPolyfill.Array
local Boolean = LuauPolyfill.Boolean
local Error = LuauPolyfill.Error
local Object = LuauPolyfill.Object
local TAU = require("../../maths/constants").TAU
local mat4 = require("../../maths/mat4")
local mirrorX = require("../transforms/mirror").mirrorX
local geom2 = require("../../geometries/geom2")
local slice = require("./slice")
local extrudeFromSlices = require("./extrudeFromSlices")
--[[*
 * Rotate extrude the given geometry using the given options.
 *
 * @param {Object} options - options for extrusion
 * @param {Number} [options.angle=TAU] - angle of the extrusion (RADIANS)
 * @param {Number} [options.startAngle=0] - start angle of the extrusion (RADIANS)
 * @param {String} [options.overflow='cap'] - what to do with points outside of bounds (+ / - x) :
 * defaults to capping those points to 0 (only supported behaviour for now)
 * @param {Number} [options.segments=12] - number of segments of the extrusion
 * @param {geom2} geometry - the geometry to extrude
 * @returns {geom3} the extruded geometry
 * @alias module:modeling/extrusions.extrudeRotate
 *
 * @example
 * const myshape = extrudeRotate({segments: 8, angle: TAU / 2}, circle({size: 3, center: [4, 0]}))
 ]]
local function extrudeRotate(options, geometry)
	local defaults = { segments = 12, startAngle = 0, angle = TAU, overflow = "cap" }
	local segments, startAngle, angle, overflow
	do
		local ref = Object.assign({}, defaults, options)
		segments, startAngle, angle, overflow = ref.segments, ref.startAngle, ref.angle, ref.overflow
	end
	if
		segments
		< 3 --[[ ROBLOX CHECK: operator '<' works only if either both arguments are strings or both are a number ]]
	then
		error(Error.new("segments must be greater then 3"))
	end
	startAngle = if math.abs(startAngle)
			> TAU --[[ ROBLOX CHECK: operator '>' works only if either both arguments are strings or both are a number ]]
		then startAngle % TAU
		else startAngle
	angle = if math.abs(angle)
			> TAU --[[ ROBLOX CHECK: operator '>' works only if either both arguments are strings or both are a number ]]
		then angle % TAU
		else angle
	local endAngle = startAngle + angle
	endAngle = if math.abs(endAngle)
			> TAU --[[ ROBLOX CHECK: operator '>' works only if either both arguments are strings or both are a number ]]
		then endAngle % TAU
		else endAngle
	if
		endAngle
		< startAngle --[[ ROBLOX CHECK: operator '<' works only if either both arguments are strings or both are a number ]]
	then
		local x = startAngle
		startAngle = endAngle
		endAngle = x
	end
	local totalRotation = endAngle - startAngle
	if
		totalRotation
		<= 0.0 --[[ ROBLOX CHECK: operator '<=' works only if either both arguments are strings or both are a number ]]
	then
		totalRotation = TAU
	end
	if
		math.abs(totalRotation)
		< TAU --[[ ROBLOX CHECK: operator '<' works only if either both arguments are strings or both are a number ]]
	then
		-- adjust the segments to achieve the total rotation requested
		local anglePerSegment = TAU / segments
		segments = math.floor(math.abs(totalRotation) / anglePerSegment)
		if
			math.abs(totalRotation)
			> segments * anglePerSegment --[[ ROBLOX CHECK: operator '>' works only if either both arguments are strings or both are a number ]]
		then
			segments += 1
		end
	end -- console.log('startAngle: '+startAngle)
	-- console.log('endAngle: '+endAngle)
	-- console.log(totalRotation)
	-- console.log(segments)
	-- convert geometry to an array of sides, easier to deal with
	local shapeSides = geom2.toSides(geometry)
	if #shapeSides == 0 then
		error(Error.new("the given geometry cannot be empty"))
	end -- determine if the rotate extrude can be computed in the first place
	-- ie all the points have to be either x > 0 or x < 0
	-- generic solution to always have a valid solid, even if points go beyond x/ -x
	-- 1. split points up between all those on the 'left' side of the axis (x<0) & those on the 'righ' (x>0)
	-- 2. for each set of points do the extrusion operation IN OPOSITE DIRECTIONS
	-- 3. union the two resulting solids
	-- 1. alt : OR : just cap of points at the axis ?
	local pointsWithNegativeX = Array.filter(shapeSides, function(s)
		return s[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		][
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		] < 0 --[[ ROBLOX CHECK: operator '<' works only if either both arguments are strings or both are a number ]]
	end) --[[ ROBLOX CHECK: check if 'shapeSides' is an Array ]]
	local pointsWithPositiveX = Array.filter(shapeSides, function(s)
		return s[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		][
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		] >= 0 --[[ ROBLOX CHECK: operator '>=' works only if either both arguments are strings or both are a number ]]
	end) --[[ ROBLOX CHECK: check if 'shapeSides' is an Array ]]
	local arePointsWithNegAndPosX = #pointsWithNegativeX > 0 --[[ ROBLOX CHECK: operator '>' works only if either both arguments are strings or both are a number ]]
		and #pointsWithPositiveX > 0 --[[ ROBLOX CHECK: operator '>' works only if either both arguments are strings or both are a number ]] -- FIXME actually there are cases where setting X=0 will change the basic shape
	-- - Alternative #1 : don't allow shapes with both negative and positive X values
	-- - Alternative #2 : remove one half of the shape (costly)
	if
		Boolean.toJSBoolean(
			if Boolean.toJSBoolean(arePointsWithNegAndPosX) then overflow == "cap" else arePointsWithNegAndPosX
		)
	then
		if
			#pointsWithNegativeX
			> #pointsWithPositiveX --[[ ROBLOX CHECK: operator '>' works only if either both arguments are strings or both are a number ]]
		then
			shapeSides = Array.map(shapeSides, function(side)
				local point0 = side[
					1 --[[ ROBLOX adaptation: added 1 to array index ]]
				]
				local point1 = side[
					2 --[[ ROBLOX adaptation: added 1 to array index ]]
				]
				point0 = {
					math.min(
						point0[
							1 --[[ ROBLOX adaptation: added 1 to array index ]]
						],
						0
					),
					point0[
						2 --[[ ROBLOX adaptation: added 1 to array index ]]
					],
				}
				point1 = {
					math.min(
						point1[
							1 --[[ ROBLOX adaptation: added 1 to array index ]]
						],
						0
					),
					point1[
						2 --[[ ROBLOX adaptation: added 1 to array index ]]
					],
				}
				return { point0, point1 }
			end) --[[ ROBLOX CHECK: check if 'shapeSides' is an Array ]] -- recreate the geometry from the (-) capped points
			geometry = geom2.create(shapeSides)
			geometry = mirrorX(geometry)
		elseif
			#pointsWithPositiveX
			>= #pointsWithNegativeX --[[ ROBLOX CHECK: operator '>=' works only if either both arguments are strings or both are a number ]]
		then
			shapeSides = Array.map(shapeSides, function(side)
				local point0 = side[
					1 --[[ ROBLOX adaptation: added 1 to array index ]]
				]
				local point1 = side[
					2 --[[ ROBLOX adaptation: added 1 to array index ]]
				]
				point0 = {
					math.max(
						point0[
							1 --[[ ROBLOX adaptation: added 1 to array index ]]
						],
						0
					),
					point0[
						2 --[[ ROBLOX adaptation: added 1 to array index ]]
					],
				}
				point1 = {
					math.max(
						point1[
							1 --[[ ROBLOX adaptation: added 1 to array index ]]
						],
						0
					),
					point1[
						2 --[[ ROBLOX adaptation: added 1 to array index ]]
					],
				}
				return { point0, point1 }
			end) --[[ ROBLOX CHECK: check if 'shapeSides' is an Array ]] -- recreate the geometry from the (+) capped points
			geometry = geom2.create(shapeSides)
		end
	end
	local rotationPerSlice = totalRotation / segments
	local isCapped = math.abs(totalRotation) < TAU --[[ ROBLOX CHECK: operator '<' works only if either both arguments are strings or both are a number ]]
	local baseSlice = slice.fromSides(geom2.toSides(geometry))
	Array.reverse(slice, baseSlice, baseSlice) --[[ ROBLOX CHECK: check if 'slice' is an Array ]]
	local matrix = mat4.create()
	local function createSlice(progress, index, base)
		local Zrotation = rotationPerSlice * index + startAngle -- fix rounding error when rotating TAU radians
		if totalRotation == TAU and index == segments then
			Zrotation = startAngle
		end
		mat4.multiply(matrix, mat4.fromZRotation(matrix, Zrotation), mat4.fromXRotation(mat4.create(), TAU / 4))
		return slice.transform(matrix, base)
	end
	options = {
		numberOfSlices = segments + 1,
		capStart = isCapped,
		capEnd = isCapped,
		close = not Boolean.toJSBoolean(isCapped),
		callback = createSlice,
	}
	return extrudeFromSlices(options, baseSlice)
end
return extrudeRotate
