-- ROBLOX NOTE: no upstream
local Packages = game.ReplicatedStorage.Packages
local LuauPolyfill = require(Packages.LuauPolyfill)
local Error = LuauPolyfill.Error
local flatten = require("../utils/flatten")
--[[*
 * Converts an RGB color value to HSV.
 *
 * @see http://en.wikipedia.org/wiki/HSV_color_space.
 * @param {...Number|Array} values - RGB or RGBA color values
 * @return {Array} HSV or HSVA color values
 * @alias module:modeling/colors.rgbToHsv
 ]]
local function rgbToHsv(
	...: any --[[ ROBLOX CHECK: check correct type of elements. ]]
)
	local values = { ... }
	values = flatten(values)
	if
		#values
		< 3 --[[ ROBLOX CHECK: operator '<' works only if either both arguments are strings or both are a number ]]
	then
		error(Error.new("values must contain R, G and B values"))
	end
	local r = values[
		1 --[[ ROBLOX adaptation: added 1 to array index ]]
	]
	local g = values[
		2 --[[ ROBLOX adaptation: added 1 to array index ]]
	]
	local b = values[
		3 --[[ ROBLOX adaptation: added 1 to array index ]]
	]
	local max = math.max(r, g, b)
	local min = math.min(r, g, b)
	local h
	local v = max
	local d = max - min
	local s = if max == 0 then 0 else d / max
	if max == min then
		h = 0 -- achromatic
	else
		local condition_ = max
		if condition_ == r then
			h = (g - b) / d
				+ (
					if g
							< b --[[ ROBLOX CHECK: operator '<' works only if either both arguments are strings or both are a number ]]
						then 6
						else 0
				)
		elseif condition_ == g then
			h = (b - r) / d + 2
		elseif condition_ == b then
			h = (r - g) / d + 4
		end
		h /= 6
	end
	if
		#values
		> 3 --[[ ROBLOX CHECK: operator '>' works only if either both arguments are strings or both are a number ]]
	then
		-- add alpha if provided
		local a = values[
			4 --[[ ROBLOX adaptation: added 1 to array index ]]
		]
		return { h, s, v, a }
	end
	return { h, s, v }
end
return rgbToHsv
