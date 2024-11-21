-- ROBLOX NOTE: no upstream
local JestGlobals = require("@DevPackages/JestGlobals")
local test, expect = JestGlobals.test, JestGlobals.expect

local TAU = require("../../maths/constants").TAU
local geom2, geom3, path2
do
	local ref = require("../../geometries")
	geom2, geom3, path2 = ref.geom2, ref.geom3, ref.path2
end
local rotate, rotateX, rotateY, rotateZ
do
	local ref = require("./init")
	rotate, rotateX, rotateY, rotateZ = ref.rotate, ref.rotateX, ref.rotateY, ref.rotateZ
end
local comparePoints, comparePolygonsAsPoints
do
	local ref = require("../../../test/helpers")
	comparePoints, comparePolygonsAsPoints = ref.comparePoints, ref.comparePolygonsAsPoints
end
test("rotate: rotating of a path2 produces expected changes to points", function()
	local geometry = path2.fromPoints({}, { { 1, 0 }, { 0, 1 }, { -1, 0 } }) -- rotate about Z
	local rotated = rotate({ 0, 0, TAU / 4 }, geometry)
	local obs = path2.toPoints(rotated)
	local exp = { { 0, 1 }, { -1, 0 }, { -0, -1 } }
	expect(comparePoints(obs, exp)).toBe(true)
	rotated = rotateZ(TAU / 4, geometry)
	obs = path2.toPoints(rotated)
	expect(function()
		return path2.validate(rotated)
	end)["not"].toThrow()
	expect(comparePoints(obs, exp)).toBe(true)
end)
test("rotate: rotating of a geom2 produces expected changes to points", function()
	local geometry = geom2.fromPoints({ { 0, 0 }, { 1, 0 }, { 0, 1 } }) -- rotate about Z
	local rotated = rotate({ 0, 0, -TAU / 4 }, geometry)
	local obs = geom2.toPoints(rotated)
	local exp = { { 0, 0 }, { 0, -1 }, { 1, 0 } }
	expect(function()
		return geom2.validate(rotated)
	end)["not"].toThrow()
	expect(comparePoints(obs, exp)).toBe(true)
	rotated = rotateZ(-TAU / 4, geometry)
	obs = geom2.toPoints(rotated)
	expect(function()
		return geom2.validate(rotated)
	end)["not"].toThrow()
	expect(comparePoints(obs, exp)).toBe(true)
end)
test("rotate: rotating of a geom3 produces expected changes to polygons", function()
	local points = {
		{ { -2, -7, -12 }, { -2, -7, 18 }, { -2, 13, 18 }, { -2, 13, -12 } },
		{ { 8, -7, -12 }, { 8, 13, -12 }, { 8, 13, 18 }, { 8, -7, 18 } },
		{ { -2, -7, -12 }, { 8, -7, -12 }, { 8, -7, 18 }, { -2, -7, 18 } },
		{ { -2, 13, -12 }, { -2, 13, 18 }, { 8, 13, 18 }, { 8, 13, -12 } },
		{ { -2, -7, -12 }, { -2, 13, -12 }, { 8, 13, -12 }, { 8, -7, -12 } },
		{ { -2, -7, 18 }, { 8, -7, 18 }, { 8, 13, 18 }, { -2, 13, 18 } },
	}
	local geometry = geom3.fromPoints(points) -- rotate about X
	local rotated = rotate({ TAU / 4 }, geometry)
	local obs = geom3.toPoints(rotated)
	local exp = {
		{
			{ -2, 12, -7.000000000000001 },
			{ -2, -18, -6.999999999999999 },
			{ -2, -18, 13.000000000000002 },
			{ -2, 12, 13 },
		},
		{
			{ 8, 12, -7.000000000000001 },
			{ 8, 12, 13 },
			{ 8, -18, 13.000000000000002 },
			{ 8, -18, -6.999999999999999 },
		},
		{
			{ -2, 12, -7.000000000000001 },
			{ 8, 12, -7.000000000000001 },
			{ 8, -18, -6.999999999999999 },
			{ -2, -18, -6.999999999999999 },
		},
		{
			{ -2, 12, 13 },
			{ -2, -18, 13.000000000000002 },
			{ 8, -18, 13.000000000000002 },
			{
				8,
				12,
				13,
			},
		},
		{
			{ -2, 12, -7.000000000000001 },
			{ -2, 12, 13 },
			{ 8, 12, 13 },
			{
				8,
				12,
				-7.000000000000001,
			},
		},
		{
			{ -2, -18, -6.999999999999999 },
			{ 8, -18, -6.999999999999999 },
			{ 8, -18, 13.000000000000002 },
			{ -2, -18, 13.000000000000002 },
		},
	}
	expect(function()
		return geom3.validate(rotated)
	end)["not"].toThrow()
	expect(comparePolygonsAsPoints(obs, exp)).toBe(true)
	rotated = rotateX(TAU / 4, geometry)
	obs = geom3.toPoints(rotated)
	expect(function()
		return geom3.validate(rotated)
	end)["not"].toThrow()
	expect(comparePolygonsAsPoints(obs, exp)).toBe(true) -- rotate about Y
	rotated = rotate({ 0, -TAU / 4 }, geometry)
	obs = geom3.toPoints(rotated)
	exp = {
		{
			{ 12, -7, -2.000000000000001 },
			{ -18, -7, -1.999999999999999 },
			{ -18, 13, -1.999999999999999 },
			{ 12, 13, -2.000000000000001 },
		},
		{
			{ 12, -7, 7.999999999999999 },
			{ 12, 13, 7.999999999999999 },
			{ -18, 13, 8.000000000000002 },
			{ -18, -7, 8.000000000000002 },
		},
		{
			{ 12, -7, -2.000000000000001 },
			{ 12, -7, 7.999999999999999 },
			{ -18, -7, 8.000000000000002 },
			{ -18, -7, -1.999999999999999 },
		},
		{
			{ 12, 13, -2.000000000000001 },
			{ -18, 13, -1.999999999999999 },
			{ -18, 13, 8.000000000000002 },
			{ 12, 13, 7.999999999999999 },
		},
		{
			{ 12, -7, -2.000000000000001 },
			{ 12, 13, -2.000000000000001 },
			{ 12, 13, 7.999999999999999 },
			{ 12, -7, 7.999999999999999 },
		},
		{
			{ -18, -7, -1.999999999999999 },
			{ -18, -7, 8.000000000000002 },
			{ -18, 13, 8.000000000000002 },
			{ -18, 13, -1.999999999999999 },
		},
	}
	expect(function()
		return geom3.validate(rotated)
	end)["not"].toThrow()
	expect(comparePolygonsAsPoints(obs, exp)).toBe(true)
	rotated = rotateY(-TAU / 4, geometry)
	obs = geom3.toPoints(rotated)
	expect(comparePolygonsAsPoints(obs, exp)).toBe(true) -- rotate about Z
	rotated = rotate({ 0, 0, TAU / 2 }, geometry)
	obs = geom3.toPoints(rotated)
	exp = {
		{
			{ 2.000000000000001, 7, -12 },
			{ 2.000000000000001, 7, 18 },
			{ 1.9999999999999984, -13, 18 },
			{ 1.9999999999999984, -13, -12 },
		},
		{
			{ -7.999999999999999, 7.000000000000001, -12 },
			{ -8.000000000000002, -12.999999999999998, -12 },
			{ -8.000000000000002, -12.999999999999998, 18 },
			{ -7.999999999999999, 7.000000000000001, 18 },
		},
		{
			{ 2.000000000000001, 7, -12 },
			{ -7.999999999999999, 7.000000000000001, -12 },
			{ -7.999999999999999, 7.000000000000001, 18 },
			{ 2.000000000000001, 7, 18 },
		},
		{
			{ 1.9999999999999984, -13, -12 },
			{ 1.9999999999999984, -13, 18 },
			{ -8.000000000000002, -12.999999999999998, 18 },
			{ -8.000000000000002, -12.999999999999998, -12 },
		},
		{
			{ 2.000000000000001, 7, -12 },
			{ 1.9999999999999984, -13, -12 },
			{ -8.000000000000002, -12.999999999999998, -12 },
			{ -7.999999999999999, 7.000000000000001, -12 },
		},
		{
			{ 2.000000000000001, 7, 18 },
			{ -7.999999999999999, 7.000000000000001, 18 },
			{ -8.000000000000002, -12.999999999999998, 18 },
			{ 1.9999999999999984, -13, 18 },
		},
	}
	expect(function()
		return geom3.validate(rotated)
	end)["not"].toThrow()
	expect(comparePolygonsAsPoints(obs, exp)).toBe(true)
	rotated = rotateZ(TAU / 2, geometry)
	obs = geom3.toPoints(rotated)
	expect(function()
		return geom3.validate(rotated)
	end)["not"].toThrow()
	expect(comparePolygonsAsPoints(obs, exp)).toBe(true)
end)
test("rotate: rotating of multiple objects produces expected changes", function()
	local junk = "hello"
	local geometry1 = path2.fromPoints({}, { { -5, 5 }, { 5, 5 }, { -5, -5 }, { 10, -5 } })
	local geometry2 = geom2.fromPoints({ { -5, -5 }, { 0, 5 }, { 10, -5 } })
	local rotated = rotate({ 0, 0, TAU / 4 }, junk, geometry1, geometry2)
	expect(rotated[
		1 --[[ ROBLOX adaptation: added 1 to array index ]]
	]).toBe(junk)
	local obs1 = path2.toPoints(rotated[
		2 --[[ ROBLOX adaptation: added 1 to array index ]]
	])
	local exp1 = { { -5, -5 }, { -5, 5 }, { 5, -5 }, { 5.000000000000001, 10 } }
	expect(function()
		return path2.validate(rotated[
			2 --[[ ROBLOX adaptation: added 1 to array index ]]
		])
	end)["not"].toThrow()
	expect(comparePoints(obs1, exp1)).toBe(true)
	local obs2 = geom2.toPoints(rotated[
		3 --[[ ROBLOX adaptation: added 1 to array index ]]
	])
	local exp2 = { { 5, -5 }, { -5, 3.061616997868383e-16 }, { 5.000000000000001, 10 } }
	expect(function()
		return geom2.validate(rotated[
			3 --[[ ROBLOX adaptation: added 1 to array index ]]
		])
	end)["not"].toThrow()
	expect(comparePoints(obs2, exp2)).toBe(true)
end)
