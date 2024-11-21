-- ROBLOX NOTE: no upstream
local Packages = game.ReplicatedStorage.Packages
local LuauPolyfill = require(Packages.LuauPolyfill)
local Array = LuauPolyfill.Array
local Boolean = LuauPolyfill.Boolean
local mat4 = require("../../maths/mat4")
local vec2 = require("../../maths/vec2")
--[[
 * Apply the transforms of the given geometry.
 * NOTE: This function must be called BEFORE exposing any data. See toSides().
 * @param {geom2} geometry - the geometry to transform
 * @returns {geom2} the given geometry
 *
 * @example
 * geometry = applyTransforms(geometry)
 ]]
local function applyTransforms(geometry)
	if Boolean.toJSBoolean(mat4.isIdentity(geometry.transforms)) then
		return geometry
	end -- apply transforms to each side
	geometry.sides = Array.map(geometry.sides, function(side)
		local p0 = vec2.transform(
			vec2.create(),
			side[
				1 --[[ ROBLOX adaptation: added 1 to array index ]]
			],
			geometry.transforms
		)
		local p1 = vec2.transform(
			vec2.create(),
			side[
				2 --[[ ROBLOX adaptation: added 1 to array index ]]
			],
			geometry.transforms
		)
		return { p0, p1 }
	end) --[[ ROBLOX CHECK: check if 'geometry.sides' is an Array ]]
	geometry.transforms = mat4.create()
	return geometry
end
return applyTransforms
