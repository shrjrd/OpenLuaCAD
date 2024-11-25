-- ROBLOX NOTE: no upstream

local LuauPolyfill = require("@Packages/LuauPolyfill")
local Boolean = LuauPolyfill.Boolean
local mat4 = require("../mat4")
local vec3 = require("../vec3")
local fromPoints = require("./fromPoints")
local flip = require("./flip")
--[[*
 * Transform the given plane using the given matrix
 *
 * @param {plane} out - receiving plane
 * @param {plane} plane - plane to transform
 * @param {mat4} matrix - matrix to transform with
 * @return {plane} out
 * @alias module:modeling/maths/plane.transform
 ]]
local function transform(out, plane, matrix)
	local ismirror = mat4.isMirroring(matrix) -- get two vectors in the plane.
	local r = vec3.orthogonal(vec3.create(), plane)
	local u = vec3.cross(r, plane, r)
	local v = vec3.cross(vec3.create(), plane, u) -- get 3 points in the plane.
	local point1 = vec3.fromScalar(
		vec3.create(),
		plane[
			4 --[[ ROBLOX adaptation: added 1 to array index ]]
		]
	)
	vec3.multiply(point1, point1, plane)
	local point2 = vec3.add(vec3.create(), point1, u)
	local point3 = vec3.add(vec3.create(), point1, v) -- transform the points:
	point1 = vec3.transform(point1, point1, matrix)
	point2 = vec3.transform(point2, point2, matrix)
	point3 = vec3.transform(point3, point3, matrix) -- and create a new plane from the transformed points:
	fromPoints(out, point1, point2, point3)
	if Boolean.toJSBoolean(ismirror) then
		-- the transform is mirroring so flip the plane
		flip(out, out)
	end
	return out
end
return transform
