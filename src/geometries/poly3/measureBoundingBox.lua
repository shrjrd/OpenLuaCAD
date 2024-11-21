-- ROBLOX NOTE: no upstream
local vec3 = require("../../maths/vec3")
--[[*
 * @param {poly3} polygon - the polygon to measure
 * @returns {Array} an array of two vectors (3D);  minimum and maximum coordinates
 * @alias module:modeling/geometries/poly3.measureBoundingBox
 ]]
local function measureBoundingBox(polygon)
	local vertices = polygon.vertices
	local numvertices = #vertices
	local min = if numvertices == 0
		then vec3.create()
		else vec3.clone(vertices[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		])
	local max = vec3.clone(min)
	do
		local i = 1
		while
			i
			< numvertices --[[ ROBLOX CHECK: operator '<' works only if either both arguments are strings or both are a number ]]
		do
			vec3.min(min, min, vertices[i])
			vec3.max(max, max, vertices[i])
			i += 1
		end
	end
	return { min, max }
end
return measureBoundingBox
