-- ROBLOX NOTE: no upstream

local LuauPolyfill = require("@Packages/LuauPolyfill")
local Array = LuauPolyfill.Array
--[[*
 * Build an array of at minimum a specified length from an existing array and a padding value. IF the array is already larger than the target length, it will not be shortened.
 * @param {Array} anArray - the source array to copy into the result.
 * @param {*} padding - the value to add to the new array to reach the desired length.
 * @param {Number} targetLength - The desired length of the return array.
 * @returns {Array} an array of at least 'targetLength' length
 * @alias module:modeling/utils.padArrayToLength
 ]]
local function padArrayToLength(anArray, padding, targetLength)
	anArray = Array.slice(anArray) --[[ ROBLOX CHECK: check if 'anArray' is an Array ]]
	local arrayLength = #anArray
	while
		arrayLength
		< targetLength --[[ ROBLOX CHECK: operator '<' works only if either both arguments are strings or both are a number ]]
	do
		arrayLength = arrayLength + 1
		anArray[arrayLength] = padding -- table.insert(anArray, padding) --[[ ROBLOX CHECK: check if 'anArray' is an Array ]]
	end
	return anArray
end
return padArrayToLength
