-- ROBLOX NOTE: no upstream
local Packages = game.ReplicatedStorage.Packages
local LuauPolyfill = require(Packages.LuauPolyfill)
local Array = LuauPolyfill.Array
local Boolean = LuauPolyfill.Boolean
local Object = LuauPolyfill.Object
--[[*
 * Determine if the given object is a path2 geometry.
 * @param {Object} object - the object to interrogate
 * @returns {Boolean} true if the object matches a path2
 * @alias module:modeling/geometries/path2.isA
 ]]
local function isA(object)
	if Boolean.toJSBoolean(if Boolean.toJSBoolean(object) then typeof(object) == "table" else object) then
		-- see create for the required attributes and types
		if
			Array.indexOf(Object.keys(object), "points") ~= -1
			and Array.indexOf(Object.keys(object), "transforms") ~= -1
			and Array.indexOf(Object.keys(object), "isClosed") ~= -1
		then
			-- NOTE: transforms should be a TypedArray, which has a read-only length
			if
				Boolean.toJSBoolean((function()
					local ref = Array.isArray(object.points)
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
