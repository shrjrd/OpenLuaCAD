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
local measureEpsilon = require("./init").measureEpsilon
test("measureEpsilon (single objects)", function()
	local aline = line({ { 10, 10 }, { 15, 15 } })
	local arect = rectangle()
	local acube = cuboid()
	local apath2 = path2.create()
	local ageom2 = geom2.create()
	local ageom3 = geom3.create()
	local n = nil
	local o = {}
	local x = "hi"
	local lepsilon = measureEpsilon(aline)
	local repsilon = measureEpsilon(arect)
	local cepsilon = measureEpsilon(acube)
	local p2epsilon = measureEpsilon(apath2)
	local g2epsilon = measureEpsilon(ageom2)
	local g3epsilon = measureEpsilon(ageom3)
	local nepsilon = measureEpsilon(n)
	local oepsilon = measureEpsilon(o)
	local xepsilon = measureEpsilon(x)
	expect(lepsilon).toBe(0.00005)
	expect(repsilon).toBe(0.00002)
	expect(cepsilon).toBe(0.00002)
	expect(p2epsilon).toBe(0)
	expect(g2epsilon).toBe(0)
	expect(g3epsilon).toBe(0)
	expect(nepsilon).toBe(0)
	expect(oepsilon).toBe(0)
	expect(xepsilon).toBe(0)
end)
test("measureEpsilon (multiple objects)", function()
	local aline = line({ { 10, 10 }, { 15, 15 } })
	local arect = rectangle({ size = { 10, 20 } })
	local acube = cuboid()
	local o = {}
	local allepsilon = measureEpsilon(aline, arect, acube, o)
	expect(allepsilon).toEqual({ 0.00005, 0.00015000000000000001, 0.00002, 0.0 })
	allepsilon = measureEpsilon(aline, arect, acube, o)
	expect(allepsilon).toEqual({ 0.00005, 0.00015000000000000001, 0.00002, 0.0 })
end)
