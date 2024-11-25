-- ROBLOX NOTE: no upstream

local LuauPolyfill = require("@Packages/LuauPolyfill")
local Error = LuauPolyfill.Error

local function bezierFunction(bezier, p, t)
	local n = #p - 1
	local result = 0
	do
		local i = 0
		while
			i
			<= n --[[ ROBLOX CHECK: operator '<=' works only if either both arguments are strings or both are a number ]]
		do
			result += bezier.permutations[i] * math.pow(1 - t, n - i) * math.pow(t, i) * p[i]
			i += 1
		end
	end
	return result
end
--[=[*
 * Calculates the value at a specific position along a bezier easing curve.
 * For multidimensional curves, the tangent is the slope of each dimension at that point.
 * See the example called extrudeAlongPath.js to see this in use.
 * Math and explanation comes from {@link https://www.freecodecamp.org/news/nerding-out-with-bezier-curves-6e3c0bc48e2f/}
 *
 * @example
 * const b = bezier.create([0,0,0], [0,5,10], [10,0,-5], [10,10,10]]) // a cubic 3 dimensional easing curve that can generate position arrays for modelling
 * let position = bezier.valueAt(t,b) // where 0 < t < 1
 *
 * @param {number} t : the position of which to calculate the value; 0 < t < 1
 * @param {Object} bezier : a bezier curve created with bezier.create().
 * @returns {array | number} the value at the requested position.
 * @alias module:modeling/curves/bezier.valueAt
 ]=]
local function valueAt(t, bezier)
	if
		t < 0 --[[ ROBLOX CHECK: operator '<' works only if either both arguments are strings or both are a number ]]
		or t > 1 --[[ ROBLOX CHECK: operator '>' works only if either both arguments are strings or both are a number ]]
	then
		error(Error.new("Bezier valueAt() input must be between 0 and 1"))
	end
	if bezier.pointType == "float_single" then
		return bezierFunction(bezier, bezier.points, t)
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
				table.insert(result, bezierFunction(bezier, singleDimensionPoints, t)) --[[ ROBLOX CHECK: check if 'result' is an Array ]]
				i += 1
			end
		end
		return result
	end
end

return valueAt
