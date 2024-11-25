-- ROBLOX NOTE: no upstream

local LuauPolyfill = require("@Packages/LuauPolyfill")
local Boolean = LuauPolyfill.Boolean
local dot = require("./dot")
--[[*
 * Calculate the angle between two vectors.
 *
 * @param {vec3} a - first operand
 * @param {vec3} b - second operand
 * @returns {Number} angle (radians)
 * @alias module:modeling/maths/vec3.angle
 ]]
local function angle(a, b)
	local ax = a[
		1 --[[ ROBLOX adaptation: added 1 to array index ]]
	]
	local ay = a[
		2 --[[ ROBLOX adaptation: added 1 to array index ]]
	]
	local az = a[
		3 --[[ ROBLOX adaptation: added 1 to array index ]]
	]
	local bx = b[
		1 --[[ ROBLOX adaptation: added 1 to array index ]]
	]
	local by = b[
		2 --[[ ROBLOX adaptation: added 1 to array index ]]
	]
	local bz = b[
		3 --[[ ROBLOX adaptation: added 1 to array index ]]
	]
	local mag1 = math.sqrt(ax * ax + ay * ay + az * az)
	local mag2 = math.sqrt(bx * bx + by * by + bz * bz)
	local mag = mag1 * mag2
	local cosine = if Boolean.toJSBoolean(mag) then dot(a, b) / mag else mag
	return math.acos(math.min(math.max(cosine, -1), 1))
end
return angle
