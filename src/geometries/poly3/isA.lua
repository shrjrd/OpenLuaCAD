-- ROBLOX NOTE: no upstream
local Packages = game.ReplicatedStorage.Packages
local LuauPolyfill = require(Packages.LuauPolyfill)
local Array = LuauPolyfill.Array
local Boolean = LuauPolyfill.Boolean
local Object = LuauPolyfill.Object
--[[*
 * Determine if the given object is a polygon.
 * @param {Object} object - the object to interrogate
 * @returns {Boolean} true if the object matches a poly3
 * @alias module:modeling/geometries/poly3.isA
 ]]
local function isA(object)
	if Boolean.toJSBoolean(if Boolean.toJSBoolean(object) then typeof(object) == "table" else object) then
		if Array.indexOf(Object.keys(object), "vertices") ~= -1 then
			if Boolean.toJSBoolean(Array.isArray(object.vertices)) then
				return true
			end
		end
	end
	return false
end
return isA
