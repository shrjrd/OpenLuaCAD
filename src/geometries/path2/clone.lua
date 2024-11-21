-- ROBLOX NOTE: no upstream
local Packages = game.ReplicatedStorage.Packages
local LuauPolyfill = require(Packages.LuauPolyfill)
local Object = LuauPolyfill.Object
--[[*
 * Performs a shallow clone of the give geometry.
 * @param {path2} geometry - the geometry to clone
 * @returns {path2} a new path
 * @alias module:modeling/geometries/path2.clone
 ]]
local function clone(geometry)
	return Object.assign({}, geometry)
end
return clone
