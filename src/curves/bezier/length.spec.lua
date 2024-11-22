-- ROBLOX NOTE: no upstream
local JestGlobals = require("@DevPackages/JestGlobals")
local test, expect = JestGlobals.test, JestGlobals.expect

local bezier = require("../init").bezier
local length = require("./length")
local nearlyEqual = require("../../../test/helpers/init").nearlyEqual
test("calculate the length of an 1D linear bezier with numeric control points", function()
	local bezierCurve = bezier.create({ 0, 10 })
	nearlyEqual(length(100, bezierCurve), 10, 0.0001)
	expect(true).toBe(true)
end)
test("calculate the length of an 1D linear bezier with array control points", function()
	local bezierCurve = bezier.create({ { 0 }, { 10 } })
	nearlyEqual(length(100, bezierCurve), 10, 0.0001)
	expect(true).toBe(true)
end)
test("calculate the length of a 2D linear bezier", function()
	local bezierCurve = bezier.create({ { 0, 0 }, { 10, 10 } })
	nearlyEqual(length(100, bezierCurve), 14.1421, 0.0001)
	expect(true).toBe(true)
end)
test("calculate the length of a 2D quadratic (3 control points) bezier", function()
	local bezierCurve = bezier.create({ { 0, 0 }, { 0, 10 }, { 10, 10 } })
	nearlyEqual(length(100, bezierCurve), 16.2320, 0.0001)
	expect(true).toBe(true)
end)
test("calculate the length of a 2D cubic (4 control points) bezier", function()
	local bezierCurve = bezier.create({ { 0, 0 }, { 0, 10 }, { 10, 10 }, { 10, 0 } })
	nearlyEqual(length(100, bezierCurve), 19.9992, 0.0001)
	expect(true).toBe(true)
end)
test("calculate the length of a 3D linear bezier", function()
	local bezierCurve = bezier.create({ { 0, 0, 0 }, { 10, 10, 10 } })
	nearlyEqual(length(100, bezierCurve), 17.3205, 0.0001)
	expect(true).toBe(true)
end)
test("calculate the length of a 3D quadratic (3 control points) bezier", function()
	local bezierCurve = bezier.create({ { 0, 0, 0 }, { 5, 5, 5 }, { 0, 0, 10 } })
	nearlyEqual(length(100, bezierCurve), 12.7125, 0.0001)
	expect(true).toBe(true)
end)
test("calculate the length of a 3D cubic (4 control points) bezier", function()
	local bezierCurve = bezier.create({ { 0, 0, 0 }, { 5, 5, 5 }, { 0, 0, 10 }, { -5, -5, 5 } })
	nearlyEqual(length(100, bezierCurve), 17.2116, 0.0001)
	expect(true).toBe(true)
end)
