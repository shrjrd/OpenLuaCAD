-- ROBLOX NOTE: no upstream

local LuauPolyfill = require("@Packages/LuauPolyfill")
local Array = LuauPolyfill.Array
local vec3 = require("../../maths/vec3")
local geom2 = require("../../geometries/geom2")
local geom3 = require("../../geometries/geom3")
local poly3 = require("../../geometries/poly3")
--[[
 * Create a polygon (wall) from the given Z values and side.
 ]]
local function to3DWall(z0, z1, side)
	local points = {
		vec3.fromVec2(
			vec3.create(),
			side[
				1 --[[ ROBLOX adaptation: added 1 to array index ]]
			],
			z0
		),
		vec3.fromVec2(
			vec3.create(),
			side[
				2 --[[ ROBLOX adaptation: added 1 to array index ]]
			],
			z0
		),
		vec3.fromVec2(
			vec3.create(),
			side[
				2 --[[ ROBLOX adaptation: added 1 to array index ]]
			],
			z1
		),
		vec3.fromVec2(
			vec3.create(),
			side[
				1 --[[ ROBLOX adaptation: added 1 to array index ]]
			],
			z1
		),
	}
	return poly3.create(points)
end
--[[
 * Create a 3D geometry with walls, as constructed from the given options and geometry.
 *
 * @param {Object} options - options with Z offsets
 * @param {geom2} geometry - geometry used as base of walls
 * @return {geom3} the new geometry
 ]]
local function to3DWalls(options, geometry)
	local sides = geom2.toSides(geometry)
	local polygons = Array.map(sides, function(side)
		return to3DWall(options.z0, options.z1, side)
	end) --[[ ROBLOX CHECK: check if 'sides' is an Array ]]
	local result = geom3.create(polygons)
	return result
end
return to3DWalls
