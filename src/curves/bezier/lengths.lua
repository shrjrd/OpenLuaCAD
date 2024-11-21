-- ROBLOX NOTE: no upstream
local Packages = game.ReplicatedStorage.Packages
local LuauPolyfill = require(Packages.LuauPolyfill)
local Array = LuauPolyfill.Array
local Boolean = LuauPolyfill.Boolean
local Error = LuauPolyfill.Error
local Number = LuauPolyfill.Number
local valueAt = require("./valueAt")
--[[*
 * Calculates the Euclidean distance between two n-dimensional points.
 *
 * @example
 * const distance = distanceBetween([0, 0], [0, 10]); // calculate distance between 2D points
 * console.log(distance); // output 10
 *
 * @param {Array} a - first operand.
 * @param {Array} b - second operand.
 * @returns {Number} - distance.
 ]]
local function distanceBetween(a, b)
	if
		Boolean.toJSBoolean((function()
			local ref = Number.isFinite(a)
			return if Boolean.toJSBoolean(ref) then Number.isFinite(b) else ref
		end)())
	then
		return math.abs(a - b)
	elseif
		Boolean.toJSBoolean((function()
			local ref = Array.isArray(a)
			return if Boolean.toJSBoolean(ref) then Array.isArray(b) else ref
		end)())
	then
		if #a ~= #b then
			error(Error.new("The operands must have the same number of dimensions."))
		end
		local sum = 0
		do
			local i = 0
			while
				i
				< #a --[[ ROBLOX CHECK: operator '<' works only if either both arguments are strings or both are a number ]]
			do
				sum += (b[i] - a[i]) * (b[i] - a[i])
				i += 1
			end
		end
		return math.sqrt(sum)
	else
		error(Error.new("The operands must be of the same type, either number or array."))
	end
end
--[=[*
 * Divides the bezier curve into line segments and returns the cumulative length of those segments as an array.
 * Utility function used to calculate the curve's approximate length and determine the equivalence between arc length and time.
 *
 * @example
 * const b = bezier.create([[0, 0], [0, 10]]);
 * const totalLength = lengths(100, b).pop(); // the last element of the array is the curve's approximate length
 *
 * @param {Number} segments the number of segments to use when approximating the curve length.
 * @param {Object} bezier a bezier curve.
 * @returns an array containing the cumulative length of the segments.
 ]=]
local function lengths(segments, bezier)
	local sum = 0
	local lengths = { 0 }
	local previous = valueAt(0, bezier)
	do
		local index = 1
		while
			index
			<= segments --[[ ROBLOX CHECK: operator '<=' works only if either both arguments are strings or both are a number ]]
		do
			local current = valueAt(index / segments, bezier)
			sum += distanceBetween(current, previous)
			table.insert(lengths, sum) --[[ ROBLOX CHECK: check if 'lengths' is an Array ]]
			previous = current
			index += 1
		end
	end
	return lengths
end
return lengths
