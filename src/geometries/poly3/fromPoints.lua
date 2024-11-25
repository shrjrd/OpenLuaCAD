-- ROBLOX NOTE: no upstream

local LuauPolyfill = require("@Packages/LuauPolyfill")
local Array = LuauPolyfill.Array
local vec3 = require("../../maths/vec3")
local create = require("./create")
--[[*
 * Create a polygon from the given points.
 *
 * @param {Array} points - list of points (3D)
 * @returns {poly3} a new polygon
 * @alias module:modeling/geometries/poly3.fromPoints
 *
 * @example
 * const points = [
 *   [0,  0, 0],
 *   [0, 10, 0],
 *   [0, 10, 10]
 * ]
 * const polygon = fromPoints(points)
 ]]
local function fromPoints(points)
	local vertices = Array.map(points, function(point)
		return vec3.clone(point)
	end) --[[ ROBLOX CHECK: check if 'points' is an Array ]]
	return create(vertices)
end
return fromPoints
