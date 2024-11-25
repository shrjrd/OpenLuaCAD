-- ROBLOX NOTE: no upstream

local Number_EPSILON = 2.220446049250313e-16
local LuauPolyfill = require("@Packages/LuauPolyfill")
local Array = LuauPolyfill.Array
local Boolean = LuauPolyfill.Boolean
local vec3 = require("../../../maths/vec3")
--[[*
 * Determine if the given slices have the same edges.
 * @param {slice} a - the first slice to compare
 * @param {slice} b - the second slice to compare
 * @returns {Boolean} true if the slices are equal
 * @alias module:modeling/extrusions/slice.equals
 ]]
local function equals(a, b)
	local aedges = a.edges
	local bedges = b.edges
	if #aedges ~= #bedges then
		return false
	end
	local isEqual = Array.reduce(aedges, function(acc, aedge, i)
		local bedge = bedges[i]
		local d = vec3.squaredDistance(
			aedge[
				1 --[[ ROBLOX adaptation: added 1 to array index ]]
			],
			bedge[
				1 --[[ ROBLOX adaptation: added 1 to array index ]]
			]
		)
		return if Boolean.toJSBoolean(acc)
			then d
				< Number_EPSILON --[[ ROBLOX CHECK: operator '<' works only if either both arguments are strings or both are a number ]]
			else acc
	end, true) --[[ ROBLOX CHECK: check if 'aedges' is an Array ]]
	return isEqual
end
return equals
