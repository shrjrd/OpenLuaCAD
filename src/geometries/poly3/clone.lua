-- ROBLOX NOTE: no upstream
local Packages = game.ReplicatedStorage.Packages
local LuauPolyfill = require(Packages.LuauPolyfill)
local Array = LuauPolyfill.Array
local create = require("./create")
local vec3 = require("../../maths/vec3")
--[[*
 * Create a deep clone of the given polygon
 *
 * @param {poly3} [out] - receiving polygon
 * @param {poly3} polygon - polygon to clone
 * @returns {poly3} a new polygon
 * @alias module:modeling/geometries/poly3.clone
 ]]
local function clone(
	...: any --[[ ROBLOX CHECK: check correct type of elements. ]]
)
	local params = { ... }
	local out
	local poly3
	if #params == 1 then
		out = create()
		poly3 = params[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		]
	else
		out = params[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		]
		poly3 = params[
			2 --[[ ROBLOX adaptation: added 1 to array index ]]
		]
	end -- deep clone of vertices
	out.vertices = Array.map(poly3.vertices, function(vec)
		return vec3.clone(vec)
	end) --[[ ROBLOX CHECK: check if 'poly3.vertices' is an Array ]]
	return out
end
return clone
