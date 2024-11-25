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
 * Translate the given objects using the given options.
 * @param {Array} offset - offset (vector) of which to translate the objects
 * @param {...Object} objects - the objects to translate
 * @return {Object|Array} the translated object, or a list of translated objects
 * @alias module:modeling/transforms.translate
 *
 * @example
 * const newsphere = translate([5, 0, 10], sphere())
 ]]
local function translate(
	offset,
	...: any --[[ ROBLOX CHECK: check correct type of elements. ]]
)
	local objects = { ... }
	if not Boolean.toJSBoolean(Array.isArray(offset)) then
		error(Error.new("offset must be an array"))
	end
	objects = flatten(objects)
	if #objects == 0 then
		error(Error.new("wrong number of arguments"))
	end -- adjust the offset if necessary
	offset = Array.slice(offset) --[[ ROBLOX CHECK: check if 'offset' is an Array ]] -- don't modify the original
	while
		#offset
		< 3 --[[ ROBLOX CHECK: operator '<' works only if either both arguments are strings or both are a number ]]
	do
		table.insert(offset, 0) --[[ ROBLOX CHECK: check if 'offset' is an Array ]]
	end
	local matrix = mat4.fromTranslation(mat4.create(), offset)
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
 * Translate the given objects along the X axis using the given options.
 * @param {Number} offset - X offset of which to translate the objects
 * @param {...Object} objects - the objects to translate
 * @return {Object|Array} the translated object, or a list of translated objects
 * @alias module:modeling/transforms.translateX
 ]]
local function translateX(
	offset,
	...: any --[[ ROBLOX CHECK: check correct type of elements. ]]
)
	local objects = { ... }
	return translate({ offset, 0, 0 }, objects)
end
--[[*
 * Translate the given objects along the Y axis using the given options.
 * @param {Number} offset - Y offset of which to translate the geometries
 * @param {...Object} objects - the objects to translate
 * @return {Object|Array} the translated object, or a list of translated objects
 * @alias module:modeling/transforms.translateY
 ]]
local function translateY(
	offset,
	...: any --[[ ROBLOX CHECK: check correct type of elements. ]]
)
	local objects = { ... }
	return translate({ 0, offset, 0 }, objects)
end
--[[*
 * Translate the given objects along the Z axis using the given options.
 * @param {Number} offset - Z offset of which to translate the geometries
 * @param {...Object} objects - the objects to translate
 * @return {Object|Array} the translated object, or a list of translated objects
 * @alias module:modeling/transforms.translateZ
 ]]
local function translateZ(
	offset,
	...: any --[[ ROBLOX CHECK: check correct type of elements. ]]
)
	local objects = { ... }
	return translate({ 0, 0, offset }, objects)
end
return {
	translate = translate,
	translateX = translateX,
	translateY = translateY,
	translateZ = translateZ,
}
