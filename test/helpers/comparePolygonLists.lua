-- ROBLOX NOTE: no upstream
local Packages = game.ReplicatedStorage.Packages
local LuauPolyfill = require(Packages.LuauPolyfill)
local Array = LuauPolyfill.Array
local Boolean = LuauPolyfill.Boolean
local comparePolygons = require("./comparePolygons")
local function comparePolygonLists(polygons1, polygons2)
	if #polygons1 == #polygons2 then
		return Array.reduce(polygons1, function(valid, polygon, index)
			return if Boolean.toJSBoolean(valid) then comparePolygons(polygons1[index], polygons2[index]) else valid
		end, true) --[[ ROBLOX CHECK: check if 'polygons1' is an Array ]]
	end
	return false
end
return comparePolygonLists
