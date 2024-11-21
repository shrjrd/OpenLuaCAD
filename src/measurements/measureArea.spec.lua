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
local measureArea = require("./init").measureArea
test("measureArea: single objects", function()
	local aline = line({ { 10, 10 }, { 15, 15 } })
	local arect = rectangle()
	local acube = cuboid()
	local apath2 = path2.create()
	local ageom2 = geom2.create()
	local ageom3 = geom3.create()
	local n = nil
	local o = {}
	local x = "hi"
	local larea = measureArea(aline)
	local rarea = measureArea(arect)
	local carea = measureArea(acube)
	local p2area = measureArea(apath2)
	local g2area = measureArea(ageom2)
	local g3area = measureArea(ageom3)
	local narea = measureArea(n)
	local oarea = measureArea(o)
	local xarea = measureArea(x)
	expect(larea).toBe(0)
	expect(rarea).toBe(4) -- 2x2
	expect(carea).toBe(24) -- 2x2x6
	expect(p2area).toBe(0)
	expect(g2area).toBe(0)
	expect(g3area).toBe(0)
	expect(narea).toBe(0)
	expect(oarea).toBe(0)
	expect(xarea).toBe(0)
end)
test("measureArea (multiple objects)", function()
	local aline = line({ { 10, 10 }, { 15, 15 } })
	local arect = rectangle({ size = { 10, 20 } })
	local acube = cuboid({ size = { 10, 20, 40 } })
	local o = {}
	local allarea = measureArea(aline, arect, acube, o)
	expect(allarea).toEqual({ 0, 200, 2800, 0 })
	allarea = measureArea(aline, arect, acube, o)
	expect(allarea).toEqual({ 0, 200, 2800, 0 })
end)
