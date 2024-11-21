-- ROBLOX NOTE: no upstream
local Packages = game.ReplicatedStorage.Packages
local LuauPolyfill = require(Packages.LuauPolyfill)
local Array = LuauPolyfill.Array
local Boolean = LuauPolyfill.Boolean
local compareVectors = require("./compareVectors")
local function comparePolygons(poly1, poly2)
	if #poly1 == #poly2 then
		return Array.reduce(poly1, function(valid, point, index)
			return if Boolean.toJSBoolean(valid) then compareVectors(poly1[index], poly2[index]) else valid
		end, true) --[[ ROBLOX CHECK: check if 'poly1' is an Array ]]
	end
	return false
end
--[[*
 * Compare two list of points for equality
 * @param (Array} list1 - list of polygons, represented as points
 * @param (Array} list2 - list of polygons, represented as points
 * @returns {boolean} result of comparison
 ]]
local function comparePolygonsAsPoints(list1, list2)
	if #list1 == #list2 then
		return Array.reduce(list1, function(valid, polygon, index)
			return if Boolean.toJSBoolean(valid) then comparePolygons(list1[index], list2[index]) else valid
		end, true) --[[ ROBLOX CHECK: check if 'list1' is an Array ]]
	end
	return false
end
return comparePolygonsAsPoints
