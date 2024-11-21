-- ROBLOX NOTE: no upstream
local Packages = game.ReplicatedStorage.Packages
local LuauPolyfill = require(Packages.LuauPolyfill)
local Error = LuauPolyfill.Error
local Object = LuauPolyfill.Object
local path2 = require("../../geometries/path2")
local offsetFromPoints = require("./offsetFromPoints")
--[[
 * Create a offset geometry from the given path using the given options (if any).
 * @param {Object} options - options for offset
 * @param {Float} [options.delta=1] - delta of offset (+ to exterior, - from interior)
 * @param {String} [options.corners='edge'] - type corner to create during of expansion; edge, chamfer, round
 * @param {Integer} [options.segments=16] - number of segments when creating round corners
 * @param {path2} geometry - geometry from which to create the offset
 * @returns {path2} offset geometry, plus rounded corners
 ]]
local function offsetPath2(options, geometry)
	local defaults = { delta = 1, corners = "edge", closed = geometry.isClosed, segments = 16 }
	local delta, corners, closed, segments
	do
		local ref = Object.assign({}, defaults, options)
		delta, corners, closed, segments = ref.delta, ref.corners, ref.closed, ref.segments
	end
	if not (corners == "edge" or corners == "chamfer" or corners == "round") then
		error(Error.new('corners must be "edge", "chamfer", or "round"'))
	end
	options = { delta = delta, corners = corners, closed = closed, segments = segments }
	local newpoints = offsetFromPoints(options, path2.toPoints(geometry))
	return path2.fromPoints({ closed = closed }, newpoints)
end
return offsetPath2
