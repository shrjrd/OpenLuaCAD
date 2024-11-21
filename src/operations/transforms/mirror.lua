-- ROBLOX NOTE: no upstream
local Packages = game.ReplicatedStorage.Packages
local LuauPolyfill = require(Packages.LuauPolyfill)
local Array = LuauPolyfill.Array
local Boolean = LuauPolyfill.Boolean
local Error = LuauPolyfill.Error
local Number = LuauPolyfill.Number
local Object = LuauPolyfill.Object
local flatten = require("../../utils/flatten")
local mat4 = require("../../maths/mat4")
local plane = require("../../maths/plane")
local geom2 = require("../../geometries/geom2")
local geom3 = require("../../geometries/geom3")
local path2 = require("../../geometries/path2")
--[=[*
 * Mirror the given objects using the given options.
 * @param {Object} options - options for mirror
 * @param {Array} [options.origin=[0,0,0]] - the origin of the plane
 * @param {Array} [options.normal=[0,0,1]] - the normal vector of the plane
 * @param {...Object} objects - the objects to mirror
 * @return {Object|Array} the mirrored object, or a list of mirrored objects
 * @alias module:modeling/transforms.mirror
 *
 * @example
 * let myshape = mirror({normal: [0,0,10]}, cube({center: [0,0,15], radius: [20, 25, 5]}))
 ]=]
local function mirror(
	options,
	...: any --[[ ROBLOX CHECK: check correct type of elements. ]]
)
	local objects = { ... }
	local defaults = {
		origin = { 0, 0, 0 },
		normal = { 0, 0, 1 }, -- Z axis
	}
	local origin, normal
	do
		local ref = Object.assign({}, defaults, options)
		origin, normal = ref.origin, ref.normal
	end
	objects = flatten(objects)
	if #objects == 0 then
		error(Error.new("wrong number of arguments"))
	end
	local planeOfMirror = plane.fromNormalAndPoint(plane.create(), normal, origin) -- verify the plane, i.e. check that the given normal was valid
	if
		Boolean.toJSBoolean(Number.isNaN(planeOfMirror[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		]))
	then
		error(Error.new("the given origin and normal do not define a proper plane"))
	end
	local matrix = mat4.mirrorByPlane(mat4.create(), planeOfMirror)
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
 * Mirror the given objects about the X axis.
 * @param {...Object} objects - the objects to mirror
 * @return {Object|Array} the mirrored object, or a list of mirrored objects
 * @alias module:modeling/transforms.mirrorX
 ]]
local function mirrorX(
	...: any --[[ ROBLOX CHECK: check correct type of elements. ]]
)
	local objects = { ... }
	return mirror({ normal = { 1, 0, 0 } }, objects)
end
--[[*
 * Mirror the given objects about the Y axis.
 * @param {...Object} objects - the geometries to mirror
 * @return {Object|Array} the mirrored object, or a list of mirrored objects
 * @alias module:modeling/transforms.mirrorY
 ]]
local function mirrorY(
	...: any --[[ ROBLOX CHECK: check correct type of elements. ]]
)
	local objects = { ... }
	return mirror({ normal = { 0, 1, 0 } }, objects)
end
--[[*
 * Mirror the given objects about the Z axis.
 * @param {...Object} objects - the geometries to mirror
 * @return {Object|Array} the mirrored object, or a list of mirrored objects
 * @alias module:modeling/transforms.mirrorZ
 ]]
local function mirrorZ(
	...: any --[[ ROBLOX CHECK: check correct type of elements. ]]
)
	local objects = { ... }
	return mirror({ normal = { 0, 0, 1 } }, objects)
end
return { mirror = mirror, mirrorX = mirrorX, mirrorY = mirrorY, mirrorZ = mirrorZ }
