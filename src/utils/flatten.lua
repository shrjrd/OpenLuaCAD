-- ROBLOX NOTE: no upstream
local Packages = game.ReplicatedStorage.Packages
local LuauPolyfill = require(Packages.LuauPolyfill)
local Array = LuauPolyfill.Array
local Boolean = LuauPolyfill.Boolean
--[[*
 * Flatten the given list of arguments into a single flat array.
 * The arguments can be composed of multiple depths of objects and arrays.
 * @param {Array} arr - list of arguments
 * @returns {Array} a flat list of arguments
 * @alias module:modeling/utils.flatten
 ]]
local function flatten(arr)
	return Array.reduce(arr, function(acc, val)
		return if Boolean.toJSBoolean(Array.isArray(val))
			then Array.concat(acc, flatten(val)) --[[ ROBLOX CHECK: check if 'acc' is an Array ]]
			else Array.concat(acc, val) --[[ ROBLOX CHECK: check if 'acc' is an Array ]]
	end, {}) --[[ ROBLOX CHECK: check if 'arr' is an Array ]]
end
return flatten
