-- ROBLOX NOTE: no upstream
local Packages = game.ReplicatedStorage.Packages
local LuauPolyfill = require(Packages.LuauPolyfill)
local Array = LuauPolyfill.Array
local Boolean = LuauPolyfill.Boolean
local Error = LuauPolyfill.Error
local vec3 = require("../../../maths/vec3")
local create = require("./create")
--[[*
 * Create a slice from the given points.
 *
 * @param {Array} points - list of points, where each point is either 2D or 3D
 * @returns {slice} a new slice
 * @alias module:modeling/extrusions/slice.fromPoints
 *
 * @example
 * const points = [
 *   [0,  0],
 *   [0, 10],
 *   [0, 10]
 * ]
 * const slice = fromPoints(points)
 ]]
local function fromPoints(points)
	if not Boolean.toJSBoolean(Array.isArray(points)) then
		error(Error.new("the given points must be an array"))
	end
	if
		#points
		< 3 --[[ ROBLOX CHECK: operator '<' works only if either both arguments are strings or both are a number ]]
	then
		error(Error.new("the given points must contain THREE or more points"))
	end -- create a list of edges from the points
	local edges = {}
	local prevpoint = points[(#points - 1)]
	Array.forEach(points, function(point)
		if #point == 2 then
			table.insert(edges, { vec3.fromVec2(vec3.create(), prevpoint), vec3.fromVec2(vec3.create(), point) }) --[[ ROBLOX CHECK: check if 'edges' is an Array ]]
		end
		if #point == 3 then
			table.insert(edges, { prevpoint, point }) --[[ ROBLOX CHECK: check if 'edges' is an Array ]]
		end
		prevpoint = point
	end) --[[ ROBLOX CHECK: check if 'points' is an Array ]]
	return create(edges)
end
return fromPoints
