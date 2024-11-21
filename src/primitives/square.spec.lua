-- ROBLOX NOTE: no upstream
local JestGlobals = require("@DevPackages/JestGlobals")
local test, expect = JestGlobals.test, JestGlobals.expect

local square = require("./init").square
local geom2 = require("../geometries/geom2")
local comparePoints = require("../../test/helpers/comparePoints")
test("square (defaults)", function()
	local geometry = square()
	local obs = geom2.toPoints(geometry)
	expect(function()
		return geom2.validate(geometry)
	end)["not"].toThrow()
	expect(#obs).toEqual(4)
end)
test("square (options)", function()
	-- test center
	local obs = square({ size = 7, center = { 6.5, 6.5 } })
	local pts = geom2.toPoints(obs)
	local exp = { { 3, 3 }, { 10, 3 }, { 10, 10 }, { 3, 10 } }
	expect(function()
		return geom2.validate(obs)
	end)["not"].toThrow()
	expect(#pts).toBe(4)
	expect(comparePoints(pts, exp)).toBe(true) -- test size
	obs = square({ size = 7 })
	pts = geom2.toPoints(obs)
	exp = { { -3.5, -3.5 }, { 3.5, -3.5 }, { 3.5, 3.5 }, { -3.5, 3.5 } }
	expect(function()
		return geom2.validate(obs)
	end)["not"].toThrow()
	expect(#pts).toBe(4)
	expect(comparePoints(pts, exp)).toBe(true)
end)
test("square (zero size)", function()
	local geometry = square({ size = 0 })
	local obs = geom2.toPoints(geometry)
	expect(function()
		return geom2.validate(geometry)
	end)["not"].toThrow()
	expect(#obs).toBe(0)
end)
