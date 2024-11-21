-- ROBLOX NOTE: no upstream
local Packages = game.ReplicatedStorage.Packages
local LuauPolyfill = require(Packages.LuauPolyfill)
local Array = LuauPolyfill.Array
local Boolean = LuauPolyfill.Boolean
local poly3 = require("../poly3")
--[[*
 * Return the given geometry in compact binary representation.
 * @param {geom3} geometry - the geometry
 * @return {TypedArray} compact binary representation
 * @alias module:modeling/geometries/geom3.toCompactBinary
 ]]
local function toCompactBinary(geometry)
	local polygons = geometry.polygons
	local transforms = geometry.transforms
	local numberOfPolygons = #polygons
	local numberOfVertices = Array.reduce(polygons, function(count, polygon)
		return count + #polygon.vertices
	end, 0) --[[ ROBLOX CHECK: check if 'polygons' is an Array ]]
	local color = { -1, -1, -1, -1 }
	if Boolean.toJSBoolean(geometry.color) then
		color = geometry.color
	end -- FIXME why Float32Array?
	local compacted = (1 + 16 + 4 + 1 + numberOfPolygons + numberOfVertices * 3) -- type + transforms + color + numberOfPolygons + numberOfVerticesPerPolygon[] + vertices data[]
	compacted[
		1 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = 1 -- type code: 0 => geom2, 1 => geom3 , 2 => path2
	compacted[
		2 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = transforms[
		1 --[[ ROBLOX adaptation: added 1 to array index ]]
	]
	compacted[
		3 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = transforms[
		2 --[[ ROBLOX adaptation: added 1 to array index ]]
	]
	compacted[
		4 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = transforms[
		3 --[[ ROBLOX adaptation: added 1 to array index ]]
	]
	compacted[
		5 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = transforms[
		4 --[[ ROBLOX adaptation: added 1 to array index ]]
	]
	compacted[
		6 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = transforms[
		5 --[[ ROBLOX adaptation: added 1 to array index ]]
	]
	compacted[
		7 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = transforms[
		6 --[[ ROBLOX adaptation: added 1 to array index ]]
	]
	compacted[
		8 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = transforms[
		7 --[[ ROBLOX adaptation: added 1 to array index ]]
	]
	compacted[
		9 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = transforms[
		8 --[[ ROBLOX adaptation: added 1 to array index ]]
	]
	compacted[
		10 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = transforms[
		9 --[[ ROBLOX adaptation: added 1 to array index ]]
	]
	compacted[
		11 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = transforms[
		10 --[[ ROBLOX adaptation: added 1 to array index ]]
	]
	compacted[
		12 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = transforms[
		11 --[[ ROBLOX adaptation: added 1 to array index ]]
	]
	compacted[
		13 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = transforms[
		12 --[[ ROBLOX adaptation: added 1 to array index ]]
	]
	compacted[
		14 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = transforms[
		13 --[[ ROBLOX adaptation: added 1 to array index ]]
	]
	compacted[
		15 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = transforms[
		14 --[[ ROBLOX adaptation: added 1 to array index ]]
	]
	compacted[
		16 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = transforms[
		15 --[[ ROBLOX adaptation: added 1 to array index ]]
	]
	compacted[
		17 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = transforms[
		16 --[[ ROBLOX adaptation: added 1 to array index ]]
	]
	compacted[
		18 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = color[
		1 --[[ ROBLOX adaptation: added 1 to array index ]]
	]
	compacted[
		19 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = color[
		2 --[[ ROBLOX adaptation: added 1 to array index ]]
	]
	compacted[
		20 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = color[
		3 --[[ ROBLOX adaptation: added 1 to array index ]]
	]
	compacted[
		21 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = color[
		4 --[[ ROBLOX adaptation: added 1 to array index ]]
	]
	compacted[
		22 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = numberOfVertices
	local ci = 22
	local vi = ci + numberOfPolygons
	Array.forEach(polygons, function(polygon)
		local points = poly3.toPoints(polygon) -- record the number of vertices per polygon
		compacted[ci] = #points
		ci += 1 -- convert the vertices
		do
			local i = 0
			while
				i
				< #points --[[ ROBLOX CHECK: operator '<' works only if either both arguments are strings or both are a number ]]
			do
				local point = points[i]
				compacted[(vi + 0)] = point[
					1 --[[ ROBLOX adaptation: added 1 to array index ]]
				]
				compacted[(vi + 1)] = point[
					2 --[[ ROBLOX adaptation: added 1 to array index ]]
				]
				compacted[(vi + 2)] = point[
					3 --[[ ROBLOX adaptation: added 1 to array index ]]
				]
				vi += 3
				i += 1
			end
		end
	end) --[[ ROBLOX CHECK: check if 'polygons' is an Array ]] -- TODO: how about custom properties or fields ?
	return compacted
end
return toCompactBinary
