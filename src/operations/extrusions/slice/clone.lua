-- ROBLOX NOTE: no upstream

local LuauPolyfill = require("@Packages/LuauPolyfill")
local Array = LuauPolyfill.Array
local create = require("./create")
local vec3 = require("../../../maths/vec3")
--[[*
 * Create a deep clone of the given slice.
 *
 * @param {slice} [out] - receiving slice
 * @param {slice} slice - slice to clone
 * @returns {slice} a new slice
 * @alias module:modeling/extrusions/slice.clone
 ]]
local function clone(
	...: any --[[ ROBLOX CHECK: check correct type of elements. ]]
)
	local params = { ... }
	local out
	local slice
	if #params == 1 then
		out = create()
		slice = params[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		]
	else
		out = params[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		]
		slice = params[
			2 --[[ ROBLOX adaptation: added 1 to array index ]]
		]
	end -- deep clone of edges
	out.edges = Array.map(slice.edges, function(edge)
		return {
			vec3.clone(edge[
				1 --[[ ROBLOX adaptation: added 1 to array index ]]
			]),
			vec3.clone(edge[
				2 --[[ ROBLOX adaptation: added 1 to array index ]]
			]),
		}
	end) --[[ ROBLOX CHECK: check if 'slice.edges' is an Array ]]
	return out
end
return clone
