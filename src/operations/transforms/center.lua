-- ROBLOX NOTE: no upstream
local Packages = game.ReplicatedStorage.Packages
local LuauPolyfill = require(Packages.LuauPolyfill)
local Array = LuauPolyfill.Array
local Boolean = LuauPolyfill.Boolean
local Error = LuauPolyfill.Error
local Object = LuauPolyfill.Object
local flatten = require("../../utils/flatten")
local geom2 = require("../../geometries/geom2")
local geom3 = require("../../geometries/geom3")
local path2 = require("../../geometries/path2")
local measureBoundingBox = require("../../measurements/measureBoundingBox")
local translate = require("./translate").translate
local function centerGeometry(options, object)
	local defaults = { axes = { true, true, true }, relativeTo = { 0, 0, 0 } }
	local axes, relativeTo
	do
		local ref = Object.assign({}, defaults, options)
		axes, relativeTo = ref.axes, ref.relativeTo
	end
	local bounds = measureBoundingBox(object)
	local offset = { 0, 0, 0 }
	if
		Boolean.toJSBoolean(axes[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		])
	then
		offset[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		] = relativeTo[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		]
			- (
				bounds[
					1 --[[ ROBLOX adaptation: added 1 to array index ]]
				][
					1 --[[ ROBLOX adaptation: added 1 to array index ]]
				]
				+ (
						bounds[
							2 --[[ ROBLOX adaptation: added 1 to array index ]]
						][
							1 --[[ ROBLOX adaptation: added 1 to array index ]]
						]
						- bounds[
							1 --[[ ROBLOX adaptation: added 1 to array index ]]
						][
							1 --[[ ROBLOX adaptation: added 1 to array index ]]
						]
					)
					/ 2
			)
	end
	if
		Boolean.toJSBoolean(axes[
			2 --[[ ROBLOX adaptation: added 1 to array index ]]
		])
	then
		offset[
			2 --[[ ROBLOX adaptation: added 1 to array index ]]
		] = relativeTo[
			2 --[[ ROBLOX adaptation: added 1 to array index ]]
		]
			- (
				bounds[
					1 --[[ ROBLOX adaptation: added 1 to array index ]]
				][
					2 --[[ ROBLOX adaptation: added 1 to array index ]]
				]
				+ (
						bounds[
							2 --[[ ROBLOX adaptation: added 1 to array index ]]
						][
							2 --[[ ROBLOX adaptation: added 1 to array index ]]
						]
						- bounds[
							1 --[[ ROBLOX adaptation: added 1 to array index ]]
						][
							2 --[[ ROBLOX adaptation: added 1 to array index ]]
						]
					)
					/ 2
			)
	end
	if
		Boolean.toJSBoolean(axes[
			3 --[[ ROBLOX adaptation: added 1 to array index ]]
		])
	then
		offset[
			3 --[[ ROBLOX adaptation: added 1 to array index ]]
		] = relativeTo[
			3 --[[ ROBLOX adaptation: added 1 to array index ]]
		]
			- (
				bounds[
					1 --[[ ROBLOX adaptation: added 1 to array index ]]
				][
					3 --[[ ROBLOX adaptation: added 1 to array index ]]
				]
				+ (
						bounds[
							2 --[[ ROBLOX adaptation: added 1 to array index ]]
						][
							3 --[[ ROBLOX adaptation: added 1 to array index ]]
						]
						- bounds[
							1 --[[ ROBLOX adaptation: added 1 to array index ]]
						][
							3 --[[ ROBLOX adaptation: added 1 to array index ]]
						]
					)
					/ 2
			)
	end
	return translate(offset, object)
end
--[=[*
 * Center the given objects using the given options.
 * @param {Object} options - options for centering
 * @param {Array} [options.axes=[true,true,true]] - axis of which to center, true or false
 * @param {Array} [options.relativeTo=[0,0,0]] - relative point of which to center the objects
 * @param {...Object} objects - the objects to center
 * @return {Object|Array} the centered object, or a list of centered objects
 * @alias module:modeling/transforms.center
 *
 * @example
 * let myshape = center({axes: [true,false,false]}, sphere()) // center about the X axis
 ]=]
local function center(
	options,
	...: any --[[ ROBLOX CHECK: check correct type of elements. ]]
)
	local objects = { ... }
	local defaults = {
		axes = { true, true, true },
		relativeTo = { 0, 0, 0 }, -- TODO: Add additional 'methods' of centering: midpoint, centroid
	}
	local axes, relativeTo
	do
		local ref = Object.assign({}, defaults, options)
		axes, relativeTo = ref.axes, ref.relativeTo
	end
	objects = flatten(objects)
	if #objects == 0 then
		error(Error.new("wrong number of arguments"))
	end
	if #relativeTo ~= 3 then
		error(Error.new("relativeTo must be an array of length 3"))
	end
	options = { axes = axes, relativeTo = relativeTo }
	local results = Array.map(objects, function(object)
		if Boolean.toJSBoolean(path2.isA(object)) then
			return centerGeometry(options, object)
		end
		if Boolean.toJSBoolean(geom2.isA(object)) then
			return centerGeometry(options, object)
		end
		if Boolean.toJSBoolean(geom3.isA(object)) then
			return centerGeometry(options, object)
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
 * Center the given objects about the X axis.
 * @param {...Object} objects - the objects to center
 * @return {Object|Array} the centered object, or a list of centered objects
 * @alias module:modeling/transforms.centerX
 ]]
local function centerX(
	...: any --[[ ROBLOX CHECK: check correct type of elements. ]]
)
	local objects = { ... }
	return center({ axes = { true, false, false } }, objects)
end
--[[*
 * Center the given objects about the Y axis.
 * @param {...Object} objects - the objects to center
 * @return {Object|Array} the centered object, or a list of centered objects
 * @alias module:modeling/transforms.centerY
 ]]
local function centerY(
	...: any --[[ ROBLOX CHECK: check correct type of elements. ]]
)
	local objects = { ... }
	return center({ axes = { false, true, false } }, objects)
end
--[[*
 * Center the given objects about the Z axis.
 * @param {...Object} objects - the objects to center
 * @return {Object|Array} the centered object, or a list of centered objects
 * @alias module:modeling/transforms.centerZ
 ]]
local function centerZ(
	...: any --[[ ROBLOX CHECK: check correct type of elements. ]]
)
	local objects = { ... }
	return center({ axes = { false, false, true } }, objects)
end
return { center = center, centerX = centerX, centerY = centerY, centerZ = centerZ }
