-- ROBLOX NOTE: no upstream
local Packages = game.ReplicatedStorage.Packages
local LuauPolyfill = require(Packages.LuauPolyfill)
local Array = LuauPolyfill.Array
local vec3 = require("../../../maths/vec3")
local create = require("./create")
--[[*
 * Transform the given slice using the given matrix.
 * @param {mat4} matrix - transform matrix
 * @param {slice} slice - slice to transform
 * @returns {slice} the transformed slice
 * @alias module:modeling/extrusions/slice.transform
 *
 * @example
 * let matrix = mat4.fromTranslation([1, 2, 3])
 * let newslice = transform(matrix, oldslice)
 ]]
local function transform(matrix, slice)
	local edges = Array.map(slice.edges, function(edge)
		return {
			vec3.transform(
				vec3.create(),
				edge[
					1 --[[ ROBLOX adaptation: added 1 to array index ]]
				],
				matrix
			),
			vec3.transform(
				vec3.create(),
				edge[
					2 --[[ ROBLOX adaptation: added 1 to array index ]]
				],
				matrix
			),
		}
	end) --[[ ROBLOX CHECK: check if 'slice.edges' is an Array ]]
	return create(edges)
end
return transform
