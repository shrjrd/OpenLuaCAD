-- ROBLOX NOTE: no upstream

local LuauPolyfill = require("@Packages/LuauPolyfill")
local Array = LuauPolyfill.Array
local Boolean = LuauPolyfill.Boolean
local Error = LuauPolyfill.Error
local flatten = require("../../utils/flatten")
local geom2 = require("../../geometries/geom2")
local path2 = require("../../geometries/path2")
local offsetGeom2 = require("./offsetGeom2")
local offsetPath2 = require("./offsetPath2")
--[[*
 * Create offset geometry from the given geometry using the given options.
 * Offsets from internal and external space are created.
 * @param {Object} options - options for offset
 * @param {Float} [options.delta=1] - delta of offset (+ to exterior, - from interior)
 * @param {String} [options.corners='edge'] - type of corner to create after offseting; edge, chamfer, round
 * @param {Integer} [options.segments=16] - number of segments when creating round corners
 * @param {...Object} objects - the geometries to offset
 * @return {Object|Array} new geometry, or list of new geometries
 * @alias module:modeling/expansions.offset
 *
 * @example
 * let small = offset({ delta: -4, corners: 'chamfer' }, square({size: 40})) // contract
 ]]
local function offset(
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
			return offsetPath2(options, object)
		end
		if Boolean.toJSBoolean(geom2.isA(object)) then
			return offsetGeom2(options, object)
		end -- if (geom3.isA(object)) return geom3.transform(matrix, object)
		return object
	end) --[[ ROBLOX CHECK: check if 'objects' is an Array ]]
	return if #results == 1
		then results[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		]
		else results
end
return offset
