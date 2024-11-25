-- ROBLOX NOTE: no upstream

local LuauPolyfill = require("@Packages/LuauPolyfill")
local Error = LuauPolyfill.Error
local base = {
	"0",
	"1",
	"2",
	"3",
	"4",
	"5",
	"6",
	"7",
	"8",
	"9",
	"A",
	"B",
	"C",
	"D",
	"E",
	"F",
	"G",
	"H",
	"I",
	"J",
	"K",
	"L",
	"M",
	"N",
	"O",
	"P",
	"Q",
	"R",
	"S",
	"T",
	"U",
	"V",
	"W",
	"X",
	"Y",
	"Z",
}
local function toBase(aNumber, aBase)
	assert(aNumber, "bad argument #1 to 'tobase' (nil number)")
	assert(aBase and aBase >= 2 and aBase <= #base, "bad argument #2 to 'tobase' (base out of range)")
	local isNegative = aNumber < 0
	aNumber = math.abs(math.floor(aNumber))
	local aBuffer = {}
	repeat
		aBuffer[#aBuffer + 1] = base[(aNumber % aBase) + 1]
		aNumber = math.floor(aNumber / aBase)
	until aNumber == 0
	if isNegative then
		aBuffer[#aBuffer + 1] = "-"
	end
	return table.concat(aBuffer):reverse()
end
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
	--local s = ("#%s"):format(tostring(tonumber(0x1000000 + r * 0x10000 + g * 0x100 + b):toString(16):sub(1, 7)))
	local s = ("#%s"):format(tostring(toBase(tonumber(0x1000000 + r * 0x10000 + g * 0x100 + b), 16):sub(1, 7)))
	if
		#values
		> 3 --[[ ROBLOX CHECK: operator '>' works only if either both arguments are strings or both are a number ]]
	then
		-- convert alpha to opacity
		--[=[
		s = s + tonumber(values[
			4 --[[ ROBLOX adaptation: added 1 to array index ]]
		] * 255):toString(16)
		]=]
		s = s + toBase(tonumber(values[4] * 255), 16)
	end
	return s
end
return rgbToHex
