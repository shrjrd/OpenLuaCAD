-- ROBLOX NOTE: no upstream
local JestGlobals = require("@DevPackages/JestGlobals")
local test, expect = JestGlobals.test, JestGlobals.expect

local comparePoints, comparePolygonsAsPoints
do
	local ref = require("../../../test/helpers")
	comparePoints, comparePolygonsAsPoints = ref.comparePoints, ref.comparePolygonsAsPoints
end
local TAU = require("../../maths/constants").TAU
local geom2, geom3
do
	local ref = require("../../geometries")
	geom2, geom3 = ref.geom2, ref.geom3
end
local extrudeRotate = require("./init").extrudeRotate
test("extrudeRotate: (defaults) extruding of a geom2 produces an expected geom3", function()
	local geometry2 = geom2.fromPoints({ { 10, 8 }, { 10, -8 }, { 26, -8 }, { 26, 8 } })
	local geometry3 = extrudeRotate({}, geometry2)
	local pts = geom3.toPoints(geometry3)
	expect(function()
		return geom3.validate(geometry3)
	end)["not"].toThrow()
	expect(#pts).toBe(96)
end)
test("extrudeRotate: (angle) extruding of a geom2 produces an expected geom3", function()
	local geometry2 = geom2.fromPoints({ { 10, 8 }, { 10, -8 }, { 26, -8 }, { 26, 8 } }) -- test angle
	local geometry3 = extrudeRotate({ segments = 4, angle = TAU / 8 }, geometry2)
	local pts = geom3.toPoints(geometry3)
	local exp = {
		{ { 10, 0, 8 }, { 26, 0, 8 }, { 18.38477631085024, 18.384776310850235, 8 } },
		{
			{ 10, 0, 8 },
			{ 18.38477631085024, 18.384776310850235, 8 },
			{ 7.0710678118654755, 7.071067811865475, 8 },
		},
		{ { 10, 0, -8 }, { 10, 0, 8 }, { 7.0710678118654755, 7.071067811865475, 8 } },
		{
			{ 10, 0, -8 },
			{ 7.0710678118654755, 7.071067811865475, 8 },
			{ 7.0710678118654755, 7.071067811865475, -8 },
		},
		{ { 26, 0, -8 }, { 10, 0, -8 }, { 7.0710678118654755, 7.071067811865475, -8 } },
		{
			{ 26, 0, -8 },
			{ 7.0710678118654755, 7.071067811865475, -8 },
			{ 18.38477631085024, 18.384776310850235, -8 },
		},
		{ { 26, 0, 8 }, { 26, 0, -8 }, { 18.38477631085024, 18.384776310850235, -8 } },
		{
			{ 26, 0, 8 },
			{ 18.38477631085024, 18.384776310850235, -8 },
			{ 18.38477631085024, 18.384776310850235, 8 },
		},
		{
			{ 7.0710678118654755, 7.071067811865475, -8 },
			{ 7.0710678118654755, 7.071067811865475, 8 },
			{ 18.38477631085024, 18.384776310850235, 8 },
		},
		{
			{ 18.38477631085024, 18.384776310850235, 8 },
			{ 18.38477631085024, 18.384776310850235, -8 },
			{ 7.0710678118654755, 7.071067811865475, -8 },
		},
		{ { 26, 0, 8 }, { 10, 0, 8 }, { 10, 0, -8 } },
		{ { 10, 0, -8 }, { 26, 0, -8 }, { 26, 0, 8 } },
	}
	expect(function()
		return geom3.validate(geometry3)
	end)["not"].toThrow()
	expect(#pts).toBe(12)
	expect(comparePolygonsAsPoints(pts, exp)).toBe(true)
	geometry3 = extrudeRotate({ segments = 4, angle = -250 * 0.017453292519943295 }, geometry2)
	pts = geom3.toPoints(geometry3)
	expect(function()
		return geom3.validate(geometry3)
	end)["not"].toThrow()
	expect(#pts).toBe(28)
	geometry3 = extrudeRotate({ segments = 4, angle = 250 * 0.017453292519943295 }, geometry2)
	pts = geom3.toPoints(geometry3)
	expect(function()
		return geom3.validate(geometry3)
	end)["not"].toThrow()
	expect(#pts).toBe(28)
end)
test("extrudeRotate: (startAngle) extruding of a geom2 produces an expected geom3", function()
	local geometry2 = geom2.fromPoints({ { 10, 8 }, { 10, -8 }, { 26, -8 }, { 26, 8 } }) -- test startAngle
	local geometry3 = extrudeRotate({ segments = 5, startAngle = TAU / 8 }, geometry2)
	local pts = geom3.toPoints(geometry3)
	local exp = {
		{ 7.0710678118654755, 7.071067811865475, 8 },
		{ 18.38477631085024, 18.384776310850235, 8 },
		{ -11.803752993228215, 23.166169628897567, 8 },
	}
	expect(function()
		return geom3.validate(geometry3)
	end)["not"].toThrow()
	expect(#pts).toBe(40)
	expect(comparePoints(
		pts[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		],
		exp
	)).toBe(true)
	geometry3 = extrudeRotate({ segments = 5, startAngle = -TAU / 8 }, geometry2)
	pts = geom3.toPoints(geometry3)
	exp = {
		{ 7.0710678118654755, -7.071067811865475, 8 },
		{ 18.38477631085024, -18.384776310850235, 8 },
		{ 23.166169628897567, 11.803752993228215, 8 },
	}
	expect(function()
		return geom3.validate(geometry3)
	end)["not"].toThrow()
	expect(#pts).toBe(40)
	expect(comparePoints(
		pts[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		],
		exp
	)).toBe(true)
end)
test("extrudeRotate: (segments) extruding of a geom2 produces an expected geom3", function()
	local geometry2 = geom2.fromPoints({ { 10, 8 }, { 10, -8 }, { 26, -8 }, { 26, 8 } }) -- test segments
	local geometry3 = extrudeRotate({ segments = 4 }, geometry2)
	local pts = geom3.toPoints(geometry3)
	expect(function()
		return geom3.validate(geometry3)
	end)["not"].toThrow()
	expect(#pts).toBe(32)
	geometry3 = extrudeRotate({ segments = 64 }, geometry2)
	pts = geom3.toPoints(geometry3)
	expect(function()
		return geom3.validate(geometry3)
	end)["not"].toThrow()
	expect(#pts).toBe(512) -- test overlapping edges
	geometry2 = geom2.fromPoints({ { 0, 0 }, { 2, 1 }, { 1, 2 }, { 1, 3 }, { 3, 4 }, { 0, 5 } })
	geometry3 = extrudeRotate({ segments = 8 }, geometry2)
	pts = geom3.toPoints(geometry3)
	expect(function()
		return geom3.validate(geometry3)
	end)["not"].toThrow()
	expect(#pts).toBe(64) -- test overlapping edges that produce hollow shape
	geometry2 = geom2.fromPoints({
		{ 30, 0 },
		{ 30, 60 },
		{ 0, 60 },
		{ 0, 50 },
		{ 10, 40 },
		{ 10, 30 },
		{ 0, 20 },
		{ 0, 10 },
		{ 10, 0 },
	})
	geometry3 = extrudeRotate({ segments = 8 }, geometry2)
	pts = geom3.toPoints(geometry3)
	expect(function()
		return geom3.validate(geometry3)
	end)["not"].toThrow()
	expect(#pts).toBe(80)
end)
test("extrudeRotate: (overlap +/-) extruding of a geom2 produces an expected geom3", function()
	-- overlap of Y axis; even number of + and - points
	local geometry = geom2.fromPoints({ { -1, 8 }, { -1, -8 }, { 7, -8 }, { 7, 8 } })
	local obs = extrudeRotate({ segments = 4, angle = TAU / 4 }, geometry)
	local pts = geom3.toPoints(obs)
	local exp = {
		{ { 0, 0, 8 }, { 7, 0, 8 }, { 0, 7, 8 } },
		{ { 7, 0, -8 }, { 0, 0, -8 }, { 0, 7, -8 } },
		{ { 7, 0, 8 }, { 7, 0, -8 }, { 0, 7, -8 } },
		{ { 7, 0, 8 }, { 0, 7, -8 }, { 0, 7, 8 } },
		{ { 0, 0, -8 }, { 0, 0, 8 }, { 0, 7, 8 } },
		{ { 0, 7, 8 }, { 0, 7, -8 }, { 0, 0, -8 } },
		{ { 7, 0, 8 }, { 0, 0, 8 }, { 0, 0, -8 } },
		{ { 0, 0, -8 }, { 7, 0, -8 }, { 7, 0, 8 } },
	}
	expect(function()
		return geom3.validate(obs)
	end)["not"].toThrow()
	expect(#pts).toBe(8)
	expect(comparePolygonsAsPoints(pts, exp)).toBe(true) -- overlap of Y axis; larger number of - points
	geometry = geom2.fromPoints({ { -1, 8 }, { -2, 4 }, { -1, -8 }, { 7, -8 }, { 7, 8 } })
	obs = extrudeRotate({ segments = 8, angle = TAU / 4 }, geometry)
	pts = geom3.toPoints(obs)
	exp = {
		{ { 1, 0, -8 }, { 0, 0, -8 }, { 0.7071067811865476, 0.7071067811865475, -8 } },
		{ { 2, 0, 4 }, { 1, 0, -8 }, { 0.7071067811865476, 0.7071067811865475, -8 } },
		{
			{ 2, 0, 4 },
			{ 0.7071067811865476, 0.7071067811865475, -8 },
			{ 1.4142135623730951, 1.414213562373095, 4 },
		},
		{ { 1, 0, 8 }, { 2, 0, 4 }, { 1.4142135623730951, 1.414213562373095, 4 } },
		{
			{ 1, 0, 8 },
			{ 1.4142135623730951, 1.414213562373095, 4 },
			{ 0.7071067811865476, 0.7071067811865475, 8 },
		},
		{ { 0, 0, 8 }, { 1, 0, 8 }, { 0.7071067811865476, 0.7071067811865475, 8 } },
		{ { 0.7071067811865476, 0.7071067811865475, -8 }, { 0, 0, -8 }, { 0, 1, -8 } },
		{
			{ 1.4142135623730951, 1.414213562373095, 4 },
			{ 0.7071067811865476, 0.7071067811865475, -8 },
			{ 0, 1, -8 },
		},
		{ { 1.4142135623730951, 1.414213562373095, 4 }, { 0, 1, -8 }, { 0, 2, 4 } },
		{
			{ 0.7071067811865476, 0.7071067811865475, 8 },
			{ 1.4142135623730951, 1.414213562373095, 4 },
			{ 0, 2, 4 },
		},
		{ { 0.7071067811865476, 0.7071067811865475, 8 }, { 0, 2, 4 }, { 0, 1, 8 } },
		{ { 0, 0, 8 }, { 0.7071067811865476, 0.7071067811865475, 8 }, { 0, 1, 8 } },
		{ { 0, 1, -8 }, { 0, 0, -8 }, { 0, 0, 8 } },
		{ { 0, 0, 8 }, { 0, 1, 8 }, { 0, 2, 4 } },
		{ { 0, 2, 4 }, { 0, 1, -8 }, { 0, 0, 8 } },
		{ { 0, 0, 8 }, { 0, 0, -8 }, { 1, 0, -8 } },
		{ { 2, 0, 4 }, { 1, 0, 8 }, { 0, 0, 8 } },
		{ { 0, 0, 8 }, { 1, 0, -8 }, { 2, 0, 4 } },
	}
	expect(function()
		return geom3.validate(obs)
	end)["not"].toThrow()
	expect(#pts).toBe(18)
	expect(comparePolygonsAsPoints(pts, exp)).toBe(true)
end) -- TEST HOLES
