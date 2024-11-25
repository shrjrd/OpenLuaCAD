-- ROBLOX NOTE: no upstream
local JestGlobals = require("@DevPackages/JestGlobals")
local test, expect = JestGlobals.test, JestGlobals.expect

local geom3 = require("../geometries/geom3")
local cuboid = require("./init").cuboid
local comparePolygonsAsPoints = require("../../test/helpers/comparePolygonsAsPoints")
test("cuboid (defaults)", function()
	local obs = cuboid()
	local pts = geom3.toPoints(obs)
	local exp = {
		{ { -1, -1, -1 }, { -1, -1, 1 }, { -1, 1, 1 }, { -1, 1, -1 } },
		{ { 1, -1, -1 }, { 1, 1, -1 }, { 1, 1, 1 }, { 1, -1, 1 } },
		{ { -1, -1, -1 }, { 1, -1, -1 }, { 1, -1, 1 }, { -1, -1, 1 } },
		{ { -1, 1, -1 }, { -1, 1, 1 }, { 1, 1, 1 }, { 1, 1, -1 } },
		{ { -1, -1, -1 }, { -1, 1, -1 }, { 1, 1, -1 }, { 1, -1, -1 } },
		{ { -1, -1, 1 }, { 1, -1, 1 }, { 1, 1, 1 }, { -1, 1, 1 } },
	}
	expect(function()
		return geom3.validate(obs)
	end).never.toThrow()
	expect(#pts).toBe(6)
	expect(comparePolygonsAsPoints(pts, exp)).toBe(true)
end)
test("cuboid (options)", function()
	-- test center
	local obs = cuboid({ size = { 6, 6, 6 }, center = { 3, 5, 7 } })
	local pts = geom3.toPoints(obs)
	local exp = {
		{ { 0, 2, 4 }, { 0, 2, 10 }, { 0, 8, 10 }, { 0, 8, 4 } },
		{ { 6, 2, 4 }, { 6, 8, 4 }, { 6, 8, 10 }, { 6, 2, 10 } },
		{ { 0, 2, 4 }, { 6, 2, 4 }, { 6, 2, 10 }, { 0, 2, 10 } },
		{ { 0, 8, 4 }, { 0, 8, 10 }, { 6, 8, 10 }, { 6, 8, 4 } },
		{ { 0, 2, 4 }, { 0, 8, 4 }, { 6, 8, 4 }, { 6, 2, 4 } },
		{ { 0, 2, 10 }, { 6, 2, 10 }, { 6, 8, 10 }, { 0, 8, 10 } },
	}
	expect(function()
		return geom3.validate(obs)
	end).never.toThrow()
	expect(#pts).toBe(6)
	expect(comparePolygonsAsPoints(pts, exp)).toBe(true) -- test size
	obs = cuboid({ size = { 4.5, 1.5, 7 } })
	pts = geom3.toPoints(obs)
	exp = {
		{
			{ -2.25, -0.75, -3.5 },
			{ -2.25, -0.75, 3.5 },
			{ -2.25, 0.75, 3.5 },
			{ -2.25, 0.75, -3.5 },
		},
		{ { 2.25, -0.75, -3.5 }, { 2.25, 0.75, -3.5 }, { 2.25, 0.75, 3.5 }, { 2.25, -0.75, 3.5 } },
		{
			{ -2.25, -0.75, -3.5 },
			{ 2.25, -0.75, -3.5 },
			{ 2.25, -0.75, 3.5 },
			{ -2.25, -0.75, 3.5 },
		},
		{ { -2.25, 0.75, -3.5 }, { -2.25, 0.75, 3.5 }, { 2.25, 0.75, 3.5 }, { 2.25, 0.75, -3.5 } },
		{
			{ -2.25, -0.75, -3.5 },
			{ -2.25, 0.75, -3.5 },
			{ 2.25, 0.75, -3.5 },
			{ 2.25, -0.75, -3.5 },
		},
		{ { -2.25, -0.75, 3.5 }, { 2.25, -0.75, 3.5 }, { 2.25, 0.75, 3.5 }, { -2.25, 0.75, 3.5 } },
	}
	expect(function()
		return geom3.validate(obs)
	end).never.toThrow()
	expect(#pts).toBe(6)
	expect(comparePolygonsAsPoints(pts, exp)).toBe(true)
end)
test("cuboid (zero size)", function()
	local obs = cuboid({ size = { 1, 1, 0 } })
	local pts = geom3.toPoints(obs)
	expect(function()
		return geom3.validate(obs)
	end).never.toThrow()
	expect(#pts).toBe(0)
end)
