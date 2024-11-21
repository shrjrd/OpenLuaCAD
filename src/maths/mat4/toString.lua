-- ROBLOX NOTE: no upstream
local Packages = game.ReplicatedStorage.Packages
local LuauPolyfill = require(Packages.LuauPolyfill)
local Array = LuauPolyfill.Array
--[[*
 * Return a string representing the given matrix.
 *
 * @param {mat4} mat - matrix of reference
 * @returns {String} string representation
 * @alias module:modeling/maths/mat4.toString
 ]]
local function toString(mat)
	return tostring(Array.map(mat, function(n)
		return n:toFixed(7)
	end) --[[ ROBLOX CHECK: check if 'mat' is an Array ]])
end
return toString
