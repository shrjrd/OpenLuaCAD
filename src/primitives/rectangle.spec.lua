-- ROBLOX NOTE: no upstream
local JestGlobals = require("@DevPackages/JestGlobals")
local test, expect = JestGlobals.test, JestGlobals.expect

local rectangle = require("./init").rectangle
local geom2 = require("../geometries/geom2")
local comparePoints = require("../../test/helpers/comparePoints")
test("rectangle (defaults)", function()
	local geometry = rectangle()
	local obs = geom2.toPoints(geometry)
	local exp = { { -1, -1 }, { 1, -1 }, { 1, 1 }, { -1, 1 } }
	expect(function()
		return geom2.validate(geometry)
	end).never.toThrow()
	expect(#obs).toEqual(4)
	expect(comparePoints(obs, exp)).toBe(true)
end)
test("rectangle (options)", function()
	-- test center
	local geometry = rectangle({ center = { -4, -4 } })
	local obs = geom2.toPoints(geometry)
	local exp = { { -5, -5 }, { -3, -5 }, { -3, -3 }, { -5, -3 } }
	expect(function()
		return geom2.validate(geometry)
	end).never.toThrow()
	expect(#obs).toEqual(4)
	expect(comparePoints(obs, exp)).toBe(true) -- test size
	geometry = rectangle({ size = { 6, 10 } })
	obs = geom2.toPoints(geometry)
	exp = { { -3, -5 }, { 3, -5 }, { 3, 5 }, { -3, 5 } }
	expect(function()
		return geom2.validate(geometry)
	end).never.toThrow()
	expect(#obs).toEqual(4)
	expect(comparePoints(obs, exp)).toBe(true)
end)
test("rectangle (zero size)", function()
	local geometry = rectangle({ size = { 1, 0 } })
	local obs = geom2.toPoints(geometry)
	expect(function()
		return geom2.validate(geometry)
	end).never.toThrow()
	expect(#obs).toBe(0)
end)
