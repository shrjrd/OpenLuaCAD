-- ROBLOX NOTE: no upstream

local LuauPolyfill = require("@Packages/LuauPolyfill")
local Array = LuauPolyfill.Array
local Boolean = LuauPolyfill.Boolean
local Error = LuauPolyfill.Error
local flatten = require("../../utils/flatten")
local mat4 = require("../../maths/mat4")
local geom2 = require("../../geometries/geom2")
local geom3 = require("../../geometries/geom3")
local path2 = require("../../geometries/path2")
--[[*
 * Scale the given objects using the given options.
 * @param {Array} factors - X, Y, Z factors by which to scale the objects
 * @param {...Object} objects - the objects to scale
 * @return {Object|Array} the scaled object, or a list of scaled objects
 * @alias module:modeling/transforms.scale
 *
 * @example
 * let myshape = scale([5, 0, 10], sphere())
 ]]
local function scale(
	factors,
	...: any --[[ ROBLOX CHECK: check correct type of elements. ]]
)
	local objects = { ... }
	if not Boolean.toJSBoolean(Array.isArray(factors)) then
		error(Error.new("factors must be an array"))
	end
	objects = flatten(objects)
	if #objects == 0 then
		error(Error.new("wrong number of arguments"))
	end -- adjust the factors if necessary
	factors = Array.slice(factors) --[[ ROBLOX CHECK: check if 'factors' is an Array ]] -- don't modify the original
	while
		#factors
		< 3 --[[ ROBLOX CHECK: operator '<' works only if either both arguments are strings or both are a number ]]
	do
		table.insert(factors, 1) --[[ ROBLOX CHECK: check if 'factors' is an Array ]]
	end
	if
		factors[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		] <= 0 --[[ ROBLOX CHECK: operator '<=' works only if either both arguments are strings or both are a number ]]
		or factors[
			2 --[[ ROBLOX adaptation: added 1 to array index ]]
		] <= 0 --[[ ROBLOX CHECK: operator '<=' works only if either both arguments are strings or both are a number ]]
		or factors[
			3 --[[ ROBLOX adaptation: added 1 to array index ]]
		] <= 0 --[[ ROBLOX CHECK: operator '<=' works only if either both arguments are strings or both are a number ]]
	then
		error(Error.new("factors must be positive"))
	end
	local matrix = mat4.fromScaling(mat4.create(), factors)
	local results = Array.map(objects, function(object)
		if Boolean.toJSBoolean(path2.isA(object)) then
			return path2.transform(matrix, object)
		end
		if Boolean.toJSBoolean(geom2.isA(object)) then
			return geom2.transform(matrix, object)
		end
		if Boolean.toJSBoolean(geom3.isA(object)) then
			return geom3.transform(matrix, object)
		end
		return object
	end) --[[ ROBLOX CHECK: check if 'objects' is an Array ]]
	return if #results == 1
		then results[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		]
		else results
end
--[[*
 * Scale the given objects about the X axis using the given options.
 * @param {Number} factor - X factor by which to scale the objects
 * @param {...Object} objects - the objects to scale
 * @return {Object|Array} the scaled object, or a list of scaled objects
 * @alias module:modeling/transforms.scaleX
 ]]
local function scaleX(
	factor,
	...: any --[[ ROBLOX CHECK: check correct type of elements. ]]
)
	local objects = { ... }
	return scale({ factor, 1, 1 }, objects)
end
--[[*
 * Scale the given objects about the Y axis using the given options.
 * @param {Number} factor - Y factor by which to scale the objects
 * @param {...Object} objects - the objects to scale
 * @return {Object|Array} the scaled object, or a list of scaled objects
 * @alias module:modeling/transforms.scaleY
 ]]
local function scaleY(
	factor,
	...: any --[[ ROBLOX CHECK: check correct type of elements. ]]
)
	local objects = { ... }
	return scale({ 1, factor, 1 }, objects)
end
--[[*
 * Scale the given objects about the Z axis using the given options.
 * @param {Number} factor - Z factor by which to scale the objects
 * @param {...Object} objects - the objects to scale
 * @return {Object|Array} the scaled object, or a list of scaled objects
 * @alias module:modeling/transforms.scaleZ
 ]]
local function scaleZ(
	factor,
	...: any --[[ ROBLOX CHECK: check correct type of elements. ]]
)
	local objects = { ... }
	return scale({ 1, 1, factor }, objects)
end
return { scale = scale, scaleX = scaleX, scaleY = scaleY, scaleZ = scaleZ }
