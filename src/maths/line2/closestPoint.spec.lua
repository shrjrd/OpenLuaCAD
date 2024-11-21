-- ROBLOX NOTE: no upstream
local JestGlobals = require("@DevPackages/JestGlobals")
local test, expect = JestGlobals.test, JestGlobals.expect

local closestPoint, create, fromPoints
do
	local ref = require("./init")
	closestPoint, create, fromPoints = ref.closestPoint, ref.create, ref.fromPoints
end
local compareVectors = require("../../../test/helpers/init").compareVectors
test("line2. closestPoint() should return proper values", function()
	local line1 = create()
	local x1 = closestPoint(line1, { 0, 0 })
	expect(compareVectors(x1, { 0, 0 })).toBe(true)
	local x2 = closestPoint(line1, { 0, 1 })
	expect(compareVectors(x2, { 0, 0 })).toBe(true) -- const x3 = closestPoint([6, 0], line1)
	-- t.true(compareVectors(x3, [6, -0])) // rounding errors
	local line2 = fromPoints(create(), { -5, 5 }, { 5, -5 })
	local x4 = closestPoint(line2, { 0, 0 })
	expect(compareVectors(x4, { 0, 0 })).toBe(true)
	local x5 = closestPoint(line2, { 1, 0 })
	expect(compareVectors(x5, { 0.5, -0.5 })).toBe(true)
	local x6 = closestPoint(line2, { 2, 0 })
	expect(compareVectors(x6, { 1, -1 })).toBe(true)
	local x7 = closestPoint(line2, { 3, 0 })
	expect(compareVectors(x7, { 1.5, -1.5 })).toBe(true)
	local x8 = closestPoint(line2, { 4, 0 })
	expect(compareVectors(x8, { 2, -2 })).toBe(true)
	local x9 = closestPoint(line2, { 5, 0 })
	expect(compareVectors(x9, { 2.5, -2.5 })).toBe(true)
	local x10 = closestPoint(line2, { 50, 0 })
	expect(compareVectors(x10, { 25, -25 })).toBe(true)
	local ya = closestPoint(line2, { -5, 5 })
	expect(compareVectors(ya, { -5, 5 })).toBe(true)
	local yb = closestPoint(line2, { 5, -5 })
	expect(compareVectors(yb, { 5, -5 })).toBe(true)
	local za = closestPoint(line2, { 4, -6 })
	expect(compareVectors(za, { 5, -5 })).toBe(true)
	local zb = closestPoint(line2, { 3, -7 })
	expect(compareVectors(zb, { 5, -5 })).toBe(true)
	expect(true).toBe(true)
end)
test("line2. closestPoint() should return proper values (issue #1225)", function()
	local line = fromPoints(create(), { 10, 0 }, { 0, 10 })
	local closest = closestPoint(line, { 0, 0 })
	expect(compareVectors(closest, { 5, 5 })).toBe(true)
end)
