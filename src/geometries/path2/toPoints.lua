-- ROBLOX NOTE: no upstream
local applyTransforms = require("./applyTransforms")
--[[*
 * Produces an array of points from the given geometry.
 * The returned array should not be modified as the data is shared with the geometry.
 * @param {path2} geometry - the geometry
 * @returns {Array} an array of points
 * @alias module:modeling/geometries/path2.toPoints
 *
 * @example
 * let sharedpoints = toPoints(geometry)
 ]]
local function toPoints(geometry)
	return applyTransforms(geometry).points
end
return toPoints
