-- ROBLOX NOTE: no upstream
local Packages = game.ReplicatedStorage.Packages
local LuauPolyfill = require(Packages.LuauPolyfill)
local Error = LuauPolyfill.Error
local flatten = require("../utils/flatten")
local hueToColorComponent = require("./hueToColorComponent")
--[[*
 * Converts HSL color values to RGB color values.
 *
 * @see http://en.wikipedia.org/wiki/HSL_color_space
 * @param {...Number|Array} values - HSL or HSLA color values
 * @return {Array} RGB or RGBA color values
 * @alias module:modeling/colors.hslToRgb
 *
 * @example
 * let mysphere = colorize(hslToRgb([0.9166666666666666, 1, 0.5]), sphere())
 ]]
local function hslToRgb(
	...: any --[[ ROBLOX CHECK: check correct type of elements. ]]
)
	local values = { ... }
	values = flatten(values)
	if
		#values
		< 3 --[[ ROBLOX CHECK: operator '<' works only if either both arguments are strings or both are a number ]]
	then
		error(Error.new("values must contain H, S and L values"))
	end
	local h = values[
		1 --[[ ROBLOX adaptation: added 1 to array index ]]
	]
	local s = values[
		2 --[[ ROBLOX adaptation: added 1 to array index ]]
	]
	local l = values[
		3 --[[ ROBLOX adaptation: added 1 to array index ]]
	]
	local r = l -- default is achromatic
	local g = l
	local b = l
	if s ~= 0 then
		local q = if l
				< 0.5 --[[ ROBLOX CHECK: operator '<' works only if either both arguments are strings or both are a number ]]
			then l * (1 + s)
			else l + s - l * s
		local p = 2 * l - q
		r = hueToColorComponent(p, q, h + 1 / 3)
		g = hueToColorComponent(p, q, h)
		b = hueToColorComponent(p, q, h - 1 / 3)
	end
	if
		#values
		> 3 --[[ ROBLOX CHECK: operator '>' works only if either both arguments are strings or both are a number ]]
	then
		-- add alpha value if provided
		local a = values[
			4 --[[ ROBLOX adaptation: added 1 to array index ]]
		]
		return { r, g, b, a }
	end
	return { r, g, b }
end
return hslToRgb
