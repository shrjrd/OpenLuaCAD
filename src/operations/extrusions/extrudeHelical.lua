-- ROBLOX NOTE: no upstream

local LuauPolyfill = require("@Packages/LuauPolyfill")
local Array = LuauPolyfill.Array
local Boolean = LuauPolyfill.Boolean
local Error = LuauPolyfill.Error
local Math = LuauPolyfill.Math
local Object = LuauPolyfill.Object
local TAU = require("../../maths/constants").TAU
local slice = require("./slice")
local mat4 = require("../../maths/mat4")
local extrudeFromSlices = require("./extrudeFromSlices")
local geom2 = require("../../geometries/geom2")
--[[*
 * Perform a helical extrude of the geometry, using the given options.
 *
 * @param {Object} options - options for extrusion
 * @param {Number} [options.angle=TAU] - angle of the extrusion (RADIANS) positive for right-hand rotation, negative for left-hand
 * @param {Number} [options.startAngle=0] - start angle of the extrusion (RADIANS)
 * @param {Number} [options.pitch=10] - elevation gain for each turn
 * @param {Number} [options.height] - total height of the helix path. Ignored if pitch is set.
 * @param {Number} [options.endOffset=0] - offset the final radius of the extrusion, allowing for tapered helix, and or spiral
 * @param {Number} [options.segmentsPerRotation=32] - number of segments per full rotation of the extrusion
 * @param {geom2} geometry - the geometry to extrude
 * @returns {geom3} the extruded geometry
 * @alias module:modeling/extrusions.extrudeHelical
 *
 * @example
 * const myshape = extrudeHelical(
 *  {
 *      angle: Math.PI * 4,
 *      pitch: 10,
 *      segmentsPerRotation: 64
 *  },
 *  circle({size: 3, center: [10, 0]})
 * )
 ]]
local function extrudeHelical(options, geometry)
	local defaults = { angle = TAU, startAngle = 0, pitch = 10, endOffset = 0, segmentsPerRotation = 32 }
	local angle, endOffset, segmentsPerRotation, startAngle
	do
		local ref = Object.assign({}, defaults, options)
		angle, endOffset, segmentsPerRotation, startAngle =
			ref.angle, ref.endOffset, ref.segmentsPerRotation, ref.startAngle
	end
	local pitch -- ignore height if pitch is set
	if Boolean.toJSBoolean(not Boolean.toJSBoolean(options.pitch) and options.height) then
		pitch = options.height / (angle / TAU)
	else
		pitch = if Boolean.toJSBoolean(options.pitch) then options.pitch else defaults.pitch
	end -- needs at least 3 segments for each revolution
	local minNumberOfSegments = 3
	if
		segmentsPerRotation
		< minNumberOfSegments --[[ ROBLOX CHECK: operator '<' works only if either both arguments are strings or both are a number ]]
	then
		error(Error.new("The number of segments per rotation needs to be at least 3."))
	end
	local shapeSides = geom2.toSides(geometry)
	if #shapeSides == 0 then
		error(Error.new("the given geometry cannot be empty"))
	end -- const pointsWithNegativeX = shapeSides.filter((s) => (s[0][0] < 0))
	local pointsWithPositiveX = Array.filter(shapeSides, function(s)
		return s[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		][
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		] >= 0 --[[ ROBLOX CHECK: operator '>=' works only if either both arguments are strings or both are a number ]]
	end) --[[ ROBLOX CHECK: check if 'shapeSides' is an Array ]]
	local baseSlice = slice.fromSides(shapeSides)
	if #pointsWithPositiveX == 0 then
		-- only points in negative x plane, reverse
		baseSlice = Array.reverse(slice, baseSlice) --[[ ROBLOX CHECK: check if 'slice' is an Array ]]
	end
	local calculatedSegments = Math.round(segmentsPerRotation / TAU * math.abs(angle)) --[[ ROBLOX NOTE: Math.round is currently not supported by the Luau Math polyfill, please add your own implementation or file a ticket on the same ]]
	local segments = if calculatedSegments
			>= 2 --[[ ROBLOX CHECK: operator '>=' works only if either both arguments are strings or both are a number ]]
		then calculatedSegments
		else 2 -- define transform matrix variables for performance increase
	local step1 = mat4.create()
	local matrix
	local function sliceCallback(progress, index, base)
		local zRotation = startAngle + angle / segments * index
		local xOffset = endOffset / segments * index
		local zOffset = (zRotation - startAngle) / TAU * pitch -- TODO: check for valid geometry after translations
		-- ie all the points have to be either x > -xOffset or x < -xOffset
		-- this would have to be checked for every transform, and handled
		--
		-- not implementing, as this currently doesn't break anything,
		-- only creates inside-out polygons
		-- create transformation matrix
		mat4.multiply(
			step1, -- then apply offsets
			mat4.fromTranslation(mat4.create(), { xOffset, 0, zOffset * math.sign(angle) }), -- first rotate "flat" 2D shape from XY to XZ plane
			mat4.fromXRotation(mat4.create(), -TAU / 4 * math.sign(angle)) -- rotate the slice correctly to not create inside-out polygon
		)
		matrix = mat4.create()
		mat4.multiply(
			matrix, -- finally rotate around Z axis
			mat4.fromZRotation(mat4.create(), zRotation),
			step1
		)
		return slice.transform(matrix, base)
	end
	return extrudeFromSlices({
		-- "base" slice is counted as segment, so add one for complete final rotation
		numberOfSlices = segments + 1,
		callback = sliceCallback,
	}, baseSlice)
end
return extrudeHelical
