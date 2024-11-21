-- ROBLOX NOTE: no upstream
local Packages = game.ReplicatedStorage.Packages
local LuauPolyfill = require(Packages.LuauPolyfill)
local Array = LuauPolyfill.Array
local Boolean = LuauPolyfill.Boolean
local compareVectors = require("./compareVectors")
--[[*
 * Compare two list of points for equality
 * @param {Array} list1 - list of points
 * @param {Array} list2 - list of points
 * @returns {boolean} result of comparison
 ]]
local function comparePoints(list1, list2)
	if #list1 == #list2 then
		return Array.reduce(list1, function(valid, point, index)
			return if Boolean.toJSBoolean(valid) then compareVectors(list1[index], list2[index]) else valid
		end, true) --[[ ROBLOX CHECK: check if 'list1' is an Array ]]
	end
	return false
end
return comparePoints
