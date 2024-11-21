-- ROBLOX NOTE: no upstream
local flatten = require("../../utils/flatten")
local retessellate = require("../modifiers/retessellate")
local unionSub = require("./unionGeom3Sub")
--[[
 * Return a new 3D geometry representing the space in the given 3D geometries.
 * @param {...objects} geometries - list of geometries to union
 * @returns {geom3} new 3D geometry
 ]]
local function union(
	...: any --[[ ROBLOX CHECK: check correct type of elements. ]]
)
	local geometries = { ... }
	geometries = flatten(geometries) -- combine geometries in a way that forms a balanced binary tree pattern
	local i
	i = 1
	while
		i
		< #geometries --[[ ROBLOX CHECK: operator '<' works only if either both arguments are strings or both are a number ]]
	do
		table.insert(geometries, unionSub(geometries[(i - 1)], geometries[i])) --[[ ROBLOX CHECK: check if 'geometries' is an Array ]]
		i += 2
	end
	local newgeometry = geometries[(i - 1)]
	newgeometry = retessellate(newgeometry)
	return newgeometry
end
return union
