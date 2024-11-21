-- ROBLOX NOTE: no upstream
local Packages = game.ReplicatedStorage.Packages
local LuauPolyfill = require(Packages.LuauPolyfill)
local Array = LuauPolyfill.Array
local Boolean = LuauPolyfill.Boolean
local mat4 = require("../../maths/mat4")
local poly3 = require("../poly3")
--[[
 * Apply the transforms of the given geometry.
 * NOTE: This function must be called BEFORE exposing any data. See toPolygons.
 * @param {geom3} geometry - the geometry to transform
 * @returns {geom3} the given geometry
 * @example
 * geometry = applyTransforms(geometry)
 ]]
local function applyTransforms(geometry)
	if Boolean.toJSBoolean(mat4.isIdentity(geometry.transforms)) then
		return geometry
	end -- apply transforms to each polygon
	geometry.polygons = Array.map(geometry.polygons, function(polygon)
		return poly3.transform(geometry.transforms, polygon)
	end) --[[ ROBLOX CHECK: check if 'geometry.polygons' is an Array ]] -- reset transforms
	geometry.transforms = mat4.create()
	return geometry
end
return applyTransforms
