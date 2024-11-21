-- ROBLOX NOTE: no upstream
local Packages = game.ReplicatedStorage.Packages
local LuauPolyfill = require(Packages.LuauPolyfill)
local Array = LuauPolyfill.Array
local Boolean = LuauPolyfill.Boolean
local Error = LuauPolyfill.Error
local Number = LuauPolyfill.Number
local vec2 = require("../../maths/vec2")
local isA = require("./isA")
local toOutlines = require("./toOutlines")
--[[*
 * Determine if the given object is a valid geom2.
 * Checks for closedness, self-edges, and valid data points.
 *
 * **If the geometry is not valid, an exception will be thrown with details of the geometry error.**
 *
 * @param {Object} object - the object to interrogate
 * @throws {Error} error if the geometry is not valid
 * @alias module:modeling/geometries/geom2.validate
 ]]
local function validate(object)
	if not Boolean.toJSBoolean(isA(object)) then
		error(Error.new("invalid geom2 structure"))
	end -- check for closedness
	toOutlines(object) -- check for self-edges
	Array.forEach(object.sides, function(side)
		if
			Boolean.toJSBoolean(vec2.equals(
				side[
					1 --[[ ROBLOX adaptation: added 1 to array index ]]
				],
				side[
					2 --[[ ROBLOX adaptation: added 1 to array index ]]
				]
			))
		then
			error(Error.new(("geom2 self-edge %s"):format(tostring(side[
				1 --[[ ROBLOX adaptation: added 1 to array index ]]
			]))))
		end
	end) --[[ ROBLOX CHECK: check if 'object.sides' is an Array ]] -- check transforms
	if
		not Boolean.toJSBoolean(
			Array.every(object.transforms, Number.isFinite) --[[ ROBLOX CHECK: check if 'object.transforms' is an Array ]]
		)
	then
		error(Error.new(("geom2 invalid transforms %s"):format(tostring(object.transforms))))
	end
end
return validate
