-- ROBLOX NOTE: no upstream
local Packages = game.ReplicatedStorage.Packages
local LuauPolyfill = require(Packages.LuauPolyfill)
local Array = LuauPolyfill.Array
local Object = LuauPolyfill.Object
local EPS = require("../../maths/constants").EPS
local vec2 = require("../../maths/vec2")
local close = require("./close")
local create = require("./create")
--[=[*
 * Create a new path from the given points.
 * The points must be provided an array of points,
 * where each point is an array of two numbers.
 * @param {Object} options - options for construction
 * @param {Boolean} [options.closed=false] - if the path should be open or closed
 * @param {Array} points - array of points (2D) from which to create the path
 * @returns {path2} a new path
 * @alias module:modeling/geometries/path2.fromPoints
 *
 * @example:
 * my newpath = fromPoints({closed: true}, [[10, 10], [-10, 10]])
 ]=]
local function fromPoints(options, points)
	local defaults = { closed = false }
	local closed = Object.assign({}, defaults, options).closed
	local created = create()
	created.points = Array.map(points, function(point)
		return vec2.clone(point)
	end) --[[ ROBLOX CHECK: check if 'points' is an Array ]] -- check if first and last points are equal
	if
		#created.points
		> 1 --[[ ROBLOX CHECK: operator '>' works only if either both arguments are strings or both are a number ]]
	then
		local p0 = created.points[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		]
		local pn = created.points[(#created.points - 1)]
		if
			vec2.distance(p0, pn)
			< EPS * EPS --[[ ROBLOX CHECK: operator '<' works only if either both arguments are strings or both are a number ]]
		then
			-- and close automatically
			closed = true
		end
	end
	if closed == true then
		created = close(created)
	end
	return created
end
return fromPoints
