-- ROBLOX NOTE: no upstream
local JestGlobals = require("@DevPackages/JestGlobals")
local test, expect = JestGlobals.test, JestGlobals.expect

local geom2, geom3, path2
do
	local ref = require("../geometries")
	geom2, geom3, path2 = ref.geom2, ref.geom3, ref.path2
end
local line, rectangle, cuboid
do
	local ref = require("../primitives")
	line, rectangle, cuboid = ref.line, ref.rectangle, ref.cuboid
end
local mirror = require("../operations/transforms").mirror
local measureBoundingBox = require("./init").measureBoundingBox
test("measureBoundingBox (single objects)", function()
	local aline = line({ { 10, 10 }, { 15, 15 } })
	local arect = rectangle()
	local acube = cuboid()
	local apath2 = path2.create()
	local ageom2 = geom2.create()
	local ageom3 = geom3.create()
	local n = nil
	local o = {}
	local x = "hi"
	local lbounds = measureBoundingBox(aline)
	local rbounds = measureBoundingBox(arect)
	local cbounds = measureBoundingBox(acube)
	local p2bounds = measureBoundingBox(apath2)
	local g2bounds = measureBoundingBox(ageom2)
	local g3bounds = measureBoundingBox(ageom3)
	local nbounds = measureBoundingBox(n)
	local obounds = measureBoundingBox(o)
	local xbounds = measureBoundingBox(x)
	expect(lbounds).toEqual({ { 10, 10, 0 }, { 15, 15, 0 } })
	expect(rbounds).toEqual({ { -1, -1, 0 }, { 1, 1, 0 } })
	expect(cbounds).toEqual({ { -1, -1, -1 }, { 1, 1, 1 } })
	expect(p2bounds).toEqual({ { 0, 0, 0 }, { 0, 0, 0 } })
	expect(g2bounds).toEqual({ { 0, 0, 0 }, { 0, 0, 0 } })
	expect(g3bounds).toEqual({ { 0, 0, 0 }, { 0, 0, 0 } })
	expect(nbounds).toEqual({ { 0, 0, 0 }, { 0, 0, 0 } })
	expect(obounds).toEqual({ { 0, 0, 0 }, { 0, 0, 0 } })
	expect(xbounds).toEqual({ { 0, 0, 0 }, { 0, 0, 0 } })
end)
test("measureBoundingBox (multiple objects)", function()
	local aline = line({ { 10, 10 }, { 15, 15 } })
	local arect = rectangle({ size = { 10, 20 } })
	local acube = cuboid()
	local o = {}
	local allbounds = measureBoundingBox(aline, arect, acube, o)
	expect(allbounds).toEqual({
		{ { 10, 10, 0 }, { 15, 15, 0 } },
		{ { -5, -10, 0 }, { 5, 10, 0 } },
		{ { -1, -1, -1 }, { 1, 1, 1 } },
		{ { 0, 0, 0 }, { 0, 0, 0 } },
	})
	allbounds = measureBoundingBox(aline, arect, acube, o)
	expect(allbounds).toEqual({
		{ { 10, 10, 0 }, { 15, 15, 0 } },
		{ { -5, -10, 0 }, { 5, 10, 0 } },
		{ { -1, -1, -1 }, { 1, 1, 1 } },
		{ { 0, 0, 0 }, { 0, 0, 0 } },
	})
end)
test("measureBoundingBox invert", function()
	local acube = mirror({}, cuboid())
	local cbounds = measureBoundingBox(acube)
	expect(cbounds).toEqual({ { -1, -1, -1 }, { 1, 1, 1 } })
end)
