-- ROBLOX NOTE: no upstream
local Packages = game.ReplicatedStorage.Packages
local LuauPolyfill = require(Packages.LuauPolyfill)
local Array = LuauPolyfill.Array
local Error = LuauPolyfill.Error
local Object = LuauPolyfill.Object
local area = require("../../maths/utils").area
local geom2 = require("../../geometries/geom2")
local path2 = require("../../geometries/path2")
local expand = require("../expansions/expand")
local extrudeLinearGeom2 = require("./extrudeLinearGeom2")
--[[
 * Expand and extrude the given geometry (geom2).
 * @see expand for additional options
 * @param {Object} options - options for extrusion, if any
 * @param {Number} [options.size=1] - size of the rectangle
 * @param {Number} [options.height=1] - height of the extrusion
 * @param {geom2} geometry - the geometry to extrude
 * @return {geom3} the extruded geometry
 ]]
local function extrudeRectangularGeom2(options, geometry)
	local defaults = { size = 1, height = 1 }
	local size, height
	do
		local ref = Object.assign({}, defaults, options)
		size, height = ref.size, ref.height
	end
	options.delta = size
	options.offset = { 0, 0, height } -- convert the geometry to outlines
	local outlines = geom2.toOutlines(geometry)
	if #outlines == 0 then
		error(Error.new("the given geometry cannot be empty"))
	end -- expand the outlines
	local newparts = Array.map(outlines, function(outline)
		if
			area(outline)
			< 0 --[[ ROBLOX CHECK: operator '<' works only if either both arguments are strings or both are a number ]]
		then
			Array.reverse(outline) --[[ ROBLOX CHECK: check if 'outline' is an Array ]]
		end -- all outlines must wind counter clockwise
		return expand(options, path2.fromPoints({ closed = true }, outline))
	end) --[[ ROBLOX CHECK: check if 'outlines' is an Array ]] -- create a composite geometry
	local allsides = Array.reduce(newparts, function(sides, part)
		return Array.concat(sides, geom2.toSides(part)) --[[ ROBLOX CHECK: check if 'sides' is an Array ]]
	end, {}) --[[ ROBLOX CHECK: check if 'newparts' is an Array ]]
	local newgeometry = geom2.create(allsides)
	return extrudeLinearGeom2(options, newgeometry)
end
return extrudeRectangularGeom2
