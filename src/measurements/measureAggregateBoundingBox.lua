-- ROBLOX NOTE: no upstream

local Number_MAX_VALUE = 1.7976931348623157e+308
local LuauPolyfill = require("@Packages/LuauPolyfill")
local Array = LuauPolyfill.Array
local Error = LuauPolyfill.Error
local flatten = require("../utils/flatten")
local vec3min = require("../maths/vec3/min")
local vec3max = require("../maths/vec3/max")
local measureBoundingBox = require("./measureBoundingBox")
--[=[*
 * Measure the aggregated minimum and maximum bounds for the given geometries.
 * @param {...Object} geometries - the geometries to measure
 * @return {Array} the min and max bounds for the group of geometry, i.e. [[x,y,z],[X,Y,Z]]
 * @alias module:modeling/measurements.measureAggregateBoundingBox
 *
 * @example
 * let bounds = measureAggregateBoundingBox(sphere(),cube())
 ]=]
local function measureAggregateBoundingBox(
	...: any --[[ ROBLOX CHECK: check correct type of elements. ]]
)
	local geometries = { ... }
	geometries = flatten(geometries)
	if #geometries == 0 then
		error(Error.new("measureAggregateBoundingBox: no geometries supplied"))
	end
	local bounds = measureBoundingBox(geometries)
	if #geometries == 1 then
		return bounds
	end
	local result = {
		{ Number_MAX_VALUE, Number_MAX_VALUE, Number_MAX_VALUE },
		{ -Number_MAX_VALUE, -Number_MAX_VALUE, -Number_MAX_VALUE },
	}
	return Array.reduce(bounds, function(result, item)
		result = {
			vec3min(
				result[
					1 --[[ ROBLOX adaptation: added 1 to array index ]]
				],
				result[
					1 --[[ ROBLOX adaptation: added 1 to array index ]]
				],
				item[
					1 --[[ ROBLOX adaptation: added 1 to array index ]]
				]
			),
			vec3max(
				result[
					2 --[[ ROBLOX adaptation: added 1 to array index ]]
				],
				result[
					2 --[[ ROBLOX adaptation: added 1 to array index ]]
				],
				item[
					2 --[[ ROBLOX adaptation: added 1 to array index ]]
				]
			),
		}
		return result
	end, result) --[[ ROBLOX CHECK: check if 'bounds' is an Array ]]
end
return measureAggregateBoundingBox
