-- ROBLOX NOTE: no upstream

local LuauPolyfill = require("@Packages/LuauPolyfill")
local Array = LuauPolyfill.Array
local Boolean = LuauPolyfill.Boolean
local Error = LuauPolyfill.Error
local Number = LuauPolyfill.Number
local vec2 = require("../../maths/vec2")
local isA = require("./isA")
--[[*
 * Determine if the given object is a valid path2.
 * Checks for valid data points, and duplicate points.
 *
 * **If the geometry is not valid, an exception will be thrown with details of the geometry error.**
 *
 * @param {Object} object - the object to interrogate
 * @throws {Error} error if the geometry is not valid
 * @alias module:modeling/geometries/path2.validate
 ]]
local function validate(object)
	if not Boolean.toJSBoolean(isA(object)) then
		error(Error.new("invalid path2 structure"))
	end -- check for duplicate points
	if
		#object.points
		> 1 --[[ ROBLOX CHECK: operator '>' works only if either both arguments are strings or both are a number ]]
	then
		do
			local i = 0
			while
				i
				< #object.points --[[ ROBLOX CHECK: operator '<' works only if either both arguments are strings or both are a number ]]
			do
				if Boolean.toJSBoolean(vec2.equals(object.points[i], object.points[((i + 1) % #object.points)])) then
					error(Error.new(("path2 duplicate points %s"):format(tostring(object.points[i]))))
				end
				i += 1
			end
		end
	end -- check for infinity, nan
	Array.forEach(object.points, function(point)
		if
			not Boolean.toJSBoolean(
				Array.every(point, Number.isFinite) --[[ ROBLOX CHECK: check if 'point' is an Array ]]
			)
		then
			error(Error.new(("path2 invalid point %s"):format(tostring(point))))
		end
	end) --[[ ROBLOX CHECK: check if 'object.points' is an Array ]] -- check transforms
	if
		not Boolean.toJSBoolean(
			Array.every(object.transforms, Number.isFinite) --[[ ROBLOX CHECK: check if 'object.transforms' is an Array ]]
		)
	then
		error(Error.new(("path2 invalid transforms %s"):format(tostring(object.transforms))))
	end
end
return validate
