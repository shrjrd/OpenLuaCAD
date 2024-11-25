-- ROBLOX NOTE: no upstream

local LuauPolyfill = require("@Packages/LuauPolyfill")
local Object = LuauPolyfill.Object
local lengths = require("./lengths")
--[[*
 * Convert a given arc length along a bezier curve to a t value.
 * Useful for generating equally spaced points along a bezier curve.
 *
 * @example
 * const points = [];
 * const segments = 9; // this will generate 10 equally spaced points
 * const increment = #bezier(100, bezierCurve) / segments;
 * for(let i = 0; i <= segments; i++) {
 *   const t = bezier.arcLengthToT({distance: i * increment}, bezierCurve);
 *   const point = bezier.valueAt(t, bezierCurve);
 *   points.push(point);
 * }
 * return points;
 *
 * @param {Object} [options] options for construction
 * @param {Number} [options.distance=0] the distance along the bezier curve for which we want to find the corresponding t value.
 * @param {Number} [options.segments=100] the number of segments to use when approximating the curve length.
 * @param {Object} bezier a bezier curve.
 * @returns a number in the [0, 1] interval or NaN if the arcLength is negative or greater than the total length of the curve.
 * @alias module:modeling/curves/bezier.arcLengthToT
 ]]
local function arcLengthToT(options, bezier)
	local defaults = { distance = 0, segments = 100 }
	local distance, segments
	do
		local ref = Object.assign({}, defaults, options)
		distance, segments = ref.distance, ref.segments
	end
	local arcLengths = lengths(segments, bezier) -- binary search for the index with largest value smaller than target arcLength
	local startIndex = 0
	local endIndex = segments
	while
		startIndex
		<= endIndex --[[ ROBLOX CHECK: operator '<=' works only if either both arguments are strings or both are a number ]]
	do
		local middleIndex = math.floor(startIndex + (endIndex - startIndex) / 2)
		local diff = arcLengths[middleIndex] - distance
		if
			diff
			< 0 --[[ ROBLOX CHECK: operator '<' works only if either both arguments are strings or both are a number ]]
		then
			startIndex = middleIndex + 1
		elseif
			diff
			> 0 --[[ ROBLOX CHECK: operator '>' works only if either both arguments are strings or both are a number ]]
		then
			endIndex = middleIndex - 1
		else
			endIndex = middleIndex
			break
		end
	end -- if we have an exact match, return it
	local targetIndex = endIndex
	if arcLengths[targetIndex] == distance then
		return targetIndex / segments
	end -- we could get finer grain at lengths, or use simple interpolation between two points
	local lengthBefore = arcLengths[targetIndex]
	local lengthAfter = arcLengths[(targetIndex + 1)]
	local segmentLength = lengthAfter - lengthBefore -- determine where we are between the 'before' and 'after' points
	local segmentFraction = (distance - lengthBefore) / segmentLength -- add that fractional amount and return
	return (targetIndex + segmentFraction) / segments
end
return arcLengthToT
