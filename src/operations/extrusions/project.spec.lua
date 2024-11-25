-- ROBLOX NOTE: no upstream
local JestGlobals = require("@DevPackages/JestGlobals")
local test, expect = JestGlobals.test, JestGlobals.expect

local comparePoints = require("../../../test/helpers/comparePoints")
local geom2, geom3
do
	local ref = require("../../geometries")
	geom2, geom3 = ref.geom2, ref.geom3
end
local cube, torus
do
	local ref = require("../../primitives")
	cube, torus = ref.cube, ref.torus
end
local project = require("./init").project
test("project (defaults)", function()
	local geometry0 = geom3.create()
	local geometry1 = cube({ size = 10 })
	local geometry2 = "hi"
	local geometry3 = nil
	local geometry4 = nil
	local results = project({}, geometry0, geometry1, geometry2, geometry3, geometry4)
	expect(#results).toBe(5)
	expect(function()
		return geom2.validate(results[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		])
	end).never.toThrow()
	expect(function()
		return geom2.validate(results[
			2 --[[ ROBLOX adaptation: added 1 to array index ]]
		])
	end).never.toThrow()
	expect(results[
		3 --[[ ROBLOX adaptation: added 1 to array index ]]
	]).toBe(geometry2)
	expect(results[
		4 --[[ ROBLOX adaptation: added 1 to array index ]]
	]).toBe(geometry3)
	expect(results[
		5 --[[ ROBLOX adaptation: added 1 to array index ]]
	]).toBe(geometry4)
	local result = project({}, torus({ outerSegments = 4 }))
	expect(function()
		return geom2.validate(result)
	end).never.toThrow()
	local pts = geom2.toPoints(result)
	local exp = {
		{ 0, -5.000013333333333 },
		{ 5.000013333333333, 0 },
		{ -5.000013333333333, 0 },
		{ 0, 2.9999933333333333 },
		{ -2.9999933333333333, 0 },
		{ 0, -2.9999933333333333 },
		{ 2.9999933333333333, 0 },
		{ 0, 5.000013333333333 },
	}
	expect(comparePoints(pts, exp)).toBe(true)
end)
test("project (X and Y axis)", function()
	local result = project({ axis = { 1, 0, 0 }, origin = { 1, 0, 0 } }, torus({ outerSegments = 4 }))
	expect(function()
		return geom2.validate(result)
	end).never.toThrow()
	local pts = geom2.toPoints(result)
	local exp = {
		{ -0.19511333333333336, -4.98078 },
		{ 0, -5.000006666666668 },
		{ 0, 5.000006666666668 },
		{ 0.3826666666666667, 4.923893333333334 },
		{ -0.3826666666666667, -4.923893333333334 },
		{ 0.19511333333333336, -4.98078 },
		{ -0.19511333333333336, 4.98078 },
		{ -0.5555666666666668, -4.831446666666667 },
		{ 0.5555666666666668, 4.831446666666667 },
		{ -0.3826666666666667, 4.923893333333334 },
		{ 0.3826666666666667, -4.923893333333334 },
		{ 0.7070933333333335, 4.707126666666667 },
		{ -0.7070933333333335, -4.707126666666667 },
		{ 0.5555666666666668, -4.831446666666667 },
		{ -0.5555666666666668, 4.831446666666667 },
		{ 0.8314600000000001, 4.555553333333334 },
		{ -0.8314600000000001, -4.555553333333334 },
		{ 0.7070933333333335, -4.707126666666667 },
		{ -0.7070933333333335, 4.707126666666667 },
		{ -0.9238600000000001, -4.382700000000001 },
		{ 0.9238600000000001, 4.382700000000001 },
		{ -0.8314600000000001, 4.555553333333334 },
		{ 0.8314600000000001, -4.555553333333334 },
		{ 0.9807933333333334, 4.1951 },
		{ -0.9807933333333334, -4.1951 },
		{ 0.9238600000000001, -4.382700000000001 },
		{ -0.9238600000000001, 4.382700000000001 },
		{ 1.0000200000000001, 3.999986666666667 },
		{ -1.0000200000000001, -3.999986666666667 },
		{ 1.0000200000000001, -3.999986666666667 },
		{ -1.0000200000000001, 3.999986666666667 },
		{ -0.9807933333333334, 4.1951 },
		{ 0.9807933333333334, -4.1951 },
		{ 0.19511333333333336, 4.98078 },
	}
	expect(comparePoints(pts, exp)).toBe(true)
	result = project({ axis = { 0, 1, 0 }, origin = { 0, -1, 0 } }, torus({ outerSegments = 4 }))
	expect(function()
		return geom2.validate(result)
	end).never.toThrow()
	pts = geom2.toPoints(result)
	exp = {
		{ 4.98078, -0.19511333333333336 },
		{ 5.000006666666668, 0 },
		{ -5.000006666666668, 0 },
		{ -4.923893333333334, 0.3826666666666667 },
		{ 4.923893333333334, -0.3826666666666667 },
		{ 4.98078, 0.19511333333333336 },
		{ -4.98078, -0.19511333333333336 },
		{ 4.831446666666667, -0.5555666666666668 },
		{ -4.831446666666667, 0.5555666666666668 },
		{ -4.923893333333334, -0.3826666666666667 },
		{ 4.923893333333334, 0.3826666666666667 },
		{ -4.707126666666667, 0.7070933333333335 },
		{ 4.707126666666667, -0.7070933333333335 },
		{ 4.831446666666667, 0.5555666666666668 },
		{ -4.831446666666667, -0.5555666666666668 },
		{ 4.555553333333334, -0.8314600000000001 },
		{ -4.555553333333334, 0.8314600000000001 },
		{ 4.707126666666667, 0.7070933333333335 },
		{ -4.707126666666667, -0.7070933333333335 },
		{ 4.382700000000001, -0.9238600000000001 },
		{ -4.382700000000001, 0.9238600000000001 },
		{ -4.555553333333334, -0.8314600000000001 },
		{ 4.555553333333334, 0.8314600000000001 },
		{ -4.1951, 0.9807933333333334 },
		{ 4.1951, -0.9807933333333334 },
		{ 4.382700000000001, 0.9238600000000001 },
		{ -4.382700000000001, -0.9238600000000001 },
		{ 3.999986666666667, -1.0000200000000001 },
		{ -3.999986666666667, 1.0000200000000001 },
		{ 3.999986666666667, 1.0000200000000001 },
		{ -3.999986666666667, -1.0000200000000001 },
		{ 4.1951, 0.9807933333333334 },
		{ -4.1951, -0.9807933333333334 },
		{ -4.98078, 0.19511333333333336 },
	}
	expect(comparePoints(pts, exp)).toBe(true)
end)
