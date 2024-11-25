-- ROBLOX NOTE: no upstream

local LuauPolyfill = require("@Packages/LuauPolyfill")
local Array = LuauPolyfill.Array
local vec3 = require("../vec3")
local fromNormalAndPoint = require("./fromNormalAndPoint")
--[[*
 * Create a best-fit plane from the given noisy vertices.
 *
 * NOTE: There are two possible orientations for every plane.
 *       This function always produces positive orientations.
 *
 * See http://www.ilikebigbits.com for the original discussion
 *
 * @param {Plane} out - receiving plane
 * @param {Array} vertices - list of vertices in any order or position
 * @returns {Plane} out
 * @alias module:modeling/maths/plane.fromNoisyPoints
 ]]
local function fromNoisyPoints(
	out,
	...: any --[[ ROBLOX CHECK: check correct type of elements. ]]
)
	local vertices = { ... }
	out[
		1 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = 0.0
	out[
		2 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = 0.0
	out[
		3 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = 0.0
	out[
		4 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = 0.0 -- calculate the centroid of the vertices
	-- NOTE: out is the centriod
	local n = #vertices
	Array.forEach(vertices, function(v)
		vec3.add(out, out, v)
	end) --[[ ROBLOX CHECK: check if 'vertices' is an Array ]]
	vec3.scale(out, out, 1.0 / n) -- Calculate full 3x3 covariance matrix, excluding symmetries
	local xx = 0.0
	local xy = 0.0
	local xz = 0.0
	local yy = 0.0
	local yz = 0.0
	local zz = 0.0
	local vn = vec3.create()
	Array.forEach(vertices, function(v)
		-- NOTE: out is the centriod
		vec3.subtract(vn, v, out)
		xx += vn[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		] * vn[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		]
		xy += vn[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		] * vn[
			2 --[[ ROBLOX adaptation: added 1 to array index ]]
		]
		xz += vn[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		] * vn[
			3 --[[ ROBLOX adaptation: added 1 to array index ]]
		]
		yy += vn[
			2 --[[ ROBLOX adaptation: added 1 to array index ]]
		] * vn[
			2 --[[ ROBLOX adaptation: added 1 to array index ]]
		]
		yz += vn[
			2 --[[ ROBLOX adaptation: added 1 to array index ]]
		] * vn[
			3 --[[ ROBLOX adaptation: added 1 to array index ]]
		]
		zz += vn[
			3 --[[ ROBLOX adaptation: added 1 to array index ]]
		] * vn[
			3 --[[ ROBLOX adaptation: added 1 to array index ]]
		]
	end) --[[ ROBLOX CHECK: check if 'vertices' is an Array ]]
	xx /= n
	xy /= n
	xz /= n
	yy /= n
	yz /= n
	zz /= n -- Calculate the smallest Eigenvector of the covariance matrix
	-- which becomes the plane normal
	vn[
		1 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = 0.0
	vn[
		2 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = 0.0
	vn[
		3 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = 0.0 -- weighted directional vector
	local wdv = vec3.create() -- X axis
	local det = yy * zz - yz * yz
	wdv[
		1 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = det
	wdv[
		2 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = xz * yz - xy * zz
	wdv[
		3 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = xy * yz - xz * yy
	local weight = det * det
	vec3.add(vn, vn, vec3.scale(wdv, wdv, weight)) -- Y axis
	det = xx * zz - xz * xz
	wdv[
		1 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = xz * yz - xy * zz
	wdv[
		2 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = det
	wdv[
		3 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = xy * xz - yz * xx
	weight = det * det
	if
		vec3.dot(vn, wdv)
		< 0.0 --[[ ROBLOX CHECK: operator '<' works only if either both arguments are strings or both are a number ]]
	then
		weight = -weight
	end
	vec3.add(vn, vn, vec3.scale(wdv, wdv, weight)) -- Z axis
	det = xx * yy - xy * xy
	wdv[
		1 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = xy * yz - xz * yy
	wdv[
		2 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = xy * xz - yz * xx
	wdv[
		3 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = det
	weight = det * det
	if
		vec3.dot(vn, wdv)
		< 0.0 --[[ ROBLOX CHECK: operator '<' works only if either both arguments are strings or both are a number ]]
	then
		weight = -weight
	end
	vec3.add(vn, vn, vec3.scale(wdv, wdv, weight)) -- create the plane from normal and centriod
	-- NOTE: out is the centriod
	return fromNormalAndPoint(out, vn, out)
end
return fromNoisyPoints
