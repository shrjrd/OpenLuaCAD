-- ROBLOX NOTE: no upstream

local LuauPolyfill = require("@Packages/LuauPolyfill")
local Array = LuauPolyfill.Array
local Boolean = LuauPolyfill.Boolean
local Error = LuauPolyfill.Error
local vec3 = require("../../../maths/vec3")
local create = require("./create")
--[[*
 * Create a slice from the given sides (see geom2).
 *
 * @param {Array} sides - list of sides from geom2
 * @returns {slice} a new slice
 * @alias module:modeling/extrusions/slice.fromSides
 *
 * @example
 * const myshape = circle({radius: 10})
 * const slice = fromSides(geom2.toSides(myshape))
 ]]
local function fromSides(sides)
	if not Boolean.toJSBoolean(Array.isArray(sides)) then
		error(Error.new("the given sides must be an array"))
	end -- create a list of edges from the sides
	local edges = {}
	Array.forEach(sides, function(side)
		table.insert(edges, {
			vec3.fromVec2(
				vec3.create(),
				side[
					1 --[[ ROBLOX adaptation: added 1 to array index ]]
				]
			),
			vec3.fromVec2(
				vec3.create(),
				side[
					2 --[[ ROBLOX adaptation: added 1 to array index ]]
				]
			),
		}) --[[ ROBLOX CHECK: check if 'edges' is an Array ]]
	end) --[[ ROBLOX CHECK: check if 'sides' is an Array ]]
	return create(edges)
end
return fromSides
