-- ROBLOX NOTE: no upstream

local LuauPolyfill = require("@Packages/LuauPolyfill")
local Array = LuauPolyfill.Array
local Boolean = LuauPolyfill.Boolean
local Error = LuauPolyfill.Error
local Number = LuauPolyfill.Number
local signedDistanceToPoint = require("../../maths/plane/signedDistanceToPoint")
local NEPS = require("../../maths/constants").NEPS
local vec3 = require("../../maths/vec3")
local isA = require("./isA")
local isConvex = require("./isConvex")
local measureArea = require("./measureArea")
local plane = require("./plane")
--[[*
 * Determine if the given object is a valid polygon.
 * Checks for valid data structure, convex polygons, and duplicate points.
 *
 * **If the geometry is not valid, an exception will be thrown with details of the geometry error.**
 *
 * @param {Object} object - the object to interrogate
 * @throws {Error} error if the geometry is not valid
 * @alias module:modeling/geometries/poly3.validate
 ]]
local function validate(object)
	if not Boolean.toJSBoolean(isA(object)) then
		error(Error.new("invalid poly3 structure"))
	end -- check for empty polygon
	if
		#object.vertices
		< 3 --[[ ROBLOX CHECK: operator '<' works only if either both arguments are strings or both are a number ]]
	then
		error(Error.new(("poly3 not enough vertices %s"):format(tostring(#object.vertices))))
	end -- check area
	if
		measureArea(object)
		<= 0 --[[ ROBLOX CHECK: operator '<=' works only if either both arguments are strings or both are a number ]]
	then
		error(Error.new("poly3 area must be greater than zero"))
	end -- check for duplicate points
	do
		local i = 0
		while
			i
			< #object.vertices --[[ ROBLOX CHECK: operator '<' works only if either both arguments are strings or both are a number ]]
		do
			if Boolean.toJSBoolean(vec3.equals(object.vertices[i], object.vertices[((i + 1) % #object.vertices)])) then
				error(Error.new(("poly3 duplicate vertex %s"):format(tostring(object.vertices[i]))))
			end
			i += 1
		end
	end -- check convexity
	if not Boolean.toJSBoolean(isConvex(object)) then
		error(Error.new("poly3 must be convex"))
	end -- check for infinity, nan
	Array.forEach(object.vertices, function(vertex)
		if
			not Boolean.toJSBoolean(
				Array.every(vertex, Number.isFinite) --[[ ROBLOX CHECK: check if 'vertex' is an Array ]]
			)
		then
			error(Error.new(("poly3 invalid vertex %s"):format(tostring(vertex))))
		end
	end) --[[ ROBLOX CHECK: check if 'object.vertices' is an Array ]] -- check that points are co-planar
	if
		#object.vertices
		> 3 --[[ ROBLOX CHECK: operator '>' works only if either both arguments are strings or both are a number ]]
	then
		local normal = plane(object)
		Array.forEach(object.vertices, function(vertex)
			local dist = math.abs(signedDistanceToPoint(normal, vertex))
			if
				dist
				> NEPS --[[ ROBLOX CHECK: operator '>' works only if either both arguments are strings or both are a number ]]
			then
				error(
					Error.new(
						("poly3 must be coplanar: vertex %s distance %s"):format(tostring(vertex), tostring(dist))
					)
				)
			end
		end) --[[ ROBLOX CHECK: check if 'object.vertices' is an Array ]]
	end
end
return validate
