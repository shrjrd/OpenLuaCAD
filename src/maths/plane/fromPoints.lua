-- ROBLOX NOTE: no upstream
local Packages = game.ReplicatedStorage.Packages
local LuauPolyfill = require(Packages.LuauPolyfill)
local Array = LuauPolyfill.Array
local vec3 = require("../vec3")
--[[*
 * Create a plane from the given points.
 *
 * @param {plane} out - receiving plane
 * @param {Array} vertices - points on the plane
 * @returns {plane} out
 * @alias module:modeling/maths/plane.fromPoints
 ]]
local function fromPoints(
	out,
	...: any --[[ ROBLOX CHECK: check correct type of elements. ]]
)
	local vertices = { ... }
	local len = #vertices -- Calculate normal vector for a single vertex
	-- Inline to avoid allocations
	local ba = vec3.create()
	local ca = vec3.create()
	local function vertexNormal(index)
		local a = vertices[index]
		local b = vertices[((index + 1) % len)]
		local c = vertices[((index + 2) % len)]
		vec3.subtract(ba, b, a) -- ba = b - a
		vec3.subtract(ca, c, a) -- ca = c - a
		vec3.cross(ba, ba, ca) -- ba = ba x ca
		vec3.normalize(ba, ba)
		return ba
	end
	out[
		1 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = 0
	out[
		2 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = 0
	out[
		3 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = 0
	if len == 3 then
		-- optimization for triangles, which are always coplanar
		vec3.copy(out, vertexNormal(0))
	else
		-- sum of vertex normals
		Array.forEach(vertices, function(v, i)
			vec3.add(out, out, vertexNormal(i))
		end) --[[ ROBLOX CHECK: check if 'vertices' is an Array ]] -- renormalize normal vector
		vec3.normalize(out, out)
	end
	out[
		4 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = vec3.dot(
		out,
		vertices[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		]
	)
	return out
end
return fromPoints
