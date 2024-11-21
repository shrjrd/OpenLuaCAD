-- ROBLOX NOTE: no upstream
local Packages = game.ReplicatedStorage.Packages
local LuauPolyfill = require(Packages.LuauPolyfill)
local Array = LuauPolyfill.Array
local flatten = require("../../utils/flatten")
local retessellate = require("../modifiers/retessellate")
local subtractSub = require("./subtractGeom3Sub")
--[[
 * Return a new 3D geometry representing space in this geometry but not in the given geometries.
 * Neither this geometry nor the given geometries are modified.
 * @param {...geom3} geometries - list of geometries
 * @returns {geom3} new 3D geometry
 ]]
local function subtract(
	...: any --[[ ROBLOX CHECK: check correct type of elements. ]]
)
	local geometries = { ... }
	geometries = flatten(geometries)
	local newgeometry = table.remove(geometries, 1) --[[ ROBLOX CHECK: check if 'geometries' is an Array ]]
	Array.forEach(geometries, function(geometry)
		newgeometry = subtractSub(newgeometry, geometry)
	end) --[[ ROBLOX CHECK: check if 'geometries' is an Array ]]
	newgeometry = retessellate(newgeometry)
	return newgeometry
end
return subtract
