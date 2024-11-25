-- ROBLOX NOTE: no upstream

local LuauPolyfill = require("@Packages/LuauPolyfill")
local Object = LuauPolyfill.Object
local mat4 = require("../../maths/mat4")
local reverse = require("./reverse")
--[[*
 * Transform the given geometry using the given matrix.
 * This is a lazy transform of the sides, as this function only adjusts the transforms.
 * The transforms are applied when accessing the sides via toSides().
 * @param {mat4} matrix - the matrix to transform with
 * @param {geom2} geometry - the geometry to transform
 * @returns {geom2} a new geometry
 * @alias module:modeling/geometries/geom2.transform
 *
 * @example
 * let newgeometry = transform(fromZRotation(degToRad(90)), geometry)
 ]]
local function transform(matrix, geometry)
	local transforms = mat4.multiply(mat4.create(), matrix, geometry.transforms)
	local transformed = Object.assign({}, geometry, { transforms = transforms }) -- determine if the transform is mirroring in 2D
	if
		matrix[
					1 --[[ ROBLOX adaptation: added 1 to array index ]]
				]
				* matrix[
					6 --[[ ROBLOX adaptation: added 1 to array index ]]
				]
			- matrix[
					5 --[[ ROBLOX adaptation: added 1 to array index ]]
				]
				* matrix[
					2 --[[ ROBLOX adaptation: added 1 to array index ]]
				]
		< 0 --[[ ROBLOX CHECK: operator '<' works only if either both arguments are strings or both are a number ]]
	then
		-- reverse the order to preserve the orientation
		return reverse(transformed)
	end
	return transformed
end
return transform
