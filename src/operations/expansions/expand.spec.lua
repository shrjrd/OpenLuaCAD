-- ROBLOX NOTE: no upstream
local JestGlobals = require("@DevPackages/JestGlobals")
local test, expect = JestGlobals.test, JestGlobals.expect

local comparePoints, nearlyEqual
do
	local ref = require("../../../test/helpers")
	comparePoints, nearlyEqual = ref.comparePoints, ref.nearlyEqual
end
local geom2, geom3, path2
do
	local ref = require("../../geometries")
	geom2, geom3, path2 = ref.geom2, ref.geom3, ref.path2
end
local measureBoundingBox = require("../../measurements/measureBoundingBox")
local area = require("../../maths/utils/area")
local TAU = require("../../maths/constants").TAU
local sphere = require("../../primitives/sphere")
local expand = require("./init").expand
test("expand: edge-expanding a straight line produces rectangle", function()
	local points = { { 0, 0 }, { 0, 10 } }
	local linePath2 = path2.fromPoints({ closed = false }, points)
	local expandedPathGeom2 = expand({ delta = 2, corners = "edge", segments = 8 }, linePath2)
	local expandedPoints = geom2.toPoints(expandedPathGeom2)
	expect(function()
		return geom2.validate(expandedPathGeom2)
	end)["not"].toThrow()
	expect(area(expandedPoints)).toBe(40)
	expect(comparePoints(measureBoundingBox(expandedPathGeom2), { { -2, 0, 0 }, { 2, 10, 0 } })).toBe(true)
end)
test("expand: edge-expanding a bent line produces expected geometry", function()
	local points = { { 0, 0 }, { 0, 10 }, { -5, 10 } }
	local linePath2 = path2.fromPoints({ closed = false }, points)
	local expandedPathGeom2 = expand({ delta = 2, corners = "edge", segments = 8 }, linePath2)
	local expandedPoints = geom2.toPoints(expandedPathGeom2)
	expect(function()
		return geom2.validate(expandedPathGeom2)
	end)["not"].toThrow()
	expect(area(expandedPoints)).toBe(60)
	local boundingBox = measureBoundingBox(expandedPathGeom2)
	expect(comparePoints(boundingBox, { { -5, 0, 0 }, { 2, 12, 0 } })).toBe(true)
end)
test("expand: edge-expanding a bent line, reversed points, produces expected geometry", function()
	local points = { { -5, 10 }, { 0, 10 }, { 0, 0 } }
	local linePath2 = path2.fromPoints({ closed = false }, points)
	local expandedPathGeom2 = expand({ delta = 2, corners = "edge", segments = 8 }, linePath2)
	local expandedPoints = geom2.toPoints(expandedPathGeom2)
	expect(function()
		return geom2.validate(expandedPathGeom2)
	end)["not"].toThrow()
	expect(area(expandedPoints)).toBe(60)
	local boundingBox = measureBoundingBox(expandedPathGeom2)
	expect(comparePoints(boundingBox, { { -5, 0, 0 }, { 2, 12, 0 } })).toBe(true)
end)
test("expand: round-expanding a bent line produces expected geometry", function()
	local delta = 2
	local points = { { 0, 0 }, { 0, 10 }, { -5, 10 } }
	local linePath2 = path2.fromPoints({ closed = false }, points)
	local expandedPathGeom2 = expand({ delta = delta, corners = "round", segments = 128 }, linePath2)
	local expandedPoints = geom2.toPoints(expandedPathGeom2)
	expect(function()
		return geom2.validate(expandedPathGeom2)
	end)["not"].toThrow()
	local expectedArea = 56 + TAU * delta * 1.25 -- shape will have 1 and 1/4 circles
	nearlyEqual(area(expandedPoints), expectedArea, 0.01, "Measured area should be pretty close")
	local boundingBox = measureBoundingBox(expandedPathGeom2)
	expect(comparePoints(boundingBox, { { -7, -2, 0 }, { 2, 12, 0 } })).toBe(true)
end)
test("expand: chamfer-expanding a bent line produces expected geometry", function()
	local delta = 2
	local points = { { 0, 0 }, { 0, 10 }, { -5, 10 } }
	local linePath2 = path2.fromPoints({ closed = false }, points)
	local expandedPathGeom2 = expand({ delta = delta, corners = "chamfer", segments = 8 }, linePath2)
	local expandedPoints = geom2.toPoints(expandedPathGeom2)
	expect(function()
		return geom2.validate(expandedPathGeom2)
	end)["not"].toThrow()
	expect(area(expandedPoints)).toBe(58)
	local boundingBox = measureBoundingBox(expandedPathGeom2)
	expect(comparePoints(boundingBox, { { -5, 0, 0 }, { 2, 12, 0 } })).toBe(true)
end)
test("expand: expanding of a geom2 produces expected changes to points", function()
	local geometry = geom2.fromPoints({ { -8, -8 }, { 8, -8 }, { 8, 8 }, { -8, 8 } })
	local obs = expand({ delta = 2, corners = "round", segments = 8 }, geometry)
	local pts = geom2.toPoints(obs)
	local exp = {
		{ -9.414213562373096, -9.414213562373096 },
		{ -8, -10 },
		{ 8, -10 },
		{ 9.414213562373096, -9.414213562373096 },
		{ 10, -8 },
		{ 10, 8 },
		{ 9.414213562373096, 9.414213562373096 },
		{ 8, 10 },
		{ -8, 10 },
		{ -9.414213562373096, 9.414213562373096 },
		{ -10, 8 },
		{ -10, -8 },
	}
	expect(function()
		return geom2.validate(obs)
	end)["not"].toThrow()
	expect(#pts).toBe(12)
	expect(comparePoints(pts, exp)).toBe(true)
end)
test("expand: expanding of a geom3 produces expected changes to polygons", function()
	local polygonsAsPoints = {
		{ { -5, -5, -5 }, { -5, -5, 15 }, { -5, 15, 15 }, { -5, 15, -5 } },
		{ { 15, -5, -5 }, { 15, 15, -5 }, { 15, 15, 15 }, { 15, -5, 15 } },
		{ { -5, -5, -5 }, { 15, -5, -5 }, { 15, -5, 15 }, { -5, -5, 15 } },
		{ { -5, 15, -5 }, { -5, 15, 15 }, { 15, 15, 15 }, { 15, 15, -5 } },
		{ { -5, -5, -5 }, { -5, 15, -5 }, { 15, 15, -5 }, { 15, -5, -5 } },
		{ { -5, -5, 15 }, { 15, -5, 15 }, { 15, 15, 15 }, { -5, 15, 15 } },
	}
	local geometry = geom3.fromPoints(polygonsAsPoints)
	local obs = expand({ delta = 2, corners = "round", segments = 8 }, geometry)
	local pts = geom3.toPoints(obs)
	local exp0 = { { -7, -5, -5 }, { -7, -5, 15 }, { -7, 15, 15 }, { -7, 15, -5 } }
	local exp61 = {
		{ 15, -7, 15 },
		{ 16.414213562373096, -6.414213562373095, 15 },
		{ 16, -6.414213562373095, 16 },
	}
	t.notThrows:skip(function()
		return geom3.validate(obs)
	end)
	expect(#pts).toBe(62)
	expect(comparePoints(
		pts[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		],
		exp0
	)).toBe(true)
	expect(comparePoints(
		pts[
			62 --[[ ROBLOX adaptation: added 1 to array index ]]
		],
		exp61
	)).toBe(true)
	local geometry2 = sphere({ radius = 5, segments = 8 })
	local obs2 = expand({ delta = 5 }, geometry2)
	local pts2 = geom3.toPoints(obs2)
	t.notThrows:skip(function()
		return geom3.validate(obs2)
	end)
	expect(#pts2).toBe(864)
end)
test("expand (options): offsetting of a complex geom2 produces expected offset geom2", function()
	local geometry = geom2.create({
		{ { -75, 75 }, { -75, -75 } },
		{ { -75, -75 }, { 75, -75 } },
		{ { 75, -75 }, { 75, 75 } },
		{ { -40, 75 }, { -75, 75 } },
		{ { 75, 75 }, { 40, 75 } },
		{ { 40, 75 }, { 40, 0 } },
		{ { 40, 0 }, { -40, 0 } },
		{ { -40, 0 }, { -40, 75 } },
		{ { 15, -10 }, { 15, -40 } },
		{ { -15, -10 }, { 15, -10 } },
		{ { -15, -40 }, { -15, -10 } },
		{ { -8, -40 }, { -15, -40 } },
		{ { 15, -40 }, { 8, -40 } },
		{ { -8, -25 }, { -8, -40 } },
		{ { 8, -25 }, { -8, -25 } },
		{ { 8, -40 }, { 8, -25 } },
		{ { -2, -15 }, { -2, -19 } },
		{ { -2, -19 }, { 2, -19 } },
		{ { 2, -19 }, { 2, -15 } },
		{ { 2, -15 }, { -2, -15 } },
	}) -- expand +
	local obs = expand({ delta = 2, corners = "edge" }, geometry)
	local pts = geom2.toPoints(obs)
	local exp = {
		{ 77, -77 },
		{ 77, 77 },
		{ 38, 77 },
		{ 38, 2 },
		{ -38, 2 },
		{ -37.99999999999999, 77 },
		{ -77, 77 },
		{ 16.999999999999996, -42 },
		{ 6, -42 },
		{ 6, -27 },
		{ -6, -27 },
		{ -6.000000000000001, -42 },
		{ -17, -42 },
		{ -16.999999999999996, -8 },
		{ 17, -8.000000000000004 },
		{ -4, -21 },
		{ 3.9999999999999996, -21 },
		{ 4, -13 },
		{ -4, -13 },
		{ -77, -77 },
	}
	expect(function()
		return geom2.validate(obs)
	end)["not"].toThrow()
	expect(#pts).toBe(20)
	expect(comparePoints(pts, exp)).toBe(true)
end)
