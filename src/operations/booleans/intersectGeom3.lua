-- ROBLOX NOTE: no upstream

local LuauPolyfill = require("@Packages/LuauPolyfill")
local Array = LuauPolyfill.Array
local flatten = require("../../utils/flatten")
local retessellate = require("../modifiers/retessellate")
local intersectSub = require("./intersectGeom3Sub")
--[[
 * Return a new 3D geometry representing space in both the first geometry and
 * in the subsequent geometries. None of the given geometries are modified.
 * @param {...geom3} geometries - list of 3D geometries
 * @returns {geom3} new 3D geometry
 ]]
local function intersect(
	...: any --[[ ROBLOX CHECK: check correct type of elements. ]]
)
	local geometries = { ... }
	geometries = flatten(geometries)
	local newgeometry = table.remove(geometries, 1) --[[ ROBLOX CHECK: check if 'geometries' is an Array ]]
	Array.forEach(geometries, function(geometry)
		newgeometry = intersectSub(newgeometry, geometry)
	end) --[[ ROBLOX CHECK: check if 'geometries' is an Array ]]
	newgeometry = retessellate(newgeometry)
	return newgeometry
end
return intersect
