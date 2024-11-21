-- ROBLOX NOTE: no upstream
local Packages = game.ReplicatedStorage.Packages
local LuauPolyfill = require(Packages.LuauPolyfill)
local Array = LuauPolyfill.Array
local Boolean = LuauPolyfill.Boolean
local Error = LuauPolyfill.Error
local flatten = require("../../utils/flatten")
local mat4 = require("../../maths/mat4")
local geom2 = require("../../geometries/geom2")
local geom3 = require("../../geometries/geom3")
local path2 = require("../../geometries/path2")
--[[*
 * Rotate the given objects using the given options.
 * @param {Array} angles - angle (RADIANS) of rotations about X, Y, and Z axis
 * @param {...Object} objects - the objects to rotate
 * @return {Object|Array} the rotated object, or a list of rotated objects
 * @alias module:modeling/transforms.rotate
 *
 * @example
 * const newsphere = rotate([TAU / 8, 0, 0], sphere())
 ]]
local function rotate(
	angles,
	...: any --[[ ROBLOX CHECK: check correct type of elements. ]]
)
	local objects = { ... }
	if not Boolean.toJSBoolean(Array.isArray(angles)) then
		error(Error.new("angles must be an array"))
	end
	objects = flatten(objects)
	if #objects == 0 then
		error(Error.new("wrong number of arguments"))
	end -- adjust the angles if necessary
	angles = Array.slice(angles) --[[ ROBLOX CHECK: check if 'angles' is an Array ]] -- don't modify the original
	while
		#angles
		< 3 --[[ ROBLOX CHECK: operator '<' works only if either both arguments are strings or both are a number ]]
	do
		table.insert(angles, 0) --[[ ROBLOX CHECK: check if 'angles' is an Array ]]
	end
	local yaw = angles[
		3 --[[ ROBLOX adaptation: added 1 to array index ]]
	]
	local pitch = angles[
		2 --[[ ROBLOX adaptation: added 1 to array index ]]
	]
	local roll = angles[
		1 --[[ ROBLOX adaptation: added 1 to array index ]]
	]
	local matrix = mat4.fromTaitBryanRotation(mat4.create(), yaw, pitch, roll)
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
 * Rotate the given objects about the X axis, using the given options.
 * @param {Number} angle - angle (RADIANS) of rotations about X
 * @param {...Object} objects - the objects to rotate
 * @return {Object|Array} the rotated object, or a list of rotated objects
 * @alias module:modeling/transforms.rotateX
 ]]
local function rotateX(
	angle,
	...: any --[[ ROBLOX CHECK: check correct type of elements. ]]
)
	local objects = { ... }
	return rotate({ angle, 0, 0 }, objects)
end
--[[*
 * Rotate the given objects about the Y axis, using the given options.
 * @param {Number} angle - angle (RADIANS) of rotations about Y
 * @param {...Object} objects - the objects to rotate
 * @return {Object|Array} the rotated object, or a list of rotated objects
 * @alias module:modeling/transforms.rotateY
 ]]
local function rotateY(
	angle,
	...: any --[[ ROBLOX CHECK: check correct type of elements. ]]
)
	local objects = { ... }
	return rotate({ 0, angle, 0 }, objects)
end
--[[*
 * Rotate the given objects about the Z axis, using the given options.
 * @param {Number} angle - angle (RADIANS) of rotations about Z
 * @param {...Object} objects - the objects to rotate
 * @return {Object|Array} the rotated object, or a list of rotated objects
 * @alias module:modeling/transforms.rotateZ
 ]]
local function rotateZ(
	angle,
	...: any --[[ ROBLOX CHECK: check correct type of elements. ]]
)
	local objects = { ... }
	return rotate({ 0, 0, angle }, objects)
end
return { rotate = rotate, rotateX = rotateX, rotateY = rotateY, rotateZ = rotateZ }
