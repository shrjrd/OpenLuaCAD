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
local measureCenter = require("./init").measureCenter
test("measureCenter (single objects)", function()
	local aline = line({ { 10, 10 }, { 15, 15 } })
	local arect = rectangle({ center = { 5, 5 } })
	local acube = cuboid({ center = { -5, -5, -5 } })
	local apath2 = path2.create()
	local ageom2 = geom2.create()
	local ageom3 = geom3.create()
	local n = nil
	local o = {}
	local x = "hi"
	local lcenter = measureCenter(aline)
	local rcenter = measureCenter(arect)
	local ccenter = measureCenter(acube)
	local p2center = measureCenter(apath2)
	local g2center = measureCenter(ageom2)
	local g3center = measureCenter(ageom3)
	local ncenter = measureCenter(n)
	local ocenter = measureCenter(o)
	local xcenter = measureCenter(x)
	expect(lcenter).toEqual({ 12.5, 12.5, 0 })
	expect(rcenter).toEqual({ 5, 5, 0 })
	expect(ccenter).toEqual({ -5, -5, -5 })
	expect(p2center).toEqual({ 0, 0, 0 })
	expect(g2center).toEqual({ 0, 0, 0 })
	expect(g3center).toEqual({ 0, 0, 0 })
	expect(ncenter).toEqual({ 0, 0, 0 })
	expect(ocenter).toEqual({ 0, 0, 0 })
	expect(xcenter).toEqual({ 0, 0, 0 })
end)
test("measureCenter (multiple objects)", function()
	local aline = line({ { 10, 10 }, { 15, 15 } })
	local arect = rectangle({ size = { 10, 20 } })
	local acube = cuboid({ center = { -5, -5, -5 } })
	local o = {}
	local allcenters = measureCenter(aline, arect, acube, o)
	expect(allcenters).toEqual({ { 12.5, 12.5, 0 }, { 0, 0, 0 }, { -5, -5, -5 }, { 0, 0, 0 } })
	allcenters = measureCenter(aline, arect, acube, o)
	expect(allcenters).toEqual({ { 12.5, 12.5, 0 }, { 0, 0, 0 }, { -5, -5, -5 }, { 0, 0, 0 } })
end)
