-- ROBLOX NOTE: no upstream
local Packages = game.ReplicatedStorage.Packages
local LuauPolyfill = require(Packages.LuauPolyfill)
local Array = LuauPolyfill.Array
local Boolean = LuauPolyfill.Boolean
local Error = LuauPolyfill.Error
local Math = LuauPolyfill.Math
local vec2 = require("../../maths/vec2")
local geom2 = require("../../geometries/geom2")
local function fromFakePolygon(epsilon, polygon)
	-- this can happen based on union, seems to be residuals -
	-- return null and handle in caller
	if
		#polygon.vertices
		< 4 --[[ ROBLOX CHECK: operator '<' works only if either both arguments are strings or both are a number ]]
	then
		return nil
	end
	local vert1Indices = {}
	local points3D = Array.filter(polygon.vertices, function(vertex, i)
		if
			vertex[
				3 --[[ ROBLOX adaptation: added 1 to array index ]]
			]
			> 0 --[[ ROBLOX CHECK: operator '>' works only if either both arguments are strings or both are a number ]]
		then
			table.insert(vert1Indices, i) --[[ ROBLOX CHECK: check if 'vert1Indices' is an Array ]]
			return true
		end
		return false
	end) --[[ ROBLOX CHECK: check if 'polygon.vertices' is an Array ]]
	if #points3D ~= 2 then
		error(Error.new("Assertion failed: fromFakePolygon: not enough points found")) -- TBD remove later
	end
	local points2D = Array.map(points3D, function(v3)
		local x = Math.round(v3[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		] / epsilon) --[[ ROBLOX NOTE: Math.round is currently not supported by the Luau Math polyfill, please add your own implementation or file a ticket on the same ]]
				* epsilon
			+ 0 -- no more -0
		local y = Math.round(v3[
			2 --[[ ROBLOX adaptation: added 1 to array index ]]
		] / epsilon) --[[ ROBLOX NOTE: Math.round is currently not supported by the Luau Math polyfill, please add your own implementation or file a ticket on the same ]]
				* epsilon
			+ 0 -- no more -0
		return vec2.fromValues(x, y)
	end) --[[ ROBLOX CHECK: check if 'points3D' is an Array ]]
	if
		Boolean.toJSBoolean(vec2.equals(
			points2D[
				1 --[[ ROBLOX adaptation: added 1 to array index ]]
			],
			points2D[
				2 --[[ ROBLOX adaptation: added 1 to array index ]]
			]
		))
	then
		return nil
	end
	local d = vert1Indices[
		2 --[[ ROBLOX adaptation: added 1 to array index ]]
	] - vert1Indices[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		]
	if d == 1 or d == 3 then
		if d == 1 then
			Array.reverse(points2D) --[[ ROBLOX CHECK: check if 'points2D' is an Array ]]
		end
	else
		error(Error.new("Assertion failed: fromFakePolygon: unknown index ordering"))
	end
	return points2D
end
--[[
 * Convert the given polygons to a list of sides.
 * The polygons must have only z coordinates +1 and -1, as constructed by to3DWalls().
 ]]
local function fromFakePolygons(epsilon, polygons)
	local sides = Array.filter(
		Array.map(polygons, function(polygon)
			return fromFakePolygon(epsilon, polygon)
		end), --[[ ROBLOX CHECK: check if 'polygons' is an Array ]]
		function(polygon)
			return polygon ~= nil
		end
	)
	return geom2.create(sides)
end
return fromFakePolygons
