-- ROBLOX NOTE: no upstream
local cssColors = require("./cssColors")
--[[*
 * Converts a CSS color name to RGB color.
 *
 * @param {String} s - the CSS color name
 * @return {Array} the RGB color, or undefined if not found
 * @alias module:modeling/colors.colorNameToRgb
 * @example
 * let mysphere = colorize(colorNameToRgb('lightblue'), sphere())
 ]]
local function colorNameToRgb(s)
	return cssColors[(s:toLowerCase())]
end
return colorNameToRgb
