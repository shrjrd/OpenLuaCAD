-- ROBLOX NOTE: no upstream
local NEPS = require("../constants").NEPS
--[[
 * Returns zero if n is within epsilon of zero, otherwise return n
 ]]
local function rezero(n)
	return if math.abs(n)
			< NEPS --[[ ROBLOX CHECK: operator '<' works only if either both arguments are strings or both are a number ]]
		then 0
		else n
end
--[[*
 * Return Math.sin but accurate for TAU / 4 rotations.
 * Fixes rounding errors when sin should be 0.
 *
 * @param {Number} radians - angle in radians
 * @returns {Number} sine of the given angle
 * @alias module:modeling/utils.sin
 * @example
 * sin(TAU / 2) == 0
 * sin(TAU) == 0
 ]]
local function sin(radians)
	return rezero(math.sin(radians))
end
--[[*
 * Return Math.cos but accurate for TAU / 4 rotations.
 * Fixes rounding errors when cos should be 0.
 *
 * @param {Number} radians - angle in radians
 * @returns {Number} cosine of the given angle
 * @alias module:modeling/utils.cos
 * @example
 * cos(TAU * 0.25) == 0
 * cos(TAU * 0.75) == 0
 ]]
local function cos(radians)
	return rezero(math.cos(radians))
end
return { sin = sin, cos = cos }
