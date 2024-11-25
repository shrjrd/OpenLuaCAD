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
local intersect = require("./init").intersect
local center = require("../transforms/center").center
test("intersect: intersect of one or more geom2 objects produces expected geometry", function()
	local geometry1 = circle({ radius = 2, segments = 8 }) -- intersect of one object
	local result1 = intersect(geometry1)
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
	end).never.toThrow()
	expect(#obs).toBe(8)
	expect(comparePoints(obs, exp)).toBe(true) -- intersect of two non-overlapping objects
	local geometry2 = center({ relativeTo = { 10, 10, 0 } }, rectangle({ size = { 4, 4 } }))
	local result2 = intersect(geometry1, geometry2)
	obs = geom2.toPoints(result2)
	expect(function()
		return geom2.validate(result2)
	end).never.toThrow()
	expect(#obs).toBe(0) -- intersect of two partially overlapping objects
	local geometry3 = rectangle({ size = { 18, 18 } })
	local result3 = intersect(geometry2, geometry3)
	obs = geom2.toPoints(result3)
	exp = { { 9, 9 }, { 8, 9 }, { 8, 8 }, { 9, 8 } }
	expect(function()
		return geom2.validate(result3)
	end).never.toThrow()
	expect(#obs).toBe(4)
	expect(comparePoints(obs, exp)).toBe(true) -- intersect of two completely overlapping objects
	local result4 = intersect(geometry1, geometry3)
	obs = geom2.toPoints(result4)
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
		return geom2.validate(result4)
	end).never.toThrow()
	expect(#obs).toBe(8)
	expect(comparePoints(obs, exp)).toBe(true)
end)
