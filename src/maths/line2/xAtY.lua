-- ROBLOX NOTE: no upstream
local Packages = game.ReplicatedStorage.Packages
local LuauPolyfill = require(Packages.LuauPolyfill)
local Boolean = LuauPolyfill.Boolean
local Number = LuauPolyfill.Number
local origin = require("./origin")
--[[*
 * Determine the X coordinate of the given line at the Y coordinate.
 *
 * The X coordinate will be Infinity if the line is parallel to the X axis.
 *
 * @param {line2} line - line of reference
 * @param {Number} y - Y coordinate on the line
 * @return {Number} the X coordinate on the line
 * @alias module:modeling/maths/line2.xAtY
 ]]
local function xAtY(line, y)
	local x = (
		line[
			3 --[[ ROBLOX adaptation: added 1 to array index ]]
		] - line[
			2 --[[ ROBLOX adaptation: added 1 to array index ]]
		] * y
	) / line[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		]
	if Boolean.toJSBoolean(Number.isNaN(x)) then
		local org = origin(line)
		x = org[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		]
	end
	return x
end
return xAtY
