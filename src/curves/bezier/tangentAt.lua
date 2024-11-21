-- ROBLOX NOTE: no upstream
local Packages = game.ReplicatedStorage.Packages
local LuauPolyfill = require(Packages.LuauPolyfill)
local Error = LuauPolyfill.Error

local function bezierTangent(bezier, p, t)
	-- from https://pages.mtu.edu/~shene/COURSES/cs3621/NOTES/spline/Bezier/bezier-der.html
	local n = #p - 1
	local result = 0
	do
		local i = 0
		while
			i
			< n --[[ ROBLOX CHECK: operator '<' works only if either both arguments are strings or both are a number ]]
		do
			local q = n * (p[(i + 1)] - p[i])
			result += bezier.tangentPermutations[i] * math.pow(1 - t, n - 1 - i) * math.pow(t, i) * q
			i += 1
		end
	end
	return result
end
--[=[*
 * Calculates the tangent at a specific position along a bezier easing curve.
 * For multidimensional curves, the tangent is the slope of each dimension at that point.
 * See the example called extrudeAlongPath.js
 *
 * @example
 * const b = bezier.create([[0,0,0], [0,5,10], [10,0,-5], [10,10,10]]) // a cubic 3 dimensional easing curve that can generate position arrays for modelling
 * let tangent = bezier.tangentAt(t, b)
 *
 * @param {number} t : the position of which to calculate the bezier's tangent value; 0 < t < 1
 * @param {Object} bezier : an array with at least 2 elements of either all numbers, or all arrays of numbers that are the same size.
 * @return {array | number} the tangent at the requested position.
 * @alias module:modeling/curves/bezier.tangentAt
 ]=]
local function tangentAt(t, bezier)
	if
		t < 0 --[[ ROBLOX CHECK: operator '<' works only if either both arguments are strings or both are a number ]]
		or t > 1 --[[ ROBLOX CHECK: operator '>' works only if either both arguments are strings or both are a number ]]
	then
		error(Error.new("Bezier tangentAt() input must be between 0 and 1"))
	end
	if bezier.pointType == "float_single" then
		return bezierTangent(bezier, bezier.points, t)
	else
		local result = {}
		do
			local i = 0
			while
				i
				< bezier.dimensions --[[ ROBLOX CHECK: operator '<' works only if either both arguments are strings or both are a number ]]
			do
				local singleDimensionPoints = {}
				do
					local j = 0
					while
						j
						< #bezier.points --[[ ROBLOX CHECK: operator '<' works only if either both arguments are strings or both are a number ]]
					do
						table.insert(singleDimensionPoints, bezier.points[j][i]) --[[ ROBLOX CHECK: check if 'singleDimensionPoints' is an Array ]]
						j += 1
					end
				end
				table.insert(result, bezierTangent(bezier, singleDimensionPoints, t)) --[[ ROBLOX CHECK: check if 'result' is an Array ]]
				i += 1
			end
		end
		return result
	end
end
return tangentAt
