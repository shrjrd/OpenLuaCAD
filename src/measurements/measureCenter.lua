-- ROBLOX NOTE: no upstream
local Packages = game.ReplicatedStorage.Packages
local LuauPolyfill = require(Packages.LuauPolyfill)
local Array = LuauPolyfill.Array
local flatten = require("../utils/flatten")
local measureBoundingBox = require("./measureBoundingBox")
--[[*
 * Measure the center of the given geometries.
 * @param {...Object} geometries - the geometries to measure
 * @return {Array} the center point for each geometry, i.e. [X, Y, Z]
 * @alias module:modeling/measurements.measureCenter
 *
 * @example
 * let center = measureCenter(sphere())
 ]]
local function measureCenter(
	...: any --[[ ROBLOX CHECK: check correct type of elements. ]]
)
	local geometries = { ... }
	geometries = flatten(geometries)
	local results = Array.map(geometries, function(geometry)
		local bounds = measureBoundingBox(geometry)
		return {
			bounds[
				1 --[[ ROBLOX adaptation: added 1 to array index ]]
			][
				1 --[[ ROBLOX adaptation: added 1 to array index ]]
			]
				+ (
						bounds[
							2 --[[ ROBLOX adaptation: added 1 to array index ]]
						][
							1 --[[ ROBLOX adaptation: added 1 to array index ]]
						]
						- bounds[
							1 --[[ ROBLOX adaptation: added 1 to array index ]]
						][
							1 --[[ ROBLOX adaptation: added 1 to array index ]]
						]
					)
					/ 2,
			bounds[
				1 --[[ ROBLOX adaptation: added 1 to array index ]]
			][
				2 --[[ ROBLOX adaptation: added 1 to array index ]]
			]
				+ (
						bounds[
							2 --[[ ROBLOX adaptation: added 1 to array index ]]
						][
							2 --[[ ROBLOX adaptation: added 1 to array index ]]
						]
						- bounds[
							1 --[[ ROBLOX adaptation: added 1 to array index ]]
						][
							2 --[[ ROBLOX adaptation: added 1 to array index ]]
						]
					)
					/ 2,
			bounds[
				1 --[[ ROBLOX adaptation: added 1 to array index ]]
			][
				3 --[[ ROBLOX adaptation: added 1 to array index ]]
			]
				+ (
						bounds[
							2 --[[ ROBLOX adaptation: added 1 to array index ]]
						][
							3 --[[ ROBLOX adaptation: added 1 to array index ]]
						]
						- bounds[
							1 --[[ ROBLOX adaptation: added 1 to array index ]]
						][
							3 --[[ ROBLOX adaptation: added 1 to array index ]]
						]
					)
					/ 2,
		}
	end) --[[ ROBLOX CHECK: check if 'geometries' is an Array ]]
	return if #results == 1
		then results[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		]
		else results
end
return measureCenter
