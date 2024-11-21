-- ROBLOX NOTE: no upstream
local Packages = game.ReplicatedStorage.Packages
local LuauPolyfill = require(Packages.LuauPolyfill)
local Array = LuauPolyfill.Array
local vec3 = require("../../maths/vec3/")
--[[*
 * @param {poly3} polygon - the polygon to measure
 * @return {String} the string representation
 * @alias module:modeling/geometries/poly3.toString
 ]]
local function toString(polygon)
	local result = "poly3. vertices: ["
	Array.forEach(polygon.vertices, function(vertex)
		result ..= ("%s, "):format(tostring(vec3.toString(vertex)))
	end) --[[ ROBLOX CHECK: check if 'polygon.vertices' is an Array ]]
	result ..= "]"
	return result
end
return toString
