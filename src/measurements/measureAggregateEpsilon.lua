-- ROBLOX NOTE: no upstream
local Packages = game.ReplicatedStorage.Packages
local LuauPolyfill = require(Packages.LuauPolyfill)
local Array = LuauPolyfill.Array
local Boolean = LuauPolyfill.Boolean
local Error = LuauPolyfill.Error
local flatten = require("../utils/flatten")
local measureAggregateBoundingBox = require("./measureAggregateBoundingBox")
local calculateEpsilonFromBounds = require("./calculateEpsilonFromBounds")
local geom2, geom3, path2
do
	local ref = require("../geometries")
	geom2, geom3, path2 = ref.geom2, ref.geom3, ref.path2
end
--[[*
 * Measure the aggregated Epsilon for the given geometries.
 * @param {...Object} geometries - the geometries to measure
 * @return {Number} the aggregated Epsilon for the whole group of geometries
 * @alias module:modeling/measurements.measureAggregateEpsilon
 *
 * @example
 * let groupEpsilon = measureAggregateEpsilon(sphere(),cube())
 ]]
local function measureAggregateEpsilon(
	...: any --[[ ROBLOX CHECK: check correct type of elements. ]]
)
	local geometries = { ... }
	geometries = flatten(geometries)
	if #geometries == 0 then
		error(Error.new("measureAggregateEpsilon: no geometries supplied"))
	end
	local bounds = measureAggregateBoundingBox(geometries)
	local dimensions = 0
	dimensions = Array.reduce(geometries, function(dimensions, geometry)
		if
			Boolean.toJSBoolean((function()
				local ref = path2.isA(geometry)
				return Boolean.toJSBoolean(ref) and ref or geom2.isA(geometry)
			end)())
		then
			return math.max(dimensions, 2)
		end
		if Boolean.toJSBoolean(geom3.isA(geometry)) then
			return math.max(dimensions, 3)
		end
		return 0
	end, dimensions) --[[ ROBLOX CHECK: check if 'geometries' is an Array ]]
	return calculateEpsilonFromBounds(bounds, dimensions)
end
return measureAggregateEpsilon
