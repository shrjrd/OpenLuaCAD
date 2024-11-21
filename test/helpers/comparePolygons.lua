-- ROBLOX NOTE: no upstream
local Packages = game.ReplicatedStorage.Packages
local LuauPolyfill = require(Packages.LuauPolyfill)
local Array = LuauPolyfill.Array
local Boolean = LuauPolyfill.Boolean
local compareVectors = require("./compareVectors")
--[[*
 * Compare two polygons for equality
 * @param (poly3} poly1 - polygon with plane and vertices
 * @param (poly3} poly2 - polygon with plane and vertices
 * @returns {boolean} result of comparison
 ]]
local function comparePolygons(poly1, poly2)
	if #poly1.vertices == #poly2.vertices then
		return Array.reduce(poly1.vertices, function(valid, vertex, index)
			return if Boolean.toJSBoolean(valid)
				then compareVectors(poly1.vertices[index], poly2.vertices[index])
				else valid
		end, true) --[[ ROBLOX CHECK: check if 'poly1.vertices' is an Array ]]
	end
	return false
end
return comparePolygons
