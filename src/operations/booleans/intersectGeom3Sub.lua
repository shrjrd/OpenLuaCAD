-- ROBLOX NOTE: no upstream
local Packages = game.ReplicatedStorage.Packages
local LuauPolyfill = require(Packages.LuauPolyfill)
local Boolean = LuauPolyfill.Boolean
local geom3 = require("../../geometries/geom3")
local mayOverlap = require("./mayOverlap")
local Tree = require("./trees").Tree
--[[
 * Return a new 3D geometry representing the space in both the first geometry and
 * the second geometry. None of the given geometries are modified.
 * @param {geom3} geometry1 - a geometry
 * @param {geom3} geometry2 - a geometry
 * @returns {geom3} new 3D geometry
 ]]
local function intersectGeom3Sub(geometry1, geometry2)
	if not Boolean.toJSBoolean(mayOverlap(geometry1, geometry2)) then
		return geom3.create() -- empty geometry
	end
	local a = Tree.new(geom3.toPolygons(geometry1))
	local b = Tree.new(geom3.toPolygons(geometry2))
	a:invert()
	b:clipTo(a)
	b:invert()
	a:clipTo(b)
	b:clipTo(a)
	a:addPolygons(b:allPolygons())
	a:invert()
	local newpolygons = a:allPolygons()
	return geom3.create(newpolygons)
end
return intersectGeom3Sub
