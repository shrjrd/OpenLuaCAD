-- ROBLOX NOTE: no upstream
local concat = require("./concat")
local create = require("./create")
--[=[*
 * Append the given list of points to the end of the given geometry.
 * @param {Array} points - the points (2D) to append to the given path
 * @param {path2} geometry - the given path
 * @returns {path2} a new path with the appended points
 * @alias module:modeling/geometries/path2.appendPoints
 * @example
 * let newpath = appendPoints([[3, 4], [4, 5]], oldpath)
 ]=]
local function appendPoints(points, geometry)
	return concat(geometry, create(points))
end
return appendPoints
