-- ROBLOX NOTE: no upstream
local Packages = game.ReplicatedStorage.Packages
local LuauPolyfill = require(Packages.LuauPolyfill)
local Array = LuauPolyfill.Array
local Boolean = LuauPolyfill.Boolean
local Error = LuauPolyfill.Error
local vec2 = require("../../maths/vec2")
local create = require("./create")
--[[*
 * Create a new 2D geometry from the given points.
 * The direction (rotation) of the points is not relevant,
 * as the points can define a convex or a concave polygon.
 * The geometry must not self intersect, i.e. the sides cannot cross.
 * @param {Array} points - list of points in 2D space
 * @returns {geom2} a new geometry
 * @alias module:modeling/geometries/geom2.fromPoints
 ]]
local function fromPoints(points)
	if not Boolean.toJSBoolean(Array.isArray(points)) then
		error(Error.new("the given points must be an array"))
	end
	local length = #points
	if
		length
		< 3 --[[ ROBLOX CHECK: operator '<' works only if either both arguments are strings or both are a number ]]
	then
		error(Error.new("the given points must define a closed geometry with three or more points"))
	end -- adjust length if the given points are closed by the same point
	if
		Boolean.toJSBoolean(vec2.equals(
			points[
				1 --[[ ROBLOX adaptation: added 1 to array index ]]
			],
			points[(length - 1)]
		))
	then
		length -= 1
	end
	local sides = {}
	local prevpoint = points[(length - 1)]
	do
		local i = 0
		while
			i
			< length --[[ ROBLOX CHECK: operator '<' works only if either both arguments are strings or both are a number ]]
		do
			local point = points[i]
			table.insert(sides, { vec2.clone(prevpoint), vec2.clone(point) }) --[[ ROBLOX CHECK: check if 'sides' is an Array ]]
			prevpoint = point
			i += 1
		end
	end
	return create(sides)
end
return fromPoints
