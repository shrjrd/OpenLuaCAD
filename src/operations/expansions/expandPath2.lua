-- ROBLOX NOTE: no upstream

local LuauPolyfill = require("@Packages/LuauPolyfill")
local Array = LuauPolyfill.Array
local Boolean = LuauPolyfill.Boolean
local Error = LuauPolyfill.Error
local Object = LuauPolyfill.Object
local area = require("../../maths/utils/area")
local vec2 = require("../../maths/vec2")
local geom2 = require("../../geometries/geom2")
local path2 = require("../../geometries/path2")
local offsetFromPoints = require("./offsetFromPoints")
local function createGeometryFromClosedOffsets(paths)
	local external, internal = paths.external, paths.internal
	if
		area(external)
		< 0 --[[ ROBLOX CHECK: operator '<' works only if either both arguments are strings or both are a number ]]
	then
		external = Array.reverse(external) --[[ ROBLOX CHECK: check if 'external' is an Array ]]
	else
		internal = Array.reverse(internal) --[[ ROBLOX CHECK: check if 'internal' is an Array ]]
	end -- NOTE: creating path2 from the points ensures proper closure
	local externalPath = path2.fromPoints({ closed = true }, external)
	local internalPath = path2.fromPoints({ closed = true }, internal)
	local externalSides = geom2.toSides(geom2.fromPoints(path2.toPoints(externalPath)))
	local _internalSides = geom2.toSides(geom2.fromPoints(path2.toPoints(internalPath)))
	table.insert(
		externalSides,
		error("not implemented") --[[ ROBLOX TODO: Unhandled node for type: SpreadElement ]] --[[ ...internalSides ]]
	) --[[ ROBLOX CHECK: check if 'externalSides' is an Array ]]
	return geom2.create(externalSides)
end
local function createGeometryFromExpandedOpenPath(paths, segments, corners, delta)
	local points, external, internal = paths.points, paths.external, paths.internal
	local capSegments = math.floor(segments / 2) -- rotation is 180 degrees
	local e2iCap = {}
	local i2eCap = {}
	if
		corners == "round"
		and capSegments > 0 --[[ ROBLOX CHECK: operator '>' works only if either both arguments are strings or both are a number ]]
	then
		-- added round caps to the geometry
		local step = math.pi / capSegments
		local eCorner = points[(#points - 1)]
		local e2iStart = vec2.angle(vec2.subtract(vec2.create(), external[(#external - 1)], eCorner))
		local iCorner = points[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		]
		local i2eStart = vec2.angle(vec2.subtract(
			vec2.create(),
			internal[
				1 --[[ ROBLOX adaptation: added 1 to array index ]]
			],
			iCorner
		))
		do
			local i = 1
			while
				i
				< capSegments --[[ ROBLOX CHECK: operator '<' works only if either both arguments are strings or both are a number ]]
			do
				local radians = e2iStart + step * i
				local point = vec2.fromAngleRadians(vec2.create(), radians)
				vec2.scale(point, point, delta)
				vec2.add(point, point, eCorner)
				table.insert(e2iCap, point) --[[ ROBLOX CHECK: check if 'e2iCap' is an Array ]]
				radians = i2eStart + step * i
				point = vec2.fromAngleRadians(vec2.create(), radians)
				vec2.scale(point, point, delta)
				vec2.add(point, point, iCorner)
				table.insert(i2eCap, point) --[[ ROBLOX CHECK: check if 'i2eCap' is an Array ]]
				i += 1
			end
		end
	end
	local allPoints = {}
	Array.concat(allPoints, {
		error("not implemented"),--[[ ROBLOX TODO: Unhandled node for type: SpreadElement ]]--[[ ...external ]]
		error("not implemented"),--[[ ROBLOX TODO: Unhandled node for type: SpreadElement ]]--[[ ...e2iCap ]]
		error("not implemented"),--[[ ROBLOX TODO: Unhandled node for type: SpreadElement ]]--[[ ...internal.reverse() ]]
		error("not implemented"),--[[ ROBLOX TODO: Unhandled node for type: SpreadElement ]]--[[ ...i2eCap ]]
	}) --[[ ROBLOX CHECK: check if 'allPoints' is an Array ]]
	return geom2.fromPoints(allPoints)
end
--[[
 * Expand the given geometry (path2) using the given options (if any).
 * @param {Object} options - options for expand
 * @param {Number} [options.delta=1] - delta (+) of expansion
 * @param {String} [options.corners='edge'] - type corner to create during of expansion; edge, chamfer, round
 * @param {Integer} [options.segments=16] - number of segments when creating round corners
 * @param {path2} geometry - the geometry to expand
 * @returns {geom2} expanded geometry
 ]]
local function expandPath2(options, geometry)
	local defaults = { delta = 1, corners = "edge", segments = 16 }
	options = Object.assign({}, defaults, options)
	local delta, corners, segments = options.delta, options.corners, options.segments
	if
		delta
		<= 0 --[[ ROBLOX CHECK: operator '<=' works only if either both arguments are strings or both are a number ]]
	then
		error(Error.new("the given delta must be positive for paths"))
	end
	if not (corners == "edge" or corners == "chamfer" or corners == "round") then
		error(Error.new('corners must be "edge", "chamfer", or "round"'))
	end
	local closed = geometry.isClosed
	local points = path2.toPoints(geometry)
	if #points == 0 then
		error(Error.new("the given geometry cannot be empty"))
	end
	local paths = {
		points = points,
		external = offsetFromPoints({ delta = delta, corners = corners, segments = segments, closed = closed }, points),
		internal = offsetFromPoints(
			{ delta = -delta, corners = corners, segments = segments, closed = closed },
			points
		),
	}
	if Boolean.toJSBoolean(geometry.isClosed) then
		return createGeometryFromClosedOffsets(paths)
	else
		return createGeometryFromExpandedOpenPath(paths, segments, corners, delta)
	end
end
return expandPath2
