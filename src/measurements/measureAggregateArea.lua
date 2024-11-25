-- ROBLOX NOTE: no upstream

local LuauPolyfill = require("@Packages/LuauPolyfill")
local Array = LuauPolyfill.Array
local Error = LuauPolyfill.Error
local flatten = require("../utils/flatten")
local measureArea = require("./measureArea")
--[[*
 * Measure the total (aggregate) area for the given geometries.
 * Note: This measurement will not account for overlapping geometry
 * @param {...Object} geometries - the geometries to measure.
 * @return {Number} the total surface area for the group of geometry.
 * @alias module:modeling/measurements.measureAggregateArea
 *
 * @example
 * let totalArea = measureAggregateArea(sphere(),cube())
 ]]
local function measureAggregateArea(
	...: any --[[ ROBLOX CHECK: check correct type of elements. ]]
)
	local geometries = { ... }
	geometries = flatten(geometries)
	if #geometries == 0 then
		error(Error.new("measureAggregateArea: no geometries supplied"))
	end
	local areas = measureArea(geometries)
	if #geometries == 1 then
		return areas
	end
	local result = 0
	return Array.reduce(areas, function(result, area)
		return result + area
	end, result) --[[ ROBLOX CHECK: check if 'areas' is an Array ]]
end
return measureAggregateArea
