-- ROBLOX NOTE: no upstream
local JestGlobals = require("@DevPackages/JestGlobals")
local test, expect = JestGlobals.test, JestGlobals.expect

local mat4 = require("../../maths/mat4")
local poly3 = require("../../geometries").poly3
local reTesselateCoplanarPolygons = require("./reTesselateCoplanarPolygons")
local function translatePoly3(offsets, polygon)
	local matrix = mat4.fromTranslation(mat4.create(), offsets)
	return poly3.transform(matrix, polygon)
end
local function rotatePoly3(angles, polygon)
	local matrix = mat4.fromTaitBryanRotation(mat4.create(), angles[
		1 --[[ ROBLOX adaptation: added 1 to array index ]]
	] * 0.017453292519943295, angles[
		2 --[[ ROBLOX adaptation: added 1 to array index ]]
	] * 0.017453292519943295, angles[
		3 --[[ ROBLOX adaptation: added 1 to array index ]]
	] * 0.017453292519943295)
	return poly3.transform(matrix, polygon)
end
test:only("retessellateCoplanarPolygons: should merge coplanar polygons", function()
	local polyA = poly3.create({ { -5, -5, 0 }, { 5, -5, 0 }, { 5, 5, 0 }, { -5, 5, 0 } })
	local polyB = poly3.create({ { 5, -5, 0 }, { 8, 0, 0 }, { 5, 5, 0 } })
	local polyC = poly3.create({ { -5, 5, 0 }, { -8, 0, 0 }, { -5, -5, 0 } })
	local polyD = poly3.create({ { -5, 5, 0 }, { 5, 5, 0 }, { 0, 8, 0 } })
	local polyE = poly3.create({ { 5, -5, 0 }, { -5, -5, 0 }, { 0, -8, 0 } }) -- combine polygons in each direction
	local obs = reTesselateCoplanarPolygons({ polyA, polyB })
	expect(#obs).toBe(1)
	obs = reTesselateCoplanarPolygons({ polyA, polyC })
	expect(#obs).toBe(1)
	obs = reTesselateCoplanarPolygons({ polyA, polyD })
	expect(#obs).toBe(1)
	obs = reTesselateCoplanarPolygons({ polyA, polyE })
	expect(#obs).toBe(1) -- combine several polygons in each direction
	obs = reTesselateCoplanarPolygons({ polyB, polyA, polyC })
	expect(#obs).toBe(1)
	obs = reTesselateCoplanarPolygons({ polyC, polyA, polyB })
	expect(#obs).toBe(1)
	obs = reTesselateCoplanarPolygons({ polyD, polyA, polyE })
	expect(#obs).toBe(1)
	obs = reTesselateCoplanarPolygons({ polyE, polyA, polyD })
	expect(#obs).toBe(1) -- combine all polygons
	obs = reTesselateCoplanarPolygons({ polyA, polyB, polyC, polyD, polyE })
	expect(#obs).toBe(1) -- now rotate everything and do again
	local polyH = rotatePoly3({ -45, -45, -45 }, polyA)
	local polyI = rotatePoly3({ -45, -45, -45 }, polyB)
	local polyJ = rotatePoly3({ -45, -45, -45 }, polyC)
	local polyK = rotatePoly3({ -45, -45, -45 }, polyD)
	local polyL = rotatePoly3({ -45, -45, -45 }, polyE)
	obs = reTesselateCoplanarPolygons({ polyH, polyI, polyJ, polyK, polyL })
	expect(#obs).toBe(1) -- now translate everything and do again
	polyH = translatePoly3({ -15, -15, -15 }, polyA)
	polyI = translatePoly3({ -15, -15, -15 }, polyB)
	polyJ = translatePoly3({ -15, -15, -15 }, polyC)
	polyK = translatePoly3({ -15, -15, -15 }, polyD)
	polyL = translatePoly3({ -15, -15, -15 }, polyE)
	obs = reTesselateCoplanarPolygons({ polyH, polyI, polyJ, polyK, polyL })
	expect(#obs).toBe(1)
end)
