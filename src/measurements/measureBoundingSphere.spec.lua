-- ROBLOX NOTE: no upstream
local JestGlobals = require("@DevPackages/JestGlobals")
local test, expect = JestGlobals.test, JestGlobals.expect

local geom2, geom3, path2
do
	local ref = require("../geometries")
	geom2, geom3, path2 = ref.geom2, ref.geom3, ref.path2
end
local line, rectangle, ellipsoid
do
	local ref = require("../primitives")
	line, rectangle, ellipsoid = ref.line, ref.rectangle, ref.ellipsoid
end
local measureBoundingSphere = require("./init").measureBoundingSphere
test("measureBoundingSphere (single objects)", function()
	local aline = line({ { 10, 10 }, { 15, 15 } })
	local arect = rectangle()
	local aellipsoid = ellipsoid({ radius = { 5, 10, 15 }, center = { 5, 5, 5 } })
	local apath2 = path2.create()
	local ageom2 = geom2.create()
	local ageom3 = geom3.create()
	local n = nil
	local o = {}
	local x = "hi"
	local lbounds = measureBoundingSphere(aline)
	local rbounds = measureBoundingSphere(arect)
	local cbounds = measureBoundingSphere(aellipsoid)
	local p2bounds = measureBoundingSphere(apath2)
	local g2bounds = measureBoundingSphere(ageom2)
	local g3bounds = measureBoundingSphere(ageom3)
	local nbounds = measureBoundingSphere(n)
	local obounds = measureBoundingSphere(o)
	local xbounds = measureBoundingSphere(x)
	expect(lbounds).toEqual({ { 12.5, 12.5, 0 }, 3.5355339059327378 })
	expect(rbounds).toEqual({ { 0, 0, 0 }, 1.4142135623730951 })
	expect(cbounds).toEqual({ { 5.000000000000018, 4.999999999999983, 5.000000000000001 }, 15 })
	expect(p2bounds).toEqual({ { 0, 0, 0 }, 0 })
	expect(g2bounds).toEqual({ { 0, 0, 0 }, 0 })
	expect(g3bounds).toEqual({ { 0, 0, 0 }, 0 })
	expect(nbounds).toEqual({ { 0, 0, 0 }, 0 })
	expect(obounds).toEqual({ { 0, 0, 0 }, 0 })
	expect(xbounds).toEqual({ { 0, 0, 0 }, 0 })
end)
test("measureBoundingSphere (multiple objects)", function()
	local aline = line({ { 10, 10 }, { 15, 15 } })
	local arect = rectangle()
	local aellipsoid = ellipsoid({ radius = { 5, 10, 15 }, center = { 5, 5, 5 } })
	local o = {}
	local allbounds = measureBoundingSphere(aline, arect, aellipsoid, o)
	expect(allbounds).toEqual({
		{ { 12.5, 12.5, 0 }, 3.5355339059327378 },
		{ { 0, 0, 0 }, 1.4142135623730951 },
		{ { 5.000000000000018, 4.999999999999983, 5.000000000000001 }, 15 },
		{ { 0, 0, 0 }, 0 },
	}) -- test caching
	allbounds = measureBoundingSphere(aline, arect, aellipsoid, o)
	expect(allbounds).toEqual({
		{ { 12.5, 12.5, 0 }, 3.5355339059327378 },
		{ { 0, 0, 0 }, 1.4142135623730951 },
		{ { 5.000000000000018, 4.999999999999983, 5.000000000000001 }, 15 },
		{ { 0, 0, 0 }, 0 },
	})
end)
