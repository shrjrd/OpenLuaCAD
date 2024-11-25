-- ROBLOX NOTE: no upstream

local LuauPolyfill = require("@Packages/LuauPolyfill")
local Array = LuauPolyfill.Array
local vec2 = require("../../maths/vec2")
local toSides = require("./toSides")
--[[*
 * Create a string representing the contents of the given geometry.
 * @param {geom2} geometry - the geometry
 * @returns {String} a representative string
 * @alias module:modeling/geometries/geom2.toString
 *
 * @example
 * console.out(toString(geometry))
 ]]
local function toString(geometry)
	local sides = toSides(geometry)
	local result = "geom2 (" .. tostring(#sides) .. " sides):\n[\n"
	Array.forEach(sides, function(side)
		result ..= "  [" .. tostring(vec2.toString(side[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		])) .. ", " .. tostring(vec2.toString(side[
			2 --[[ ROBLOX adaptation: added 1 to array index ]]
		])) .. "]\n"
	end) --[[ ROBLOX CHECK: check if 'sides' is an Array ]]
	result ..= "]\n"
	return result
end
return toString
