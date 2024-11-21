-- ROBLOX NOTE: no upstream
local vec3 = require("../../maths/vec3")
--[[*
 * Measure the signed volume of the given polygon, which must be convex.
 * The volume is that formed by the tetrahedron connected to the axis [0,0,0],
 * and will be positive or negative based on the rotation of the vertices.
 * @see http://chenlab.ece.cornell.edu/Publication/Cha/icip01_Cha.pdf
 * @param {poly3} polygon - the polygon to measure
 * @return {Number} volume of the polygon
 * @alias module:modeling/geometries/poly3.measureSignedVolume
 ]]
local function measureSignedVolume(polygon)
	local signedVolume = 0
	local vertices = polygon.vertices -- calculate based on triangular polygons
	local cross = vec3.create()
	do
		local i = 0
		while
			i
			< #vertices - 2 --[[ ROBLOX CHECK: operator '<' works only if either both arguments are strings or both are a number ]]
		do
			vec3.cross(cross, vertices[(i + 1)], vertices[(i + 2)])
			signedVolume += vec3.dot(
				vertices[
					1 --[[ ROBLOX adaptation: added 1 to array index ]]
				],
				cross
			)
			i += 1
		end
	end
	signedVolume /= 6
	return signedVolume
end
return measureSignedVolume
