-- ROBLOX NOTE: no upstream
local Packages = game.ReplicatedStorage.Packages
local LuauPolyfill = require(Packages.LuauPolyfill)
local Array = LuauPolyfill.Array
local Boolean = LuauPolyfill.Boolean
local Error = LuauPolyfill.Error
local Object = LuauPolyfill.Object
local NEPS = require("../maths/constants").NEPS
local vec2 = require("../maths/vec2")
local geom2 = require("../geometries/geom2")
local isNumberArray = require("./commonChecks").isNumberArray -- returns angle C
local function solveAngleFromSSS(a, b, c)
	return math.acos((a * a + b * b - c * c) / (2 * a * b))
end
local function createTriangle(A, B, C, a, b, c)
	local p0 = vec2.fromValues(0, 0) -- everything starts from 0, 0
	local p1 = vec2.fromValues(c, 0)
	local p2 = vec2.fromValues(a, 0)
	vec2.add(p2, vec2.rotate(p2, p2, { 0, 0 }, math.pi - B), p1)
	return geom2.fromPoints({ p0, p1, p2 })
end
-- returns side c
local function solveSideFromSAS(a, C, b)
	if
		C
		> NEPS --[[ ROBLOX CHECK: operator '>' works only if either both arguments are strings or both are a number ]]
	then
		return math.sqrt(a * a + b * b - 2 * a * b * math.cos(C))
	end -- Explained in https://www.nayuki.io/page/numerically-stable-law-of-cosines
	return math.sqrt((a - b) * (a - b) + a * b * C * C * (1 - C * C / 12))
end

-- AAA is when three angles of a triangle, but no sides
local function solveAAA(angles)
	local eps = math.abs(angles[
		1 --[[ ROBLOX adaptation: added 1 to array index ]]
	] + angles[
		2 --[[ ROBLOX adaptation: added 1 to array index ]]
	] + angles[
		3 --[[ ROBLOX adaptation: added 1 to array index ]]
	] - math.pi)
	if
		eps
		> NEPS --[[ ROBLOX CHECK: operator '>' works only if either both arguments are strings or both are a number ]]
	then
		error(Error.new("AAA triangles require angles that sum to PI"))
	end
	local A = angles[
		1 --[[ ROBLOX adaptation: added 1 to array index ]]
	]
	local B = angles[
		2 --[[ ROBLOX adaptation: added 1 to array index ]]
	]
	local C = math.pi - A - B -- Note: This is not 100% proper but...
	-- default the side c length to 1
	-- solve the other lengths
	local c = 1
	local a = c / math.sin(C) * math.sin(A)
	local b = c / math.sin(C) * math.sin(B)
	return createTriangle(A, B, C, a, b, c)
end -- AAS is when two angles and one side are known, and the side is not between the angles
local function solveAAS(values)
	local A = values[
		1 --[[ ROBLOX adaptation: added 1 to array index ]]
	]
	local B = values[
		2 --[[ ROBLOX adaptation: added 1 to array index ]]
	]
	local C = math.pi + NEPS - A - B
	if
		C
		< NEPS --[[ ROBLOX CHECK: operator '<' works only if either both arguments are strings or both are a number ]]
	then
		error(Error.new("AAS triangles require angles that sum to PI"))
	end
	local a = values[
		3 --[[ ROBLOX adaptation: added 1 to array index ]]
	]
	local b = a / math.sin(A) * math.sin(B)
	local c = a / math.sin(A) * math.sin(C)
	return createTriangle(A, B, C, a, b, c)
end -- ASA is when two angles and the side between the angles are known
local function solveASA(values)
	local A = values[
		1 --[[ ROBLOX adaptation: added 1 to array index ]]
	]
	local B = values[
		3 --[[ ROBLOX adaptation: added 1 to array index ]]
	]
	local C = math.pi + NEPS - A - B
	if
		C
		< NEPS --[[ ROBLOX CHECK: operator '<' works only if either both arguments are strings or both are a number ]]
	then
		error(Error.new("ASA triangles require angles that sum to PI"))
	end
	local c = values[
		2 --[[ ROBLOX adaptation: added 1 to array index ]]
	]
	local a = c / math.sin(C) * math.sin(A)
	local b = c / math.sin(C) * math.sin(B)
	return createTriangle(A, B, C, a, b, c)
end -- SAS is when two sides and the angle between them are known
local function solveSAS(values)
	local c = values[
		1 --[[ ROBLOX adaptation: added 1 to array index ]]
	]
	local B = values[
		2 --[[ ROBLOX adaptation: added 1 to array index ]]
	]
	local a = values[
		3 --[[ ROBLOX adaptation: added 1 to array index ]]
	]
	local b = solveSideFromSAS(c, B, a)
	local A = solveAngleFromSSS(b, c, a) -- solve for A
	local C = math.pi - A - B
	return createTriangle(A, B, C, a, b, c)
end -- SSA is when two sides and an angle that is not the angle between the sides are known
local function solveSSA(values)
	local c = values[
		1 --[[ ROBLOX adaptation: added 1 to array index ]]
	]
	local a = values[
		2 --[[ ROBLOX adaptation: added 1 to array index ]]
	]
	local C = values[
		3 --[[ ROBLOX adaptation: added 1 to array index ]]
	]
	local A = math.asin(a * math.sin(C) / c)
	local B = math.pi - A - C
	local b = c / math.sin(C) * math.sin(B)
	return createTriangle(A, B, C, a, b, c)
end -- SSS is when we know three sides of the triangle
local function solveSSS(lengths)
	local a = lengths[
		2 --[[ ROBLOX adaptation: added 1 to array index ]]
	]
	local b = lengths[
		3 --[[ ROBLOX adaptation: added 1 to array index ]]
	]
	local c = lengths[
		1 --[[ ROBLOX adaptation: added 1 to array index ]]
	]
	if
		a + b <= c --[[ ROBLOX CHECK: operator '<=' works only if either both arguments are strings or both are a number ]]
		or b + c <= a --[[ ROBLOX CHECK: operator '<=' works only if either both arguments are strings or both are a number ]]
		or c + a <= b --[[ ROBLOX CHECK: operator '<=' works only if either both arguments are strings or both are a number ]]
	then
		error(Error.new("SSS triangle is incorrect, as the longest side is longer than the sum of the other sides"))
	end
	local A = solveAngleFromSSS(b, c, a) -- solve for A
	local B = solveAngleFromSSS(c, a, b) -- solve for B
	local C = math.pi - A - B
	return createTriangle(A, B, C, a, b, c)
end
--[=[*
 * Construct a triangle in two dimensional space from the given options.
 * The triangle is always constructed CCW from the origin, [0, 0, 0].
 * @see https://www.mathsisfun.com/algebra/trig-solving-triangles.html
 * @param {Object} [options] - options for construction
 * @param {String} [options.type='SSS'] - type of triangle to construct; A ~ angle, S ~ side
 * @param {Array} [options.values=[1,1,1]] - angle (radians) of corners or length of sides
 * @returns {geom2} new 2D geometry
 * @alias module:modeling/primitives.triangle
 *
 * @example
 * let myshape = triangle({type: 'AAS', values: [degToRad(62), degToRad(35), 7]})
 ]=]
local function triangle(options)
	local defaults = { type = "SSS", values = { 1, 1, 1 } }
	local type_, values
	do
		local ref = Object.assign({}, defaults, options)
		type_, values = ref.type, ref.values
	end
	if typeof(type_) ~= "string" then
		error(Error.new("triangle type must be a string"))
	end
	type_ = string.upper(type_) --type_:toUpperCase()
	if
		not (
			(
				type_:sub(1, 1 --[[ ROBLOX adaptation: added 1 to array index ]]) == "A"
				or type_:sub(1, 1 --[[ ROBLOX adaptation: added 1 to array index ]]) == "S"
			)
			and (
				type_:sub(2, 2 --[[ ROBLOX adaptation: added 1 to array index ]]) == "A"
				or type_:sub(2, 2 --[[ ROBLOX adaptation: added 1 to array index ]]) == "S"
			)
			and (
				type_:sub(3, 3 --[[ ROBLOX adaptation: added 1 to array index ]]) == "A"
				or type_:sub(3, 3 --[[ ROBLOX adaptation: added 1 to array index ]]) == "S"
			)
		)
	then
		error(Error.new("triangle type must contain three letters; A or S"))
	end
	if not Boolean.toJSBoolean(isNumberArray(values, 3)) then
		error(Error.new("triangle values must contain three values"))
	end
	if
		not Boolean.toJSBoolean(Array.every(values, function(n)
			return n > 0 --[[ ROBLOX CHECK: operator '>' works only if either both arguments are strings or both are a number ]]
		end) --[[ ROBLOX CHECK: check if 'values' is an Array ]])
	then
		error(Error.new("triangle values must be greater than zero"))
	end
	local condition_ = type_
	if condition_ == "AAA" then
		return solveAAA(values)
	elseif condition_ == "AAS" then
		return solveAAS(values)
	elseif condition_ == "ASA" then
		return solveASA(values)
	elseif condition_ == "SAS" then
		return solveSAS(values)
	elseif condition_ == "SSA" then
		return solveSSA(values)
	elseif condition_ == "SSS" then
		return solveSSS(values)
	else
		error(Error.new("invalid triangle type, try again"))
	end
end
return triangle
