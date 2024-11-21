-- ROBLOX NOTE: no upstream
local Packages = game.ReplicatedStorage.Packages
local LuauPolyfill = require(Packages.LuauPolyfill)
local Error = LuauPolyfill.Error
local Object = LuauPolyfill.Object
local geom3 = require("../../geometries/geom3")
local union = require("../booleans/union")
local expandShell = require("./expandShell")
--[[
 * Expand the given geometry (geom3) using the given options (if any).
 * @param {Object} options - options for expand
 * @param {Number} [options.delta=1] - delta (+/-) of expansion
 * @param {String} [options.corners='round'] - type corner to create during of expansion; round
 * @param {Integer} [options.segments=12] - number of segments when creating round corners
 * @param {geom3} geometry - the geometry to expand
 * @returns {geom3} expanded geometry
 ]]
local function expandGeom3(options, geometry)
	local defaults = { delta = 1, corners = "round", segments = 12 }
	local delta, corners, segments
	do
		local ref = Object.assign({}, defaults, options)
		delta, corners, segments = ref.delta, ref.corners, ref.segments
	end
	if not (corners == "round") then
		error(Error.new('corners must be "round" for 3D geometries'))
	end
	local polygons = geom3.toPolygons(geometry)
	if #polygons == 0 then
		error(Error.new("the given geometry cannot be empty"))
	end
	options = { delta = delta, corners = corners, segments = segments }
	local expanded = expandShell(options, geometry)
	return union(geometry, expanded)
end
return expandGeom3
