-- ROBLOX NOTE: no upstream
local Packages = game.ReplicatedStorage.Packages
local LuauPolyfill = require(Packages.LuauPolyfill)
local Error = LuauPolyfill.Error
local flatten = require("../utils/flatten")
--[[*
 * Convert the given RGB color values to CSS color notation (string)
 * @see https://www.w3.org/TR/css-color-3/
 * @param {...Number|Array} values - RGB or RGBA color values
 * @return {String} CSS color notation
 * @alias module:modeling/colors.rgbToHex
 ]]
local function rgbToHex(
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
	] * 255
	local g = values[
		2 --[[ ROBLOX adaptation: added 1 to array index ]]
	] * 255
	local b = values[
		3 --[[ ROBLOX adaptation: added 1 to array index ]]
	] * 255
	local s = ("#%s"):format(tostring(tonumber(0x1000000 + r * 0x10000 + g * 0x100 + b):toString(16):sub(1, 7)))
	if
		#values
		> 3 --[[ ROBLOX CHECK: operator '>' works only if either both arguments are strings or both are a number ]]
	then
		-- convert alpha to opacity
		s = s + tonumber(values[
			4 --[[ ROBLOX adaptation: added 1 to array index ]]
		] * 255):toString(16)
	end
	return s
end
return rgbToHex
