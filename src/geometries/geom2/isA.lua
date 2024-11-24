-- ROBLOX NOTE: no upstream

local LuauPolyfill = require("@Packages/LuauPolyfill")
local Array = LuauPolyfill.Array
local Boolean = LuauPolyfill.Boolean
local Object = LuauPolyfill.Object
--[[*
 * Determine if the given object is a 2D geometry.
 * @param {Object} object - the object to interrogate
 * @returns {Boolean} true, if the object matches a geom2 based object
 * @alias module:modeling/geometries/geom2.isA
 ]]
local function isA(object)
	if Boolean.toJSBoolean(if Boolean.toJSBoolean(object) then typeof(object) == "table" else object) then
		if
			Array.indexOf(Object.keys(object), "sides") ~= -1
			and Array.indexOf(Object.keys(object), "transforms") ~= -1
		then
			if
				Boolean.toJSBoolean((function()
					local ref = Array.isArray(object.sides)
					return if Boolean.toJSBoolean(ref)
						then Array.indexOf(Object.keys(object.transforms), "length") ~= -1
						else ref
				end)())
			then
				return true
			end
		end
	end
	return false
end
return isA
