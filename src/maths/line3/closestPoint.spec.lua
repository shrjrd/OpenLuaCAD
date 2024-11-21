-- ROBLOX NOTE: no upstream
local JestGlobals = require("@DevPackages/JestGlobals")
local test, expect = JestGlobals.test, JestGlobals.expect

local closestPoint, create, fromPoints
do
	local ref = require("./init")
	closestPoint, create, fromPoints = ref.closestPoint, ref.create, ref.fromPoints
end
local compareVectors = require("../../../test/helpers/init").compareVectors
test("line3: closestPoint() should return proper values", function()
	local line1 = create() -- line follows X axis
	local x1 = closestPoint(line1, { 0, 0, 0 })
	expect(compareVectors(x1, { 0, 0, 0 })).toBe(true)
	local x2 = closestPoint(line1, { 0, 1, 0 })
	expect(compareVectors(x2, { 0, 0, 0 })).toBe(true)
	local x3 = closestPoint(line1, { 6, 0, 0 })
	expect(compareVectors(x3, { 0, 0, 0 })).toBe(true) -- rounding errors
	local line2 = fromPoints(create(), { -5, -5, -5 }, { 5, 5, 5 })
	local x4 = closestPoint(line2, { 0, 0, 0 })
	expect(compareVectors(x4, { 0.000000000000, 0.000000000000, 0.00000000000 })).toBe(true)
	local x5 = closestPoint(line2, { 1, 0, 0 })
	expect(compareVectors(x5, { 0.3333333333333339, 0.3333333333333339, 0.3333333333333339 })).toBe(true)
	local x6 = closestPoint(line2, { 2, 0, 0 })
	expect(compareVectors(x6, { 0.6666666666666661, 0.6666666666666661, 0.6666666666666661 })).toBe(true)
	local x7 = closestPoint(line2, { 3, 0, 0 })
	expect(compareVectors(x7, { 1, 1, 1 })).toBe(true)
	local x8 = closestPoint(line2, { 4, 0, 0 })
	expect(compareVectors(x8, { 1.3333333333333348, 1.3333333333333348, 1.3333333333333348 })).toBe(true)
	local x9 = closestPoint(line2, { 5, 0, 0 })
	expect(compareVectors(x9, { 1.666666666666667, 1.666666666666667, 1.666666666666667 })).toBe(true)
	local x10 = closestPoint(line2, { 50, 0, 0 })
	expect(compareVectors(x10, { 16.666666666666668, 16.666666666666668, 16.666666666666668 })).toBe(true)
	local ya = closestPoint(line2, { -5, -5, -5 })
	expect(compareVectors(ya, { -5, -5, -5 })).toBe(true)
	local yb = closestPoint(line2, { 5, 5, 5 })
	expect(compareVectors(yb, { 5, 5, 5 })).toBe(true)
	expect(true).toBe(true)
end)
