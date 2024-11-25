-- ROBLOX NOTE: no upstream

local LuauPolyfill = require("@Packages/LuauPolyfill")
local Error = LuauPolyfill.Error
--[[*
 * Converts CSS color notations (string of hex values) to RGB values.
 *
 * @see https://www.w3.org/TR/css-color-3/
 * @param {String} notation - color notation
 * @return {Array} RGB color values
 * @alias module:modeling/colors.hexToRgb
 *
 * @example
 * let mysphere = colorize(hexToRgb('#000080'), sphere()) // navy blue
 ]]
local function hexToRgb(notation)
	notation = notation:replace("#", "")
	if
		#notation
		< 6 --[[ ROBLOX CHECK: operator '<' works only if either both arguments are strings or both are a number ]]
	then
		error(Error.new("the given notation must contain 3 or more hex values"))
	end
	local r = tonumber(notation:sub(0, 2), 16)
	r = r / 255
	local g = tonumber(notation:sub(2, 4), 16)
	g = g / 255
	local b = tonumber(notation:sub(4, 6), 16)
	b = b / 255
	if
		#notation
		>= 8 --[[ ROBLOX CHECK: operator '>=' works only if either both arguments are strings or both are a number ]]
	then
		local a = tonumber(notation:sub(6, 8), 16)
		a = a / 255
		return { r, g, b, a }
	end
	return { r, g, b }
end
return hexToRgb
