-- ROBLOX NOTE: no upstream
local JestGlobals = require("@DevPackages/JestGlobals")
local test, expect = JestGlobals.test, JestGlobals.expect

local comparePoints, comparePolygonsAsPoints
do
	local ref = require("../../../test/helpers")
	comparePoints, comparePolygonsAsPoints = ref.comparePoints, ref.comparePolygonsAsPoints
end
local geom2, geom3, path2
do
	local ref = require("../../geometries")
	geom2, geom3, path2 = ref.geom2, ref.geom3, ref.path2
end
local center, centerX, centerY, centerZ
do
	local ref = require("./init")
	center, centerX, centerY, centerZ = ref.center, ref.centerX, ref.centerY, ref.centerZ
end
test("center: centering of a path2 produces expected changes to points", function()
	local geometry = path2.fromPoints({}, { { 5, 0 }, { 0, 3 }, { -1, 0 } }) -- center about X
	local centered = center({ axes = { true, false, false } }, geometry)
	local pts = path2.toPoints(centered)
	local exp = { { 3, 0 }, { -2, 3 }, { -3, 0 } }
	expect(function()
		return path2.validate(centered)
	end)["not"].toThrow()
	expect(comparePoints(pts, exp)).toBe(true)
	centered = centerX(geometry)
	pts = path2.toPoints(centered)
	expect(function()
		return path2.validate(centered)
	end)["not"].toThrow()
	expect(comparePoints(pts, exp)).toBe(true)
end)
test("center: centering of a geom2 produces expected changes to points", function()
	local geometry = geom2.fromPoints({ { 0, 0 }, { 10, 0 }, { 0, 10 } }) -- center about Y
	local centered = center({ axes = { false, true, false } }, geometry)
	local pts = geom2.toPoints(centered)
	local exp = { { 0, -5 }, { 10, -5 }, { 0, 5 } }
	expect(function()
		return geom2.validate(centered)
	end)["not"].toThrow()
	expect(comparePoints(pts, exp)).toBe(true)
	centered = centerY(geometry)
	pts = geom2.toPoints(centered)
	expect(function()
		return geom2.validate(centered)
	end)["not"].toThrow()
	expect(comparePoints(pts, exp)).toBe(true)
end)
test("center: centering of a geom3 produces expected changes to polygons", function()
	local points = {
		{ { -2, -7, -12 }, { -2, -7, 18 }, { -2, 13, 18 }, { -2, 13, -12 } },
		{ { 8, -7, -12 }, { 8, 13, -12 }, { 8, 13, 18 }, { 8, -7, 18 } },
		{ { -2, -7, -12 }, { 8, -7, -12 }, { 8, -7, 18 }, { -2, -7, 18 } },
		{ { -2, 13, -12 }, { -2, 13, 18 }, { 8, 13, 18 }, { 8, 13, -12 } },
		{ { -2, -7, -12 }, { -2, 13, -12 }, { 8, 13, -12 }, { 8, -7, -12 } },
		{ { -2, -7, 18 }, { 8, -7, 18 }, { 8, 13, 18 }, { -2, 13, 18 } },
	}
	local geometry = geom3.fromPoints(points) -- center about X
	local centered = center({ axes = { true, false, false } }, geometry)
	local pts = geom3.toPoints(centered)
	local exp = {
		{ { -5, -7, -12 }, { -5, -7, 18 }, { -5, 13, 18 }, { -5, 13, -12 } },
		{ { 5, -7, -12 }, { 5, 13, -12 }, { 5, 13, 18 }, { 5, -7, 18 } },
		{ { -5, -7, -12 }, { 5, -7, -12 }, { 5, -7, 18 }, { -5, -7, 18 } },
		{ { -5, 13, -12 }, { -5, 13, 18 }, { 5, 13, 18 }, { 5, 13, -12 } },
		{ { -5, -7, -12 }, { -5, 13, -12 }, { 5, 13, -12 }, { 5, -7, -12 } },
		{ { -5, -7, 18 }, { 5, -7, 18 }, { 5, 13, 18 }, { -5, 13, 18 } },
	}
	expect(function()
		return geom3.validate(centered)
	end)["not"].toThrow()
	expect(comparePolygonsAsPoints(pts, exp)).toBe(true)
	centered = centerX(geometry)
	pts = geom3.toPoints(centered)
	expect(function()
		return geom3.validate(centered)
	end)["not"].toThrow()
	expect(comparePolygonsAsPoints(pts, exp)).toBe(true) -- center about Y
	centered = center({ axes = { false, true, false } }, geometry)
	pts = geom3.toPoints(centered)
	exp = {
		{ { -2, -10, -12 }, { -2, -10, 18 }, { -2, 10, 18 }, { -2, 10, -12 } },
		{ { 8, -10, -12 }, { 8, 10, -12 }, { 8, 10, 18 }, { 8, -10, 18 } },
		{ { -2, -10, -12 }, { 8, -10, -12 }, { 8, -10, 18 }, { -2, -10, 18 } },
		{ { -2, 10, -12 }, { -2, 10, 18 }, { 8, 10, 18 }, { 8, 10, -12 } },
		{ { -2, -10, -12 }, { -2, 10, -12 }, { 8, 10, -12 }, { 8, -10, -12 } },
		{ { -2, -10, 18 }, { 8, -10, 18 }, { 8, 10, 18 }, { -2, 10, 18 } },
	}
	expect(function()
		return geom3.validate(centered)
	end)["not"].toThrow()
	expect(comparePolygonsAsPoints(pts, exp)).toBe(true)
	centered = centerY(geometry)
	pts = geom3.toPoints(centered)
	expect(function()
		return geom3.validate(centered)
	end)["not"].toThrow()
	expect(comparePolygonsAsPoints(pts, exp)).toBe(true) -- center about Z
	centered = center({ axes = { false, false, true } }, geometry)
	pts = geom3.toPoints(centered)
	exp = {
		{ { -2, -7, -15 }, { -2, -7, 15 }, { -2, 13, 15 }, { -2, 13, -15 } },
		{ { 8, -7, -15 }, { 8, 13, -15 }, { 8, 13, 15 }, { 8, -7, 15 } },
		{ { -2, -7, -15 }, { 8, -7, -15 }, { 8, -7, 15 }, { -2, -7, 15 } },
		{ { -2, 13, -15 }, { -2, 13, 15 }, { 8, 13, 15 }, { 8, 13, -15 } },
		{ { -2, -7, -15 }, { -2, 13, -15 }, { 8, 13, -15 }, { 8, -7, -15 } },
		{ { -2, -7, 15 }, { 8, -7, 15 }, { 8, 13, 15 }, { -2, 13, 15 } },
	}
	expect(function()
		return geom3.validate(centered)
	end)["not"].toThrow()
	expect(comparePolygonsAsPoints(pts, exp)).toBe(true)
	centered = centerZ(geometry)
	pts = geom3.toPoints(centered)
	expect(function()
		return geom3.validate(centered)
	end)["not"].toThrow()
	expect(comparePolygonsAsPoints(pts, exp)).toBe(true)
end)
test("center: centering of multiple objects produces expected changes", function()
	local junk = "hello"
	local geometry1 = path2.fromPoints({}, { { -5, 5 }, { 5, 5 }, { -5, -5 }, { 10, -5 } })
	local geometry2 = geom2.fromPoints({ { -5, -5 }, { 0, 5 }, { 10, -5 } })
	local centered = center({ axes = { true, true, false }, relativeTo = { 10, 15, 0 } }, junk, geometry1, geometry2)
	expect(centered[
		1 --[[ ROBLOX adaptation: added 1 to array index ]]
	]).toBe(junk)
	local pts1 = path2.toPoints(centered[
		2 --[[ ROBLOX adaptation: added 1 to array index ]]
	])
	local exp1 = { { 2.5, 20 }, { 12.5, 20 }, { 2.5, 10 }, { 17.5, 10 } }
	expect(function()
		return path2.validate(centered[
			2 --[[ ROBLOX adaptation: added 1 to array index ]]
		])
	end)["not"].toThrow()
	expect(comparePoints(pts1, exp1)).toBe(true)
	local pts2 = geom2.toPoints(centered[
		3 --[[ ROBLOX adaptation: added 1 to array index ]]
	])
	local exp2 = { { 2.5, 10 }, { 7.5, 20 }, { 17.5, 10 } }
	expect(function()
		return geom2.validate(centered[
			3 --[[ ROBLOX adaptation: added 1 to array index ]]
		])
	end)["not"].toThrow()
	expect(comparePoints(pts2, exp2)).toBe(true)
end)
