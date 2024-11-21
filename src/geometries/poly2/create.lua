-- ROBLOX NOTE: no upstream
--[[*
 * Represents a convex 2D polygon consisting of a list of ordered vertices.
 * @typedef {Object} poly2
 * @property {Array} vertices - list of ordered vertices (2D)
 ]]
--[[*
 * Creates a new polygon with initial values.
 *
 * @param {Array} [vertices] - list of vertices (2D)
 * @returns {poly2} a new polygon
 * @alias module:modeling/geometries/poly2.create
 *
 * @example
 * let polygon = create()
 ]]
local function create(vertices)
	if
		vertices == nil
		or #vertices < 3 --[[ ROBLOX CHECK: operator '<' works only if either both arguments are strings or both are a number ]]
	then
		vertices = {} -- empty contents
	end
	return { vertices = vertices }
end
return create
