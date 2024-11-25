-- ROBLOX NOTE: no upstream

local LuauPolyfill = require("@Packages/LuauPolyfill")
local Array = LuauPolyfill.Array
local Boolean = LuauPolyfill.Boolean
local Set = LuauPolyfill.Set
local geom2 = require("../../geometries/geom2")
local geom3 = require("../../geometries/geom3")
local path2 = require("../../geometries/path2")
--[[
 * Return the unique vertices of a geometry
 ]]
local function toUniquePoints(geometries)
	local found = Set.new()
	local uniquePoints = {}
	local function addPoint(point)
		local key = tostring(point)
		if not Boolean.toJSBoolean(found:has(key)) then
			table.insert(uniquePoints, point) --[[ ROBLOX CHECK: check if 'uniquePoints' is an Array ]]
			found:add(key)
		end
	end
	Array.forEach(geometries, function(geometry)
		if Boolean.toJSBoolean(geom2.isA(geometry)) then
			Array.forEach(geom2.toPoints(geometry), addPoint) --[[ ROBLOX CHECK: check if 'geom2.toPoints(geometry)' is an Array ]]
		elseif Boolean.toJSBoolean(geom3.isA(geometry)) then
			-- points are grouped by polygon
			Array.forEach(geom3.toPoints(geometry), function(points)
				return Array.forEach(points, addPoint) --[[ ROBLOX CHECK: check if 'points' is an Array ]]
			end) --[[ ROBLOX CHECK: check if 'geom3.toPoints(geometry)' is an Array ]]
		elseif Boolean.toJSBoolean(path2.isA(geometry)) then
			Array.forEach(path2.toPoints(geometry), addPoint) --[[ ROBLOX CHECK: check if 'path2.toPoints(geometry)' is an Array ]]
		end
	end) --[[ ROBLOX CHECK: check if 'geometries' is an Array ]]
	return uniquePoints
end
return toUniquePoints
