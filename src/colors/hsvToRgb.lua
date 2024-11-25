-- ROBLOX NOTE: no upstream

local LuauPolyfill = require("@Packages/LuauPolyfill")
local Error = LuauPolyfill.Error
local flatten = require("../utils/flatten")
--[[*
 * Converts HSV color values to RGB color values.
 *
 * @see http://en.wikipedia.org/wiki/HSV_color_space.
 * @param {...Number|Array} values - HSV or HSVA color values
 * @return {Array} RGB or RGBA color values
 * @alias module:modeling/colors.hsvToRgb
 *
 * @example
 * let mysphere = colorize(hsvToRgb([0.9166666666666666, 1, 1]), sphere())
 ]]
local function hsvToRgb(
	...: any --[[ ROBLOX CHECK: check correct type of elements. ]]
)
	local values = { ... }
	values = flatten(values)
	if
		#values
		< 3 --[[ ROBLOX CHECK: operator '<' works only if either both arguments are strings or both are a number ]]
	then
		error(Error.new("values must contain H, S and V values"))
	end
	local h = values[
		1 --[[ ROBLOX adaptation: added 1 to array index ]]
	]
	local s = values[
		2 --[[ ROBLOX adaptation: added 1 to array index ]]
	]
	local v = values[
		3 --[[ ROBLOX adaptation: added 1 to array index ]]
	]
	local r = 0
	local g = 0
	local b = 0
	local i = math.floor(h * 6)
	local f = h * 6 - i
	local p = v * (1 - s)
	local q = v * (1 - f * s)
	local t = v * (1 - (1 - f) * s)
	local condition_ = i % 6
	if condition_ == 0 then
		r = v
		g = t
		b = p
	elseif condition_ == 1 then
		r = q
		g = v
		b = p
	elseif condition_ == 2 then
		r = p
		g = v
		b = t
	elseif condition_ == 3 then
		r = p
		g = q
		b = v
	elseif condition_ == 4 then
		r = t
		g = p
		b = v
	elseif condition_ == 5 then
		r = v
		g = p
		b = q
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
return hsvToRgb
