-- ROBLOX NOTE: no upstream
local EPS = require("../constants").EPS
local vec3 = require("../vec3")
--[[*
 * Create a new plane from the given points like fromPoints,
 * but allow the vectors to be on one point or one line.
 * In such a case, a random plane through the given points is constructed.
 *
 * @param {plane} out - receiving plane
 * @param {vec3} a - 3D point
 * @param {vec3} b - 3D point
 * @param {vec3} c - 3D point
 * @returns {plane} out
 * @alias module:modeling/maths/plane.fromPointsRandom
 ]]
local function fromPointsRandom(out, a, b, c)
	local ba = vec3.subtract(vec3.create(), b, a)
	local ca = vec3.subtract(vec3.create(), c, a)
	if
		vec3.length(ba)
		< EPS --[[ ROBLOX CHECK: operator '<' works only if either both arguments are strings or both are a number ]]
	then
		ba = vec3.orthogonal(ba, ca)
	end
	if
		vec3.length(ca)
		< EPS --[[ ROBLOX CHECK: operator '<' works only if either both arguments are strings or both are a number ]]
	then
		ca = vec3.orthogonal(ca, ba)
	end
	local normal = vec3.cross(vec3.create(), ba, ca)
	if
		vec3.length(normal)
		< EPS --[[ ROBLOX CHECK: operator '<' works only if either both arguments are strings or both are a number ]]
	then
		-- this would mean that ba == ca.negated()
		ca = vec3.orthogonal(ca, ba)
		normal = vec3.cross(normal, ba, ca)
	end
	normal = vec3.normalize(normal, normal)
	local w = vec3.dot(normal, a)
	out[
		1 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = normal[
		1 --[[ ROBLOX adaptation: added 1 to array index ]]
	]
	out[
		2 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = normal[
		2 --[[ ROBLOX adaptation: added 1 to array index ]]
	]
	out[
		3 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = normal[
		3 --[[ ROBLOX adaptation: added 1 to array index ]]
	]
	out[
		4 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = w
	return out
end
return fromPointsRandom
