-- ROBLOX NOTE: no upstream

local LuauPolyfill = require("@Packages/LuauPolyfill")
local Array = LuauPolyfill.Array
local Error = LuauPolyfill.Error
local flatten = require("../utils/flatten")
local measureVolume = require("./measureVolume")
--[[*
 * Measure the total (aggregate) volume for the given geometries.
 * Note: This measurement will not account for overlapping geometry
 * @param {...Object} geometries - the geometries to measure.
 * @return {Number} the volume for the group of geometry.
 * @alias module:modeling/measurements.measureAggregateVolume
 *
 * @example
 * let totalVolume = measureAggregateVolume(sphere(),cube())
 ]]
local function measureAggregateVolume(
	...: any --[[ ROBLOX CHECK: check correct type of elements. ]]
)
	local geometries = { ... }
	geometries = flatten(geometries)
	if #geometries == 0 then
		error(Error.new("measureAggregateVolume: no geometries supplied"))
	end
	local volumes = measureVolume(geometries)
	if #geometries == 1 then
		return volumes
	end
	local result = 0
	return Array.reduce(volumes, function(result, volume)
		return result + volume
	end, result) --[[ ROBLOX CHECK: check if 'volumes' is an Array ]]
end
return measureAggregateVolume
