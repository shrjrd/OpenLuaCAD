-- ROBLOX NOTE: no upstream
local Packages = game.ReplicatedStorage.Packages
local LuauPolyfill = require(Packages.LuauPolyfill)
local Array = LuauPolyfill.Array
local Boolean = LuauPolyfill.Boolean
local mat4 = require("../../maths/mat4")
local vec2 = require("../../maths/vec2")
--[[
 * Apply the transforms of the given geometry.
 * NOTE: This function must be called BEFORE exposing any data. See toPoints.
 * @param {path} geometry - the geometry to transform
 * @returns {path} the given geometry
 * @example
 * geometry = applyTransforms(geometry)
 ]]
local function applyTransforms(geometry)
	if Boolean.toJSBoolean(mat4.isIdentity(geometry.transforms)) then
		return geometry
	end
	geometry.points = Array.map(geometry.points, function(point)
		return vec2.transform(vec2.create(), point, geometry.transforms)
	end) --[[ ROBLOX CHECK: check if 'geometry.points' is an Array ]]
	geometry.transforms = mat4.create()
	return geometry
end
return applyTransforms
