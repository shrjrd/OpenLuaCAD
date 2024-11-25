-- ROBLOX NOTE: no upstream

local LuauPolyfill = require("@Packages/LuauPolyfill")
local Array = LuauPolyfill.Array
local Boolean = LuauPolyfill.Boolean
local Error = LuauPolyfill.Error
local flatten = require("../../utils/flatten")
local geom2 = require("../../geometries/geom2")
local geom3 = require("../../geometries/geom3")
local path2 = require("../../geometries/path2")
local expandGeom2 = require("./expandGeom2")
local expandGeom3 = require("./expandGeom3")
local expandPath2 = require("./expandPath2")
--[[*
 * Expand the given geometry using the given options.
 * Both internal and external space is expanded for 2D and 3D shapes.
 *
 * Note: Contract is expand using a negative delta.
 * @param {Object} options - options for expand
 * @param {Number} [options.delta=1] - delta (+/-) of expansion
 * @param {String} [options.corners='edge'] - type of corner to create after expanding; edge, chamfer, round
 * @param {Integer} [options.segments=16] - number of segments when creating round corners
 * @param {...Objects} objects - the geometries to expand
 * @return {Object|Array} new geometry, or list of new geometries
 * @alias module:modeling/expansions.expand
 *
 * @example
 * let newarc = expand({delta: 5, corners: 'edge'}, arc({}))
 * let newsquare = expand({delta: 5, corners: 'chamfer'}, square({size: 30}))
 * let newsphere = expand({delta: 2, corners: 'round'}, cuboid({size: [20, 25, 5]}))
 ]]
local function expand(
	options,
	...: any --[[ ROBLOX CHECK: check correct type of elements. ]]
)
	local objects = { ... }
	objects = flatten(objects)
	if #objects == 0 then
		error(Error.new("wrong number of arguments"))
	end
	local results = Array.map(objects, function(object)
		if Boolean.toJSBoolean(path2.isA(object)) then
			return expandPath2(options, object)
		end
		if Boolean.toJSBoolean(geom2.isA(object)) then
			return expandGeom2(options, object)
		end
		if Boolean.toJSBoolean(geom3.isA(object)) then
			return expandGeom3(options, object)
		end
		return object
	end) --[[ ROBLOX CHECK: check if 'objects' is an Array ]]
	return if #results == 1
		then results[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		]
		else results
end
return expand
