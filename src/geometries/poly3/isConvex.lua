-- ROBLOX NOTE: no upstream

local LuauPolyfill = require("@Packages/LuauPolyfill")
local Array = LuauPolyfill.Array
local Boolean = LuauPolyfill.Boolean
local plane = require("../../maths/plane")
local vec3 = require("../../maths/vec3")
-- calculate whether three points form a convex corner
--  prevpoint, point, nextpoint: the 3 coordinates (Vector3D instances)
--  normal: the normal vector of the plane
local function isConvexPoint(prevpoint, point, nextpoint, normal)
	local crossproduct = vec3.cross(
		vec3.create(),
		vec3.subtract(vec3.create(), point, prevpoint),
		vec3.subtract(vec3.create(), nextpoint, point)
	)
	local crossdotnormal = vec3.dot(crossproduct, normal)
	return crossdotnormal >= 0 --[[ ROBLOX CHECK: operator '>=' works only if either both arguments are strings or both are a number ]]
end
local function areVerticesConvex(vertices)
	local numvertices = #vertices
	if
		numvertices
		> 2 --[[ ROBLOX CHECK: operator '>' works only if either both arguments are strings or both are a number ]]
	then
		-- note: plane ~= normal point
		local normal = plane.fromPoints(plane.create(), table.unpack(Array.spread(vertices)))
		local prevprevpos = vertices[(numvertices - 2)]
		local prevpos = vertices[(numvertices - 1)]
		do
			local i = 0
			while
				i
				< numvertices --[[ ROBLOX CHECK: operator '<' works only if either both arguments are strings or both are a number ]]
			do
				local pos = vertices[i]
				if not Boolean.toJSBoolean(isConvexPoint(prevprevpos, prevpos, pos, normal)) then
					return false
				end
				prevprevpos = prevpos
				prevpos = pos
				i += 1
			end
		end
	end
	return true
end
--[[*
 * Check whether the given polygon is convex.
 * @param {poly3} polygon - the polygon to interrogate
 * @returns {Boolean} true if convex
 * @alias module:modeling/geometries/poly3.isConvex
 ]]
local function isConvex(polygon)
	return areVerticesConvex(polygon.vertices)
end
return isConvex
