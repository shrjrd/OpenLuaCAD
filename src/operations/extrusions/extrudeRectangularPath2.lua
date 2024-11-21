-- ROBLOX NOTE: no upstream
local Packages = game.ReplicatedStorage.Packages
local LuauPolyfill = require(Packages.LuauPolyfill)
local Error = LuauPolyfill.Error
local Object = LuauPolyfill.Object
local path2 = require("../../geometries/path2")
local expand = require("../expansions/expand")
local extrudeLinearGeom2 = require("./extrudeLinearGeom2")
--[[
 * Expand and extrude the given geometry (path2).
 * @See expand for addition options
 * @param {Object} options - options for extrusion, if any
 * @param {Number} [options.size=1] - size of the rectangle
 * @param {Number} [options.height=1] - height of the extrusion
 * @param {path2} geometry - the geometry to extrude
 * @return {geom3} the extruded geometry
 ]]
local function extrudeRectangularPath2(options, geometry)
	local defaults = { size = 1, height = 1 }
	local size, height
	do
		local ref = Object.assign({}, defaults, options)
		size, height = ref.size, ref.height
	end
	options.delta = size
	options.offset = { 0, 0, height }
	local points = path2.toPoints(geometry)
	if #points == 0 then
		error(Error.new("the given geometry cannot be empty"))
	end
	local newgeometry = expand(options, geometry)
	return extrudeLinearGeom2(options, newgeometry)
end
return extrudeRectangularPath2
