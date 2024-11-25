-- ROBLOX NOTE: no upstream

local LuauPolyfill = require("@Packages/LuauPolyfill")
local Array = LuauPolyfill.Array
local Boolean = LuauPolyfill.Boolean
local Error = LuauPolyfill.Error
local flatten = require("../../utils/flatten")
local geom2 = require("../../geometries/geom2")
local geom3 = require("../../geometries/geom3")
local path2 = require("../../geometries/path2")
--[[*
 * Transform the given objects using the given matrix.
 * @param {mat4} matrix - a transformation matrix
 * @param {...Object} objects - the objects to transform
 * @return {Object|Array} the transformed object, or a list of transformed objects
 * @alias module:modeling/transforms.transform
 *
 * @example
 * const newsphere = transform(mat4.rotateX(TAU / 8), sphere())
 ]]
local function transform(
	matrix,
	...: any --[[ ROBLOX CHECK: check correct type of elements. ]]
)
	local objects = { ... }
	-- TODO how to check that the matrix is REAL?
	objects = flatten(objects)
	if #objects == 0 then
		error(Error.new("wrong number of arguments"))
	end
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
return transform
