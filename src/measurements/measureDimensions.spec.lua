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
local measureDimensions = require("./init").measureDimensions
test("measureDimensions (single objects)", function()
	local aline = line({ { 10, 10 }, { 15, 15 } })
	local arect = rectangle()
	local acube = cuboid()
	local apath2 = path2.create()
	local ageom2 = geom2.create()
	local ageom3 = geom3.create()
	local n = nil
	local o = {}
	local x = "hi"
	local lbounds = measureDimensions(aline)
	local rbounds = measureDimensions(arect)
	local cbounds = measureDimensions(acube)
	local p2bounds = measureDimensions(apath2)
	local g2bounds = measureDimensions(ageom2)
	local g3bounds = measureDimensions(ageom3)
	local nbounds = measureDimensions(n)
	local obounds = measureDimensions(o)
	local xbounds = measureDimensions(x)
	expect(lbounds).toEqual({ 5, 5, 0 })
	expect(rbounds).toEqual({ 2, 2, 0 })
	expect(cbounds).toEqual({ 2, 2, 2 })
	expect(p2bounds).toEqual({ 0, 0, 0 })
	expect(g2bounds).toEqual({ 0, 0, 0 })
	expect(g3bounds).toEqual({ 0, 0, 0 })
	expect(nbounds).toEqual({ 0, 0, 0 })
	expect(obounds).toEqual({ 0, 0, 0 })
	expect(xbounds).toEqual({ 0, 0, 0 })
end)
test("measureDimensions (multiple objects)", function()
	local aline = line({ { 10, 10 }, { 15, 15 } })
	local arect = rectangle({ size = { 10, 20 } })
	local acube = cuboid()
	local o = {}
	local allbounds = measureDimensions(aline, arect, acube, o)
	expect(allbounds).toEqual({ { 5, 5, 0 }, { 10, 20, 0 }, { 2, 2, 2 }, { 0, 0, 0 } })
	allbounds = measureDimensions(aline, arect, acube, o)
	expect(allbounds).toEqual({ { 5, 5, 0 }, { 10, 20, 0 }, { 2, 2, 2 }, { 0, 0, 0 } })
end)
