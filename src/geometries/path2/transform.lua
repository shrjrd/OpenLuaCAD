-- ROBLOX NOTE: no upstream
local Packages = game.ReplicatedStorage.Packages
local LuauPolyfill = require(Packages.LuauPolyfill)
local Object = LuauPolyfill.Object
local mat4 = require("../../maths/mat4")
--[[*
 * Transform the given geometry using the given matrix.
 * This is a lazy transform of the points, as this function only adjusts the transforms.
 * The transforms are applied when accessing the points via toPoints().
 * @param {mat4} matrix - the matrix to transform with
 * @param {path2} geometry - the geometry to transform
 * @returns {path2} a new path
 * @alias module:modeling/geometries/path2.transform
 *
 * @example
 * let newpath = transform(fromZRotation(TAU / 8), path)
 ]]
local function transform(matrix, geometry)
	local transforms = mat4.multiply(mat4.create(), matrix, geometry.transforms)
	return Object.assign({}, geometry, { transforms = transforms })
end
return transform
