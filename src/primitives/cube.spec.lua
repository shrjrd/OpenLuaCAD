-- ROBLOX NOTE: no upstream
local JestGlobals = require("@DevPackages/JestGlobals")
local test, expect = JestGlobals.test, JestGlobals.expect

local geom3 = require("../geometries/geom3")
local cube = require("./init").cube
local comparePolygonsAsPoints = require("../../test/helpers/comparePolygonsAsPoints")
test("cube (defaults)", function()
	local obs = cube()
	local pts = geom3.toPoints(obs)
	expect(function()
		return geom3.validate(obs)
	end)["not"].toThrow()
	expect(#pts).toBe(6)
end)
test("cube (options)", function()
	-- test center
	local obs = cube({ size = 7, center = { 6.5, 6.5, 6.5 } })
	local pts = geom3.toPoints(obs)
	local exp = {
		{ { 3, 3, 3 }, { 3, 3, 10 }, { 3, 10, 10 }, { 3, 10, 3 } },
		{ { 10, 3, 3 }, { 10, 10, 3 }, { 10, 10, 10 }, { 10, 3, 10 } },
		{ { 3, 3, 3 }, { 10, 3, 3 }, { 10, 3, 10 }, { 3, 3, 10 } },
		{ { 3, 10, 3 }, { 3, 10, 10 }, { 10, 10, 10 }, { 10, 10, 3 } },
		{ { 3, 3, 3 }, { 3, 10, 3 }, { 10, 10, 3 }, { 10, 3, 3 } },
		{ { 3, 3, 10 }, { 10, 3, 10 }, { 10, 10, 10 }, { 3, 10, 10 } },
	}
	expect(function()
		return geom3.validate(obs)
	end)["not"].toThrow()
	expect(#pts).toBe(6)
	expect(comparePolygonsAsPoints(pts, exp)).toBe(true) -- test size
	obs = cube({ size = 7 })
	pts = geom3.toPoints(obs)
	exp = {
		{ { -3.5, -3.5, -3.5 }, { -3.5, -3.5, 3.5 }, { -3.5, 3.5, 3.5 }, { -3.5, 3.5, -3.5 } },
		{ { 3.5, -3.5, -3.5 }, { 3.5, 3.5, -3.5 }, { 3.5, 3.5, 3.5 }, { 3.5, -3.5, 3.5 } },
		{ { -3.5, -3.5, -3.5 }, { 3.5, -3.5, -3.5 }, { 3.5, -3.5, 3.5 }, { -3.5, -3.5, 3.5 } },
		{ { -3.5, 3.5, -3.5 }, { -3.5, 3.5, 3.5 }, { 3.5, 3.5, 3.5 }, { 3.5, 3.5, -3.5 } },
		{ { -3.5, -3.5, -3.5 }, { -3.5, 3.5, -3.5 }, { 3.5, 3.5, -3.5 }, { 3.5, -3.5, -3.5 } },
		{ { -3.5, -3.5, 3.5 }, { 3.5, -3.5, 3.5 }, { 3.5, 3.5, 3.5 }, { -3.5, 3.5, 3.5 } },
	}
	expect(function()
		return geom3.validate(obs)
	end)["not"].toThrow()
	expect(#pts).toBe(6)
	expect(comparePolygonsAsPoints(pts, exp)).toBe(true)
end)
test("cube (zero size)", function()
	local obs = cube({ size = 0 })
	local pts = geom3.toPoints(obs)
	expect(function()
		return geom3.validate(obs)
	end)["not"].toThrow()
	expect(#pts).toBe(0)
end)
