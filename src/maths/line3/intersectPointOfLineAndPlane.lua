-- ROBLOX NOTE: no upstream
local vec3 = require("../vec3")
--[[*
 * Determine the closest point on the given plane to the given line.
 *
 * NOTES:
 * The point of intersection will be invalid if the line is parallel to the plane, e.g. NaN.
 *
 * @param {line3} line - line of reference
 * @param {plane} plane - plane of reference
 * @returns {vec3} a point on the line
 * @alias module:modeling/maths/line3.intersectPointOfLineAndPlane
 ]]
local function intersectToPlane(line, plane)
	-- plane. plane.normal * p = plane.w
	local pnormal = plane
	local pw = plane[
		4 --[[ ROBLOX adaptation: added 1 to array index ]]
	]
	local lpoint = line[
		1 --[[ ROBLOX adaptation: added 1 to array index ]]
	]
	local ldirection = line[
		2 --[[ ROBLOX adaptation: added 1 to array index ]]
	] -- point: p = line.point + labda * line.direction
	local labda = (pw - vec3.dot(pnormal, lpoint)) / vec3.dot(pnormal, ldirection)
	local point = vec3.add(vec3.create(), lpoint, vec3.scale(vec3.create(), ldirection, labda))
	return point
end
return intersectToPlane
