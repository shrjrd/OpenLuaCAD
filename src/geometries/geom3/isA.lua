-- ROBLOX NOTE: no upstream
local Packages = game.ReplicatedStorage.Packages
local LuauPolyfill = require(Packages.LuauPolyfill)
local Array = LuauPolyfill.Array
local Boolean = LuauPolyfill.Boolean
local Object = LuauPolyfill.Object
--[[*
 * Determine if the given object is a 3D geometry.
 * @param {Object} object - the object to interrogate
 * @returns {Boolean} true if the object matches a geom3
 * @alias module:modeling/geometries/geom3.isA
 ]]
local function isA(object)
	if Boolean.toJSBoolean(if Boolean.toJSBoolean(object) then typeof(object) == "table" else object) then
		if
			Array.indexOf(Object.keys(object), "polygons") ~= -1
			and Array.indexOf(Object.keys(object), "transforms") ~= -1
		then
			if
				Boolean.toJSBoolean((function()
					local ref = Array.isArray(object.polygons)
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
