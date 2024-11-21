-- ROBLOX NOTE: no upstream
local JestGlobals = require("@DevPackages/JestGlobals")
local test, expect = JestGlobals.test, JestGlobals.expect

local geom2, geom3, path2
do
	local ref = require("../geometries")
	geom2, geom3, path2 = ref.geom2, ref.geom3, ref.path2
end
local ellipsoid, line, rectangle, cuboid
do
	local ref = require("../primitives")
	ellipsoid, line, rectangle, cuboid = ref.ellipsoid, ref.line, ref.rectangle, ref.cuboid
end
local measureCenterOfMass = require("./init").measureCenterOfMass
test("measureCenterOfMass (single objects)", function()
	local aline = line({ { 10, 10 }, { 15, 15 } })
	local arect = rectangle({ center = { 5, 5 } })
	local acube = cuboid({ size = { 3, 3, 3 }, center = { -15, -5, -10 } })
	local apath2 = path2.create()
	local ageom2 = geom2.create()
	local ageom3 = geom3.create()
	local n = nil
	local o = {}
	local x = "hi"
	local lcenter = measureCenterOfMass(aline)
	local rcenter = measureCenterOfMass(arect)
	local ccenter = measureCenterOfMass(acube)
	local p2center = measureCenterOfMass(apath2)
	local g2center = measureCenterOfMass(ageom2)
	local g3center = measureCenterOfMass(ageom3)
	local ncenter = measureCenterOfMass(n)
	local ocenter = measureCenterOfMass(o)
	local xcenter = measureCenterOfMass(x)
	expect(lcenter).toEqual({ 0, 0, 0 })
	expect(rcenter).toEqual({ 5, 5, 0 })
	expect(ccenter).toEqual({ -15, -5, -10 })
	expect(p2center).toEqual({ 0, 0, 0 })
	expect(g2center).toEqual({ 0, 0, 0 })
	expect(g3center).toEqual({ 0, 0, 0 })
	expect(ncenter).toEqual({ 0, 0, 0 })
	expect(ocenter).toEqual({ 0, 0, 0 })
	expect(xcenter).toEqual({ 0, 0, 0 })
end)
test("measureCenterOfMass (multiple objects)", function()
	local aline = line({ { 10, 10 }, { 15, 15 } })
	local arect = rectangle({ size = { 10, 20 }, center = { 10, -10 } })
	local asphere = ellipsoid({ radius = { 5, 10, 15 }, center = { 5, -5, 50 } })
	local o = {}
	local allcenters = measureCenterOfMass(aline, arect, asphere, o)
	expect(allcenters).toEqual({
		{ 0, 0, 0 },
		{ 10, -10, 0 },
		{ 4.999999999999991, -5.000000000000006, 49.999999999999915 },
		{ 0, 0, 0 },
	})
	allcenters = measureCenterOfMass(aline, arect, asphere, o)
	expect(allcenters).toEqual({
		{ 0, 0, 0 },
		{ 10, -10, 0 },
		{ 4.999999999999991, -5.000000000000006, 49.999999999999915 },
		{ 0, 0, 0 },
	})
end)
