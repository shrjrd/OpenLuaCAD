-- ROBLOX NOTE: no upstream
local JestGlobals = require("@DevPackages/JestGlobals")
local test, expect = JestGlobals.test, JestGlobals.expect

local polyhedron = require("./init").polyhedron
local geom3 = require("../geometries/geom3")
local comparePolygonsAsPoints = require("../../test/helpers/comparePolygonsAsPoints")
test("polyhedron (points and faces)", function()
	-- points and faces form a cube
	local points = {
		{ -1, -1, -1 },
		{ -1, -1, 1 },
		{ -1, 1, 1 },
		{ -1, 1, -1 },
		{ 1, -1, 1 },
		{ 1, -1, -1 },
		{ 1, 1, -1 },
		{ 1, 1, 1 },
	}
	local faces = {
		{ 0, 1, 2, 3 },
		{ 5, 6, 7, 4 },
		{ 0, 5, 4, 1 },
		{ 3, 2, 7, 6 },
		{ 0, 3, 6, 5 },
		{
			1,
			4,
			7,
			2,
		},
	}
	local colors = {
		{ 0, 0, 0, 1 },
		{ 1, 0, 0, 1 },
		{ 0, 1, 0, 1 },
		{ 0, 0, 1, 1 },
		{ 0.5, 0.5, 0.5, 1 },
		{
			1,
			1,
			1,
			1,
		},
	}
	local obs = polyhedron({ points = points, faces = faces, colors = colors })
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
	end)["not"].toThrow()
	expect(#pts).toEqual(6)
	expect(comparePolygonsAsPoints(pts, exp)).toBe(true) -- test orientation
	points = { { 10, 10, 0 }, { 10, -10, 0 }, { -10, -10, 0 }, { -10, 10, 0 }, { 0, 0, 10 } }
	faces = { { 0, 1, 4 }, { 1, 2, 4 }, { 2, 3, 4 }, { 3, 0, 4 }, { 1, 0, 3 }, { 2, 1, 3 } }
	obs = polyhedron({ points = points, faces = faces, orientation = "inward" })
	pts = geom3.toPoints(obs)
	exp = {
		{ { 0, 0, 10 }, { 10, -10, 0 }, { 10, 10, 0 } },
		{ { 0, 0, 10 }, { -10, -10, 0 }, { 10, -10, 0 } },
		{ { 0, 0, 10 }, { -10, 10, 0 }, { -10, -10, 0 } },
		{ { 0, 0, 10 }, { 10, 10, 0 }, { -10, 10, 0 } },
		{ { -10, 10, 0 }, { 10, 10, 0 }, { 10, -10, 0 } },
		{ { -10, 10, 0 }, { 10, -10, 0 }, { -10, -10, 0 } },
	}
	expect(function()
		return geom3.validate(obs)
	end)["not"].toThrow()
	expect(#pts).toEqual(6)
	expect(comparePolygonsAsPoints(pts, exp)).toBe(true)
end)
