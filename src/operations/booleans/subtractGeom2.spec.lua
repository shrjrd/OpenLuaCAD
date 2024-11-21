-- ROBLOX NOTE: no upstream
local JestGlobals = require("@DevPackages/JestGlobals")
local test, expect = JestGlobals.test, JestGlobals.expect

local comparePoints = require("../../../test/helpers").comparePoints
local geom2 = require("../../geometries").geom2
local circle, rectangle
do
	local ref = require("../../primitives")
	circle, rectangle = ref.circle, ref.rectangle
end
local subtract = require("./init").subtract
local center = require("../transforms/center").center
test("subtract: subtract of one or more geom2 objects produces expected geometry", function()
	local geometry1 = circle({ radius = 2, segments = 8 }) -- subtract of one object
	local result1 = subtract(geometry1)
	local obs = geom2.toPoints(result1)
	local exp = {
		{ 2, 0 },
		{ 1.4142000000000001, 1.4142000000000001 },
		{ 0, 2 },
		{ -1.4142000000000001, 1.4142000000000001 },
		{ -2, 0 },
		{ -1.4142000000000001, -1.4142000000000001 },
		{ 0, -2 },
		{ 1.4142000000000001, -1.4142000000000001 },
	}
	expect(function()
		return geom2.validate(result1)
	end)["not"].toThrow()
	expect(#obs).toBe(8)
	expect(comparePoints(obs, exp)).toBe(true) -- subtract of two non-overlapping objects
	local geometry2 = center({ relativeTo = { 10, 10, 0 } }, rectangle({ size = { 4, 4 } }))
	local result2 = subtract(geometry1, geometry2)
	obs = geom2.toPoints(result2)
	exp = {
		{ 2, 0 },
		{ 1.4142000000000001, 1.4142000000000001 },
		{ 0, 2 },
		{ -1.4142000000000001, 1.4142000000000001 },
		{ -2, 0 },
		{ -1.4142000000000001, -1.4142000000000001 },
		{ 0, -2 },
		{ 1.4142000000000001, -1.4142000000000001 },
	}
	expect(function()
		return geom2.validate(result2)
	end)["not"].toThrow()
	expect(#obs).toBe(8)
	expect(comparePoints(obs, exp)).toBe(true) -- subtract of two partially overlapping objects
	local geometry3 = rectangle({ size = { 18, 18 } })
	local result3 = subtract(geometry2, geometry3)
	obs = geom2.toPoints(result3)
	exp = { { 12, 12 }, { 9, 9 }, { 8, 9 }, { 8, 12 }, { 9, 8 }, { 12, 8 } }
	expect(function()
		return geom2.validate(result3)
	end)["not"].toThrow()
	expect(#obs).toBe(6)
	expect(comparePoints(obs, exp)).toBe(true) -- subtract of two completely overlapping objects
	local result4 = subtract(geometry1, geometry3)
	obs = geom2.toPoints(result4)
	exp = {}
	expect(function()
		return geom2.validate(result4)
	end)["not"].toThrow()
	expect(#obs).toBe(0)
	expect(obs).toEqual(exp)
end)
