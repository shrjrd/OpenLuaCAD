-- ROBLOX NOTE: no upstream

local LuauPolyfill = require("@Packages/LuauPolyfill")
local Array = LuauPolyfill.Array
local vec3 = require("../../../maths/vec3")
local function edgesToString(edges)
	return Array.reduce(edges, function(result, edge)
		result ..= ("[%s, %s], "):format(
			tostring(vec3.toString(edge[
				1 --[[ ROBLOX adaptation: added 1 to array index ]]
			])),
			tostring(vec3.toString(edge[
				2 --[[ ROBLOX adaptation: added 1 to array index ]]
			]))
		)
		return result
	end, "") --[[ ROBLOX CHECK: check if 'edges' is an Array ]]
end
--[[*
 * @param {slice} slice - the slice
 * @return {String} the string representation
 * @alias module:modeling/extrusions/slice.toString
 ]]
local function toString(slice)
	return ("[%s]"):format(tostring(edgesToString(slice.edges)))
end
return toString
