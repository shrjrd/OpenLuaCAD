-- ROBLOX NOTE: no upstream
local JestGlobals = require("@DevPackages/JestGlobals")
local test, expect = JestGlobals.test, JestGlobals.expect

local roundedRectangle = require("./init").roundedRectangle
local geom2 = require("../geometries/geom2")
local comparePoints = require("../../test/helpers/comparePoints")
test("roundedRectangle (defaults)", function()
	local geometry = roundedRectangle()
	local obs = geom2.toPoints(geometry)
	expect(function()
		return geom2.validate(geometry)
	end)["not"].toThrow()
	expect(#obs).toEqual(36)
end)
test("roundedRectangle (zero size)", function()
	local obs = roundedRectangle({ size = { 1, 0 } })
	local pts = geom2.toPoints(obs)
	expect(function()
		return geom2.validate(obs)
	end)["not"].toThrow()
	expect(#pts).toBe(0)
end)
test("roundedRectangle (zero radius)", function()
	local obs = roundedRectangle({ roundRadius = 0 })
	local pts = geom2.toPoints(obs)
	expect(function()
		return geom2.validate(obs)
	end)["not"].toThrow()
	expect(#pts).toEqual(4)
end)
test("roundedRectangle (options)", function()
	-- test center
	local geometry = roundedRectangle({ center = { 4, 5 }, segments = 16 })
	local obs = geom2.toPoints(geometry)
	local exp = {
		{ 5, 5.8 },
		{ 4.984775906502257, 5.876536686473018 },
		{ 4.941421356237309, 5.941421356237309 },
		{ 4.876536686473018, 5.984775906502257 },
		{ 4.8, 6 },
		{ 3.2, 6 },
		{ 3.1234633135269823, 5.984775906502257 },
		{ 3.0585786437626905, 5.941421356237309 },
		{ 3.015224093497743, 5.876536686473018 },
		{ 3, 5.8 },
		{ 3, 4.2 },
		{ 3.015224093497743, 4.123463313526982 },
		{ 3.0585786437626905, 4.058578643762691 },
		{ 3.1234633135269823, 4.015224093497743 },
		{ 3.2, 4 },
		{ 4.8, 4 },
		{ 4.876536686473018, 4.015224093497743 },
		{ 4.941421356237309, 4.058578643762691 },
		{ 4.984775906502257, 4.123463313526982 },
		{ 5, 4.2 },
	}
	expect(function()
		return geom2.validate(geometry)
	end)["not"].toThrow()
	expect(#obs).toEqual(20)
	expect(comparePoints(obs, exp)).toBe(true) -- test size
	geometry = roundedRectangle({ size = { 10, 6 }, segments = 16 })
	obs = geom2.toPoints(geometry)
	exp = {
		{ 5, 2.8 },
		{ 4.984775906502257, 2.8765366864730177 },
		{ 4.941421356237309, 2.9414213562373095 },
		{ 4.876536686473018, 2.984775906502257 },
		{ 4.8, 3 },
		{ -4.8, 3 },
		{ -4.876536686473018, 2.984775906502257 },
		{ -4.941421356237309, 2.9414213562373095 },
		{ -4.984775906502257, 2.8765366864730177 },
		{ -5, 2.8 },
		{ -5, -2.8 },
		{ -4.984775906502257, -2.8765366864730177 },
		{ -4.941421356237309, -2.9414213562373095 },
		{ -4.876536686473018, -2.984775906502257 },
		{ -4.8, -3 },
		{ 4.8, -3 },
		{ 4.876536686473018, -2.984775906502257 },
		{ 4.941421356237309, -2.9414213562373095 },
		{ 4.984775906502257, -2.8765366864730177 },
		{ 5, -2.8 },
	}
	expect(function()
		return geom2.validate(geometry)
	end)["not"].toThrow()
	expect(#obs).toEqual(20)
	expect(comparePoints(obs, exp)).toBe(true) -- test roundRadius
	geometry = roundedRectangle({ size = { 10, 6 }, roundRadius = 2, segments = 16 })
	obs = geom2.toPoints(geometry)
	exp = {
		{ 5, 1 },
		{ 4.847759065022574, 1.7653668647301797 },
		{ 4.414213562373095, 2.414213562373095 },
		{ 3.7653668647301797, 2.8477590650225735 },
		{ 3, 3 },
		{ -3, 3 },
		{ -3.7653668647301792, 2.8477590650225735 },
		{ -4.414213562373095, 2.414213562373095 },
		{ -4.847759065022574, 1.7653668647301797 },
		{ -5, 1.0000000000000002 },
		{ -5, -0.9999999999999998 },
		{ -4.847759065022574, -1.7653668647301792 },
		{ -4.414213562373095, -2.414213562373095 },
		{ -3.76536686473018, -2.8477590650225735 },
		{ -3.0000000000000004, -3 },
		{ 2.9999999999999996, -3 },
		{ 3.7653668647301792, -2.8477590650225735 },
		{ 4.414213562373095, -2.414213562373095 },
		{ 4.847759065022574, -1.7653668647301801 },
		{ 5, -1.0000000000000004 },
	}
	expect(function()
		return geom2.validate(geometry)
	end)["not"].toThrow()
	expect(#obs).toEqual(20)
	expect(comparePoints(obs, exp)).toBe(true) -- test segments
	geometry = roundedRectangle({ size = { 10, 6 }, roundRadius = 2, segments = 64 })
	obs = geom2.toPoints(geometry)
	expect(function()
		return geom2.validate(geometry)
	end)["not"].toThrow()
	expect(#obs).toEqual(68)
end)