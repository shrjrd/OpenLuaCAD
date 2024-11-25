-- ROBLOX NOTE: no upstream

local LuauPolyfill = require("@Packages/LuauPolyfill")
local Object = LuauPolyfill.Object
--[[*
 * Performs a shallow clone of the given geometry.
 * @param {geom2} geometry - the geometry to clone
 * @returns {geom2} new geometry
 * @alias module:modeling/geometries/geom2.clone
 ]]
local function clone(geometry)
	return Object.assign({}, geometry)
end
return clone
