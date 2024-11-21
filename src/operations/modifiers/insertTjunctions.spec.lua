-- ROBLOX NOTE: no upstream
local JestGlobals = require("@DevPackages/JestGlobals")
local test, expect = JestGlobals.test, JestGlobals.expect

local comparePolygonLists = require("../../../test/helpers").comparePolygonLists
local geom3, poly3
do
	local ref = require("../../geometries")
	geom3, poly3 = ref.geom3, ref.poly3
end
local cuboid = require("../../primitives").cuboid
local insertTjunctions = require("./insertTjunctions")
test("insertTjunctions: insertTjunctions produces expected polygons", function()
	local geometry1 = geom3.create()
	local geometry2 = cuboid({ size = { 2, 2, 2 } })
	local geometry3 = geom3.fromPoints({
		{ { -1, -1, -1 }, { -1, -1, 1 }, { -1, 1, 1 }, { -1, 1, -1 } },
		{ { 1, -1, -1 }, { 1, 1, -1 }, { 1, 1, 1 }, { 1, -1, 1 } },
		{ { -1, -1, -1 }, { 1, -1, -1 }, { 1, -1, 1 }, { -1, -1, 1 } },
		{ { -1, 1, -1 }, { -1, 1, 1 }, { 1, 1, 1 }, { 1, 1, -1 } },
		{ { -1, -1, -1 }, { -1, 1, -1 }, { 1, 1, -1 }, { 1, -1, -1 } },
		-- T junction
		-- T junction
		{ { -1, -1, 1 }, { 1, -1, 1 }, { 1, 1, 1 } },
		{ { 1, 1, 1 }, { -1, 1, 1 }, { 0, 0, 1 } },
		{ { -1, 1, 1 }, { -1, -1, 1 }, { 0, 0, 1 } },
	})
	local geometry4 = geom3.fromPoints({
		{ { -1, -1, -1 }, { -1, -1, 1 }, { -1, 1, 1 }, { -1, 1, -1 } },
		{ { 1, -1, -1 }, { 1, 1, -1 }, { 1, 1, 1 }, { 1, -1, 1 } },
		{ { -1, -1, -1 }, { 1, -1, -1 }, { 1, -1, 1 }, { -1, -1, 1 } },
		{ { -1, 1, -1 }, { -1, 1, 1 }, { 1, 1, 1 }, { 1, 1, -1 } },
		{ { -1, -1, -1 }, { -1, 1, -1 }, { 1, 1, -1 }, { 1, -1, -1 } },
		-- T junctions
		-- T junctions
		{ { -1, -1, 1 }, { 0, -1, 1 }, { 0, 0, 1 } },
		{ { -1, 0, 1 }, { -1, -1, 1 }, { 0, 0, 1 } },
		{ { 0, -1, 1 }, { 1, -1, 1 }, { 0, 0, 1 } },
		{ { 1, -1, 1 }, { 1, 0, 1 }, { 0, 0, 1 } },
		{ { 1, 0, 1 }, { 1, 1, 1 }, { 0, 0, 1 } },
		{ { 1, 1, 1 }, { 0, 1, 1 }, { 0, 0, 1 } },
		{ { 0, 1, 1 }, { -1, 1, 1 }, { 0, 0, 1 } },
		{ { -1, 1, 1 }, { -1, 0, 1 }, { 0, 0, 1 } },
	})
	local result1 = insertTjunctions(geom3.toPolygons(geometry1))
	expect(result1).toBe(geom3.toPolygons(geometry1)) -- no T junctions
	local result2 = insertTjunctions(geom3.toPolygons(geometry2))
	expect(result2).toBe(geom3.toPolygons(geometry2)) -- no T junctions
	-- NOTE: insertTjunctions does NOT split the polygon, it just adds a new point at each T
	local result3 = insertTjunctions(geom3.toPolygons(geometry3))
	local exp = {
		poly3.create({ { -1, -1, -1 }, { -1, -1, 1 }, { -1, 1, 1 }, { -1, 1, -1 } }),
		poly3.create({ { 1, -1, -1 }, { 1, 1, -1 }, { 1, 1, 1 }, { 1, -1, 1 } }),
		poly3.create({ { -1, -1, -1 }, { 1, -1, -1 }, { 1, -1, 1 }, { -1, -1, 1 } }),
		poly3.create({ { -1, 1, -1 }, { -1, 1, 1 }, { 1, 1, 1 }, { 1, 1, -1 } }),
		poly3.create({ { -1, -1, -1 }, { -1, 1, -1 }, { 1, 1, -1 }, { 1, -1, -1 } }),
		poly3.create({ { 0, 0, 1 }, { -1, -1, 1 }, { 1, -1, 1 }, { 1, 1, 1 } }),
		poly3.create({ { 1, 1, 1 }, { -1, 1, 1 }, { 0, 0, 1 } }),
		poly3.create({ { -1, 1, 1 }, { -1, -1, 1 }, { 0, 0, 1 } }),
	}
	expect(result3)["not"].toBe(geom3.toPolygons(geometry3))
	expect(comparePolygonLists(result3, exp)).toBe(true)
	local result4 = insertTjunctions(geom3.toPolygons(geometry4))
	exp = {
		poly3.create({ { -1, -1, -1 }, { -1, -1, 1 }, { -1, 0, 1 }, { -1, 1, 1 }, { -1, 1, -1 } }),
		poly3.create({ { 1, -1, -1 }, { 1, 1, -1 }, { 1, 1, 1 }, { 1, 0, 1 }, { 1, -1, 1 } }),
		poly3.create({ { -1, -1, -1 }, { 1, -1, -1 }, { 1, -1, 1 }, { 0, -1, 1 }, { -1, -1, 1 } }),
		poly3.create({ { -1, 1, -1 }, { -1, 1, 1 }, { 0, 1, 1 }, { 1, 1, 1 }, { 1, 1, -1 } }),
		poly3.create({ { -1, -1, -1 }, { -1, 1, -1 }, { 1, 1, -1 }, { 1, -1, -1 } }),
		poly3.create({ { -1, -1, 1 }, { 0, -1, 1 }, { 0, 0, 1 } }),
		poly3.create({ { -1, 0, 1 }, { -1, -1, 1 }, { 0, 0, 1 } }),
		poly3.create({ { 0, -1, 1 }, { 1, -1, 1 }, { 0, 0, 1 } }),
		poly3.create({ { 1, -1, 1 }, { 1, 0, 1 }, { 0, 0, 1 } }),
		poly3.create({ { 1, 0, 1 }, { 1, 1, 1 }, { 0, 0, 1 } }),
		poly3.create({ { 1, 1, 1 }, { 0, 1, 1 }, { 0, 0, 1 } }),
		poly3.create({ { 0, 1, 1 }, { -1, 1, 1 }, { 0, 0, 1 } }),
		poly3.create({ { -1, 1, 1 }, { -1, 0, 1 }, { 0, 0, 1 } }),
	}
	expect(result4)["not"].toBe(geometry4)
	expect(comparePolygonLists(result4, exp)).toBe(true)
end)
