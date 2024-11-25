-- ROBLOX NOTE: no upstream

local LuauPolyfill = require("@Packages/LuauPolyfill")
local Boolean = LuauPolyfill.Boolean
--[[*
 * Represents a 3D geometry consisting of a list of edges.
 * @typedef {Object} slice
 * @property {Array} edges - list of edges, each edge containing two points (3D)
 ]]
--[[*
 * Creates a new empty slice.
 *
 * @returns {slice} a new slice
 * @alias module:modeling/extrusions/slice.create
 ]]
local function create(edges)
	if not Boolean.toJSBoolean(edges) then
		edges = {}
	end
	return { edges = edges }
end
return create
