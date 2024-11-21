-- ROBLOX NOTE: no upstream
local Packages = game.ReplicatedStorage.Packages
local LuauPolyfill = require(Packages.LuauPolyfill)
local Array = LuauPolyfill.Array
local Boolean = LuauPolyfill.Boolean
local Error = LuauPolyfill.Error
local poly3 = require("../poly3")
local create = require("./create")
--[[*
 * Construct a new 3D geometry from a list of points.
 * The list of points should contain sub-arrays, each defining a single polygon of points.
 * In addition, the points should follow the right-hand rule for rotation in order to
 * define an external facing polygon.
 * @param {Array} listofpoints - list of lists, where each list is a set of points to construct a polygon
 * @returns {geom3} a new geometry
 * @alias module:modeling/geometries/geom3.fromPoints
 ]]
local function fromPoints(listofpoints)
	if not Boolean.toJSBoolean(Array.isArray(listofpoints)) then
		error(Error.new("the given points must be an array"))
	end
	local polygons = Array.map(listofpoints, function(points, index)
		-- TODO catch the error, and rethrow with index
		local polygon = poly3.create(points)
		return polygon
	end) --[[ ROBLOX CHECK: check if 'listofpoints' is an Array ]]
	local result = create(polygons)
	return result
end
return fromPoints
