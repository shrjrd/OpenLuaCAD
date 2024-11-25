-- ROBLOX NOTE: no upstream

local LuauPolyfill = require("@Packages/LuauPolyfill")
local Array = LuauPolyfill.Array
local vec2 = require("../../maths/vec2")
local toPoints = require("./toPoints")
--[[*
 * Create a string representing the contents of the given path.
 * @param {path2} geometry - the path
 * @returns {String} a representative string
 * @alias module:modeling/geometries/path2.toString
 *
 * @example
 * console.out(toString(path))
 ]]
local function toString(geometry)
	local points = toPoints(geometry)
	local result = "path (" .. tostring(#points) .. " points, " .. tostring(geometry.isClosed) .. "):\n[\n"
	Array.forEach(points, function(point)
		result ..= "  " .. tostring(vec2.toString(point)) .. ",\n"
	end) --[[ ROBLOX CHECK: check if 'points' is an Array ]]
	result ..= "]\n"
	return result
end
return toString
