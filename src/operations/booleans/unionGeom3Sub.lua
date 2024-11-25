-- ROBLOX NOTE: no upstream

local LuauPolyfill = require("@Packages/LuauPolyfill")
local Array = LuauPolyfill.Array
local Boolean = LuauPolyfill.Boolean
local geom3 = require("../../geometries/geom3")
local mayOverlap = require("./mayOverlap")
local Tree = require("./trees").Tree
-- Like union, but when we know that the two solids are not intersecting
-- Do not use if you are not completely sure that the solids do not intersect!
local function unionForNonIntersecting(geometry1, geometry2)
	local newpolygons = geom3.toPolygons(geometry1)
	newpolygons = Array.concat(newpolygons, geom3.toPolygons(geometry2)) --[[ ROBLOX CHECK: check if 'newpolygons' is an Array ]]
	return geom3.create(newpolygons)
end
--[[
 * Return a new 3D geometry representing the space in the given geometries.
 * @param {geom3} geometry1 - geometry to union
 * @param {geom3} geometry2 - geometry to union
 * @returns {geom3} new 3D geometry
 ]]
local function unionSub(geometry1, geometry2)
	if not Boolean.toJSBoolean(mayOverlap(geometry1, geometry2)) then
		return unionForNonIntersecting(geometry1, geometry2)
	end
	local a = Tree.new(geom3.toPolygons(geometry1))
	local b = Tree.new(geom3.toPolygons(geometry2))
	a:clipTo(b, false) -- b.clipTo(a, true); // ERROR: doesn't work
	b:clipTo(a)
	b:invert()
	b:clipTo(a)
	b:invert()
	local newpolygons = Array.concat(a:allPolygons(), b:allPolygons()) --[[ ROBLOX CHECK: check if 'a.allPolygons()' is an Array ]]
	local result = geom3.create(newpolygons)
	return result
end
return unionSub
