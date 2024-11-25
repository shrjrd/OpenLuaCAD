-- ROBLOX NOTE: no upstream

local LuauPolyfill = require("@Packages/LuauPolyfill")
local Array = LuauPolyfill.Array
local create = require("./create")
--[[*
 * Reverse the edges of the given slice.
 *
 * @param {slice} [out] - receiving slice
 * @param {slice} slice - slice to reverse
 * @returns {slice} reverse of the slice
 * @alias module:modeling/extrusions/slice.reverse
 ]]
local function reverse(
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
	end -- reverse the edges
	out.edges = Array.map(slice.edges, function(edge)
		return {
			edge[
				2 --[[ ROBLOX adaptation: added 1 to array index ]]
			],
			edge[
				1 --[[ ROBLOX adaptation: added 1 to array index ]]
			],
		}
	end) --[[ ROBLOX CHECK: check if 'slice.edges' is an Array ]]
	return out
end
return reverse
