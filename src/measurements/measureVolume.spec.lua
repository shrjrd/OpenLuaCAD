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
local measureVolume = require("./init").measureVolume
test("measureVolume: single objects", function()
	local aline = line({ { 10, 10 }, { 15, 15 } })
	local arect = rectangle()
	local acube = cuboid()
	local apath2 = path2.create()
	local ageom2 = geom2.create()
	local ageom3 = geom3.create()
	local n = nil
	local o = {}
	local x = "hi"
	local lvolume = measureVolume(aline)
	local rvolume = measureVolume(arect)
	local cvolume = measureVolume(acube)
	local p2volume = measureVolume(apath2)
	local g2volume = measureVolume(ageom2)
	local g3volume = measureVolume(ageom3)
	local nvolume = measureVolume(n)
	local ovolume = measureVolume(o)
	local xvolume = measureVolume(x)
	expect(lvolume).toBe(0)
	expect(rvolume).toBe(0)
	expect(cvolume).toBe(7.999999999999999)
	expect(p2volume).toBe(0)
	expect(g2volume).toBe(0)
	expect(g3volume).toBe(0)
	expect(nvolume).toBe(0)
	expect(ovolume).toBe(0)
	expect(xvolume).toBe(0)
end)
test("measureVolume (multiple objects)", function()
	local aline = line({ { 10, 10 }, { 15, 15 } })
	local arect = rectangle({ size = { 5, 10 } })
	local acube = cuboid({ size = { 10, 20, 40 } })
	local o = {}
	local allvolume = measureVolume(aline, arect, acube, o)
	expect(allvolume).toEqual({ 0, 0, 7999.999999999999, 0 })
	allvolume = measureVolume(aline, arect, acube, o)
	expect(allvolume).toEqual({ 0, 0, 7999.999999999999, 0 })
end)
