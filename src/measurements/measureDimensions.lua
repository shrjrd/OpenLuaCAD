-- ROBLOX NOTE: no upstream

local LuauPolyfill = require("@Packages/LuauPolyfill")
local Array = LuauPolyfill.Array
local flatten = require("../utils/flatten")
local measureBoundingBox = require("./measureBoundingBox")
--[[*
 * Measure the dimensions of the given geometries.
 * @param {...Object} geometries - the geometries to measure
 * @return {Array} the dimensions for each geometry, i.e. [width, depth, height]
 * @alias module:modeling/measurements.measureDimensions
 *
 * @example
 * let dimensions = measureDimensions(sphere())
 ]]
local function measureDimensions(
	...: any --[[ ROBLOX CHECK: check correct type of elements. ]]
)
	local geometries = { ... }
	geometries = flatten(geometries)
	local results = Array.map(geometries, function(geometry)
		local boundingBox = measureBoundingBox(geometry)
		return {
			boundingBox[
				2 --[[ ROBLOX adaptation: added 1 to array index ]]
			][
				1 --[[ ROBLOX adaptation: added 1 to array index ]]
			]
				- boundingBox[
					1 --[[ ROBLOX adaptation: added 1 to array index ]]
				][
					1 --[[ ROBLOX adaptation: added 1 to array index ]]
				],
			boundingBox[
				2 --[[ ROBLOX adaptation: added 1 to array index ]]
			][
				2 --[[ ROBLOX adaptation: added 1 to array index ]]
			]
				- boundingBox[
					1 --[[ ROBLOX adaptation: added 1 to array index ]]
				][
					2 --[[ ROBLOX adaptation: added 1 to array index ]]
				],
			boundingBox[
				2 --[[ ROBLOX adaptation: added 1 to array index ]]
			][
				3 --[[ ROBLOX adaptation: added 1 to array index ]]
			]
				- boundingBox[
					1 --[[ ROBLOX adaptation: added 1 to array index ]]
				][
					3 --[[ ROBLOX adaptation: added 1 to array index ]]
				],
		}
	end) --[[ ROBLOX CHECK: check if 'geometries' is an Array ]]
	return if #results == 1
		then results[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		]
		else results
end
return measureDimensions
