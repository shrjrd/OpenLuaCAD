-- ROBLOX NOTE: no upstream
local Packages = game.ReplicatedStorage.Packages
local LuauPolyfill = require(Packages.LuauPolyfill)
local Array = LuauPolyfill.Array
local Boolean = LuauPolyfill.Boolean
local Error = LuauPolyfill.Error
local Number = LuauPolyfill.Number

local function factorial(b)
	local out = 1
	do
		local i = 2
		while
			i
			<= b --[[ ROBLOX CHECK: operator '<=' works only if either both arguments are strings or both are a number ]]
		do
			out *= i
			i += 1
		end
	end
	return out
end
--[[*
 * Represents a bezier easing function.
 * @typedef {Object} bezier
 * @property {Array} points - The control points for the bezier curve. The first and last point will also be the start and end of the curve
 * @property {string} pointType - A reference to the type and dimensionality of the points that the curve was created from
 * @property {number} dimensions - The dimensionality of the bezier
 * @property {Array} permutations - A pre-calculation of the bezier algorithm's co-efficients
 * @property {Array} tangentPermutations - A pre-calculation of the bezier algorithm's tangent co-efficients
 *
 ]]
local function getPointType(points)
	local firstPointType = nil
	Array.forEach(points, function(point)
		local pType = ""
		if Boolean.toJSBoolean(Number.isFinite(point)) then
			pType = "float_single"
		elseif Boolean.toJSBoolean(Array.isArray(point)) then
			Array.forEach(point, function(val)
				if not Boolean.toJSBoolean(Number.isFinite(val)) then
					error(Error.new("Bezier point values must all be numbers."))
				end
			end) --[[ ROBLOX CHECK: check if 'point' is an Array ]]
			pType = "float_" .. tostring(#point)
		else
			error(Error.new("Bezier points must all be numbers or arrays of number."))
		end
		if
			firstPointType == nil --[[ ROBLOX CHECK: loose equality used upstream ]]
		then
			firstPointType = pType
		else
			if firstPointType ~= pType then
				error(Error.new("Bezier points must be either all numbers or all arrays of numbers of the same size."))
			end
		end
	end) --[[ ROBLOX CHECK: check if 'points' is an Array ]]
	return firstPointType
end
local function getPermutations(c)
	local permutations = {}
	do
		local i = 0
		while
			i
			<= c --[[ ROBLOX CHECK: operator '<=' works only if either both arguments are strings or both are a number ]]
		do
			table.insert(permutations, factorial(c) / (factorial(i) * factorial(c - i))) --[[ ROBLOX CHECK: check if 'permutations' is an Array ]]
			i += 1
		end
	end
	return permutations
end
--[=[*
 * Creates an object representing a bezier easing curve.
 * Curves can have both an arbitrary number of control points, and an arbitrary number of dimensions.
 *
 * @example
 * const b = bezier.create([0,10]) // a linear progression from 0 to 10
 * const b = bezier.create([0, 0, 10, 10]) // a symmetrical cubic easing curve that starts slowly and ends slowly from 0 to 10
 * const b = bezier.create([0,0,0], [0,5,10], [10,0,-5], [10,10,10]]) // a cubic 3 dimensional easing curve that can generate position arrays for modelling
 * // Usage
 * let position = bezier.valueAt(t,b) // where 0 < t < 1
 * let tangent = bezier.tangentAt(t,b) // where 0 < t < 1
 *
 * @param {Array} points An array with at least 2 elements of either all numbers, or all arrays of numbers that are the same size.
 * @returns {bezier} a new bezier data object
 * @alias module:modeling/curves/bezier.create
 ]=]
local function create(points)
	if not Boolean.toJSBoolean(Array.isArray(points)) then
		error(Error.new("Bezier points must be a valid array/"))
	end
	if
		#points
		< 2 --[[ ROBLOX CHECK: operator '<' works only if either both arguments are strings or both are a number ]]
	then
		error(Error.new("Bezier points must contain at least 2 values."))
	end
	local pointType = getPointType(points)
	return {
		points = points,
		pointType = pointType,
		dimensions = if pointType == "float_single"
			then 0
			else points[
				1 --[[ ROBLOX adaptation: added 1 to array index ]]
			].length,
		permutations = getPermutations(#points - 1),
		tangentPermutations = getPermutations(#points - 2),
	}
end
return create
