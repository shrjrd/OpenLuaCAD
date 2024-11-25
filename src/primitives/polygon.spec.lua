-- ROBLOX NOTE: no upstream
local JestGlobals = require("@DevPackages/JestGlobals")
local test, expect = JestGlobals.test, JestGlobals.expect

local geom2 = require("../geometries/geom2")
local measureArea = require("../measurements/measureArea")
local polygon = require("./init").polygon
local comparePoints = require("../../test/helpers/comparePoints")
test("polygon: providing only object.points creates expected geometry", function()
	local geometry = polygon({ points = { { 0, 0 }, { 100, 0 }, { 130, 50 }, { 30, 50 } } })
	local obs = geom2.toPoints(geometry)
	local exp = { { 0, 0 }, { 100, 0 }, { 130, 50 }, { 30, 50 } }
	expect(function()
		return geom2.validate(geometry)
	end).never.toThrow()
	expect(comparePoints(obs, exp)).toBe(true)
	geometry = polygon({
		points = {
			{ { 0, 0 }, { 100, 0 }, { 0, 100 } },
			{
				{ 10, 10 },
				{ 80, 10 },
				{ 10, 80 },
			},
		},
	})
	obs = geom2.toPoints(geometry)
	exp = { { 0, 0 }, { 100, 0 }, { 10, 80 }, { 10, 10 }, { 80, 10 }, { 0, 100 } }
	expect(function()
		return geom2.validate(geometry)
	end).never.toThrow()
	expect(comparePoints(obs, exp)).toBe(true)
end)
test("polygon: providing object.points (array) and object.path (array) creates expected geometry", function()
	local geometry = polygon({
		points = { { 0, 0 }, { 100, 0 }, { 130, 50 }, { 30, 50 } },
		paths = { { 3, 2, 1, 0 } },
	})
	local obs = geom2.toPoints(geometry)
	local exp = { { 30, 50 }, { 130, 50 }, { 100, 0 }, { 0, 0 } }
	expect(function()
		return geom2.validate(geometry)
	end).never.toThrow()
	expect(comparePoints(obs, exp)).toBe(true) -- multiple paths
	geometry = polygon({
		points = { { 0, 0 }, { 100, 0 }, { 0, 100 }, { 10, 10 }, { 80, 10 }, { 10, 80 } },
		paths = { { 0, 1, 2 }, { 3, 4, 5 } },
	})
	obs = geom2.toPoints(geometry)
	exp = { { 0, 0 }, { 100, 0 }, { 10, 80 }, { 10, 10 }, { 80, 10 }, { 0, 100 } }
	expect(function()
		return geom2.validate(geometry)
	end).never.toThrow()
	expect(comparePoints(obs, exp)).toBe(true) -- multiple points and paths
	geometry = polygon({
		points = {
			{ { 0, 0 }, { 100, 0 }, { 0, 100 } },
			{ { 10, 10 }, { 80, 10 }, { 10, 80 } },
		},
		paths = { { 0, 1, 2 }, { 3, 4, 5 } },
	})
	obs = geom2.toPoints(geometry)
	exp = { { 0, 0 }, { 100, 0 }, { 10, 80 }, { 10, 10 }, { 80, 10 }, { 0, 100 } }
	expect(function()
		return geom2.validate(geometry)
	end).never.toThrow()
	expect(comparePoints(obs, exp)).toBe(true)
end)
test("polygon: clockwise points", function()
	local poly = polygon({ points = { { -10, -0 }, { -10, -10 }, { -15, -5 } }, orientation = "clockwise" })
	expect(#poly.sides).toBe(3)
	expect(measureArea(poly)).toBe(25)
end)
