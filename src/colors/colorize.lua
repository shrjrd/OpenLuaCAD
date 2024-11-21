-- ROBLOX NOTE: no upstream
local Packages = game.ReplicatedStorage.Packages
local LuauPolyfill = require(Packages.LuauPolyfill)
local Array = LuauPolyfill.Array
local Boolean = LuauPolyfill.Boolean
local Error = LuauPolyfill.Error
local flatten = require("../utils/flatten")
local geom2 = require("../geometries/geom2")
local geom3 = require("../geometries/geom3")
local path2 = require("../geometries/path2")
local poly3 = require("../geometries/poly3")
local function colorGeom2(color, object)
	local newgeom2 = geom2.clone(object)
	newgeom2.color = color
	return newgeom2
end
local function colorGeom3(color, object)
	local newgeom3 = geom3.clone(object)
	newgeom3.color = color
	return newgeom3
end
local function colorPath2(color, object)
	local newpath2 = path2.clone(object)
	newpath2.color = color
	return newpath2
end
local function colorPoly3(color, object)
	local newpoly = poly3.clone(object)
	newpoly.color = color
	return newpoly
end
--[[*
 * Assign the given color to the given objects.
 * @param {Array} color - RGBA color values, where each value is between 0 and 1.0
 * @param {Object|Array} objects - the objects of which to apply the given color
 * @return {Object|Array} new object, or list of new objects with an additional attribute 'color'
 * @alias module:modeling/colors.colorize
 *
 * @example
 * let redSphere = colorize([1,0,0], sphere()) // red
 * let greenCircle = colorize([0,1,0,0.8], circle()) // green transparent
 * let blueArc = colorize([0,0,1], arc()) // blue
 * let wildcylinder = colorize(colorNameToRgb('fuchsia'), cylinder()) // CSS color
 ]]
local function colorize(
	color,
	...: any --[[ ROBLOX CHECK: check correct type of elements. ]]
)
	local objects = { ... }
	if not Boolean.toJSBoolean(Array.isArray(color)) then
		error(Error.new("color must be an array"))
	end
	if
		#color
		< 3 --[[ ROBLOX CHECK: operator '<' works only if either both arguments are strings or both are a number ]]
	then
		error(Error.new("color must contain R, G and B values"))
	end
	if #color == 3 then
		color = {
			color[
				1 --[[ ROBLOX adaptation: added 1 to array index ]]
			],
			color[
				2 --[[ ROBLOX adaptation: added 1 to array index ]]
			],
			color[
				3 --[[ ROBLOX adaptation: added 1 to array index ]]
			],
			1.0,
		}
	end -- add alpha
	objects = flatten(objects)
	if #objects == 0 then
		error(Error.new("wrong number of arguments"))
	end
	local results = Array.map(objects, function(object)
		if Boolean.toJSBoolean(geom2.isA(object)) then
			return colorGeom2(color, object)
		end
		if Boolean.toJSBoolean(geom3.isA(object)) then
			return colorGeom3(color, object)
		end
		if Boolean.toJSBoolean(path2.isA(object)) then
			return colorPath2(color, object)
		end
		if Boolean.toJSBoolean(poly3.isA(object)) then
			return colorPoly3(color, object)
		end
		object.color = color
		return object
	end) --[[ ROBLOX CHECK: check if 'objects' is an Array ]]
	return if #results == 1
		then results[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		]
		else results
end
return colorize
