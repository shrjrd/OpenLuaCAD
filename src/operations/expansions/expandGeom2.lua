-- ROBLOX NOTE: no upstream
local Packages = game.ReplicatedStorage.Packages
local LuauPolyfill = require(Packages.LuauPolyfill)
local Array = LuauPolyfill.Array
local Error = LuauPolyfill.Error
local Object = LuauPolyfill.Object
local geom2 = require("../../geometries/geom2")
local offsetFromPoints = require("./offsetFromPoints")
--[[
 * Expand the given geometry (geom2) using the given options (if any).
 * @param {Object} options - options for expand
 * @param {Number} [options.delta=1] - delta (+/-) of expansion
 * @param {String} [options.corners='edge'] - type corner to create during of expansion; edge, chamfer, round
 * @param {Integer} [options.segments=16] - number of segments when creating round corners
 * @param {geom2} geometry - the geometry to expand
 * @returns {geom2} expanded geometry
 ]]
local function expandGeom2(options, geometry)
	local defaults = { delta = 1, corners = "edge", segments = 16 }
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
		options = { delta = delta, corners = corners, closed = true, segments = segments }
		return offsetFromPoints(options, outline)
	end) --[[ ROBLOX CHECK: check if 'outlines' is an Array ]] -- create a composite geometry from the new outlines
	local allsides = Array.reduce(newoutlines, function(sides, newoutline)
		return Array.concat(sides, geom2.toSides(geom2.fromPoints(newoutline))) --[[ ROBLOX CHECK: check if 'sides' is an Array ]]
	end, {}) --[[ ROBLOX CHECK: check if 'newoutlines' is an Array ]]
	return geom2.create(allsides)
end
return expandGeom2
