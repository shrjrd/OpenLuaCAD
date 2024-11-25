-- ROBLOX NOTE: no upstream

local LuauPolyfill = require("@Packages/LuauPolyfill")
local Array = LuauPolyfill.Array
local Boolean = LuauPolyfill.Boolean
local Error = LuauPolyfill.Error
local Object = LuauPolyfill.Object
local geom2 = require("../../geometries/geom2")
local poly2 = require("../../geometries/poly2")
local offsetFromPoints = require("./offsetFromPoints")
--[[
 * Create a offset geometry from the given geom2 using the given options (if any).
 * @param {Object} options - options for offset
 * @param {Float} [options.delta=1] - delta of offset (+ to exterior, - from interior)
 * @param {String} [options.corners='edge'] - type corner to create during of expansion; edge, chamfer, round
 * @param {Integer} [options.segments=16] - number of segments when creating round corners
 * @param {geom2} geometry - geometry from which to create the offset
 * @returns {geom2} offset geometry, plus rounded corners
 ]]
local function offsetGeom2(options, geometry)
	local defaults = { delta = 1, corners = "edge", segments = 0 }
	local delta, corners, segments
	do
		local ref = Object.assign({}, defaults, options)
		delta, corners, segments = ref.delta, ref.corners, ref.segments
	end
	if not (corners == "edge" or corners == "chamfer" or corners == "round") then
		error(Error.new('corners must be "edge", "chamfer", or "round"'))
	end -- convert the geometry to outlines, and generate offsets from each
	local outlines = geom2.toOutlines(geometry)
	local newoutlines = Array.map(outlines, function(outline)
		local level = Array.reduce(outlines, function(acc, polygon)
			return acc + poly2.arePointsInside(outline, poly2.create(polygon))
		end, 0) --[[ ROBLOX CHECK: check if 'outlines' is an Array ]]
		local outside = level % 2 == 0
		options = {
			delta = if Boolean.toJSBoolean(outside) then delta else -delta,
			corners = corners,
			closed = true,
			segments = segments,
		}
		return offsetFromPoints(options, outline)
	end) --[[ ROBLOX CHECK: check if 'outlines' is an Array ]] -- create a composite geometry from the new outlines
	local allsides = Array.reduce(newoutlines, function(sides, newoutline)
		return Array.concat(sides, geom2.toSides(geom2.fromPoints(newoutline))) --[[ ROBLOX CHECK: check if 'sides' is an Array ]]
	end, {}) --[[ ROBLOX CHECK: check if 'newoutlines' is an Array ]]
	return geom2.create(allsides)
end
return offsetGeom2
