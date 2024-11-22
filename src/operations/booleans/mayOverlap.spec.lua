-- ROBLOX NOTE: no upstream
local JestGlobals = require("@DevPackages/JestGlobals")
local test, expect = JestGlobals.test, JestGlobals.expect

local EPS = require("../../maths/constants").EPS
local geom3 = require("../../geometries").geom3
local cuboid = require("../../primitives").cuboid
local mayOverlap = require("./mayOverlap")
local center = require("../transforms/center").center
test.only("mayOverlap: determination of overlap is reliable", function()
	local geometry1 = center({ relativeTo = { 0, 0, 0 } }, cuboid({ size = { 4, 4, 4 } }))
	local geometry2 = center({ relativeTo = { 0, 0, 0 } }, cuboid({ size = { 2, 2, 2 } }))
	expect(mayOverlap(geometry1, geometry2)).toBe(true) -- overlap at each corner
	geometry2 = center({ relativeTo = { 3, 3, 3 } }, cuboid({ size = { 2, 2, 2 } }))
	expect(mayOverlap(geometry1, geometry2)).toBe(true)
	geometry2 = center({ relativeTo = { -3, 3, 3 } }, cuboid({ size = { 2, 2, 2 } }))
	expect(mayOverlap(geometry1, geometry2)).toBe(true)
	geometry2 = center({ relativeTo = { -3, -3, 3 } }, cuboid({ size = { 2, 2, 2 } }))
	expect(mayOverlap(geometry1, geometry2)).toBe(true)
	geometry2 = center({ relativeTo = { 3, -3, 3 } }, cuboid({ size = { 2, 2, 2 } }))
	expect(mayOverlap(geometry1, geometry2)).toBe(true)
	geometry2 = center({ relativeTo = { -3, -3, -3 } }, cuboid({ size = { 2, 2, 2 } }))
	expect(mayOverlap(geometry1, geometry2)).toBe(true)
	geometry2 = center({ relativeTo = { 3, -3, -3 } }, cuboid({ size = { 2, 2, 2 } }))
	expect(mayOverlap(geometry1, geometry2)).toBe(true)
	geometry2 = center({ relativeTo = { 3, 3, -3 } }, cuboid({ size = { 2, 2, 2 } }))
	expect(mayOverlap(geometry1, geometry2)).toBe(true)
	geometry2 = center({ relativeTo = { -3, 3, -3 } }, cuboid({ size = { 2, 2, 2 } }))
	expect(mayOverlap(geometry1, geometry2)).toBe(true) -- from issue #137, precision errors cause determination to fail
	-- see the value of EPS
	local issue1 = center({ relativeTo = { 0, 0, -1 } }, cuboid({ size = { 44, 26, 5 } }))
	local issue2 = center({ relativeTo = { 5, 0, -4.400001 } }, cuboid({ size = { 44, 26, 1.8 } }))
	expect(mayOverlap(issue1, issue2)).toBe(true)
	geometry2 = center({ relativeTo = { 0, 0, 4 + 0.000001 } }, cuboid({ size = { 4, 4, 4 } }))
	expect(mayOverlap(geometry1, geometry2)).toBe(true)
	geometry2 = center({ relativeTo = { 0, 0, -4 - 0.000001 } }, cuboid({ size = { 4, 4, 4 } }))
	expect(mayOverlap(geometry1, geometry2)).toBe(true)
	geometry2 = center({ relativeTo = { 0, 4 + 0.000001, 0 } }, cuboid({ size = { 4, 4, 4 } }))
	expect(mayOverlap(geometry1, geometry2)).toBe(true)
	geometry2 = center({ relativeTo = { 0, -4 - 0.000001, 0 } }, cuboid({ size = { 4, 4, 4 } }))
	expect(mayOverlap(geometry1, geometry2)).toBe(true)
	geometry2 = center({ relativeTo = { 4 + 0.000001, 0, 0 } }, cuboid({ size = { 4, 4, 4 } }))
	expect(mayOverlap(geometry1, geometry2)).toBe(true)
	geometry2 = center({ relativeTo = { -4 - 0.000001, 0, 0 } }, cuboid({ size = { 4, 4, 4 } }))
	expect(mayOverlap(geometry1, geometry2)).toBe(true) -- NO overlap tests
	expect(mayOverlap(geometry1, geom3.create())).toBe(false)
	expect(mayOverlap(geom3.create(), geometry1)).toBe(false)
	local eps = EPS + EPS * 0.001
	geometry2 = center({ relativeTo = { 0, 0, 4 + eps } }, cuboid({ size = { 4, 4, 4 } }))
	expect(mayOverlap(geometry1, geometry2)).toBe(false)
	geometry2 = center({ relativeTo = { 0, 0, -4 - eps } }, cuboid({ size = { 4, 4, 4 } }))
	expect(mayOverlap(geometry1, geometry2)).toBe(false)
	geometry2 = center({ relativeTo = { 0, 4 + eps, 0 } }, cuboid({ size = { 4, 4, 4 } }))
	expect(mayOverlap(geometry1, geometry2)).toBe(false)
	geometry2 = center({ relativeTo = { 0, -4 - eps, 0 } }, cuboid({ size = { 4, 4, 4 } }))
	expect(mayOverlap(geometry1, geometry2)).toBe(false)
	geometry2 = center({ relativeTo = { 4 + eps, 0, 0 } }, cuboid({ size = { 4, 4, 4 } }))
	expect(mayOverlap(geometry1, geometry2)).toBe(false)
	geometry2 = center({ relativeTo = { -4 - eps, 0, 0 } }, cuboid({ size = { 4, 4, 4 } }))
	expect(mayOverlap(geometry1, geometry2)).toBe(false)
end)
