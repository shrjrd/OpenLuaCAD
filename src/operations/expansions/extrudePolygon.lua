-- ROBLOX NOTE: no upstream
local mat4 = require("../../maths/mat4")
local vec3 = require("../../maths/vec3")
local geom3 = require("../../geometries/geom3")
local poly3 = require("../../geometries/poly3") -- Extrude a polygon in the direction of the offsetvector.
-- Returns (geom3) a new geometry
local function extrudePolygon(offsetvector, polygon1)
	local direction = vec3.dot(poly3.plane(polygon1), offsetvector)
	if
		direction
		> 0 --[[ ROBLOX CHECK: operator '>' works only if either both arguments are strings or both are a number ]]
	then
		polygon1 = poly3.invert(polygon1)
	end
	local newpolygons = { polygon1 }
	local polygon2 = poly3.transform(mat4.fromTranslation(mat4.create(), offsetvector), polygon1)
	local numvertices = #polygon1.vertices
	do
		local i = 0
		while
			i
			< numvertices --[[ ROBLOX CHECK: operator '<' works only if either both arguments are strings or both are a number ]]
		do
			local nexti = if i
					< numvertices - 1 --[[ ROBLOX CHECK: operator '<' works only if either both arguments are strings or both are a number ]]
				then i + 1
				else 0
			local sideFacePolygon = poly3.create({
				polygon1.vertices[i],
				polygon2.vertices[i],
				polygon2.vertices[nexti],
				polygon1.vertices[nexti],
			})
			table.insert(newpolygons, sideFacePolygon) --[[ ROBLOX CHECK: check if 'newpolygons' is an Array ]]
			i += 1
		end
	end
	table.insert(newpolygons, poly3.invert(polygon2)) --[[ ROBLOX CHECK: check if 'newpolygons' is an Array ]]
	return geom3.create(newpolygons)
end
return extrudePolygon
