-- ROBLOX NOTE: no upstream
local mat4 = require("../../maths/mat4")
--[[*
 * Represents a 3D geometry consisting of a list of polygons.
 * @typedef {Object} geom3
 * @property {Array} polygons - list of polygons, each polygon containing three or more points
 * @property {mat4} transforms - transforms to apply to the polygons, see transform()
 ]]
--[[*
 * Create a new 3D geometry composed of the given polygons.
 * @param {Array} [polygons] - list of polygons, or undefined
 * @returns {geom3} a new geometry
 * @alias module:modeling/geometries/geom3.create
 ]]
local function create(polygons)
	if polygons == nil then
		polygons = {} -- empty contents
	end
	return { polygons = polygons, transforms = mat4.create() }
end
return create
