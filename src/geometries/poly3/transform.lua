-- ROBLOX NOTE: no upstream
local Packages = game.ReplicatedStorage.Packages
local LuauPolyfill = require(Packages.LuauPolyfill)
local Array = LuauPolyfill.Array
local Boolean = LuauPolyfill.Boolean
local mat4 = require("../../maths/mat4")
local vec3 = require("../../maths/vec3")
local create = require("./create")
--[[*
 * Transform the given polygon using the given matrix.
 * @param {mat4} matrix - the matrix to transform with
 * @param {poly3} polygon - the polygon to transform
 * @returns {poly3} a new polygon
 * @alias module:modeling/geometries/poly3.transform
 ]]
local function transform(matrix, polygon)
	local vertices = Array.map(polygon.vertices, function(vertex)
		return vec3.transform(vec3.create(), vertex, matrix)
	end) --[[ ROBLOX CHECK: check if 'polygon.vertices' is an Array ]]
	if Boolean.toJSBoolean(mat4.isMirroring(matrix)) then
		-- reverse the order to preserve the orientation
		Array.reverse(vertices) --[[ ROBLOX CHECK: check if 'vertices' is an Array ]]
	end
	return create(vertices)
end
return transform
