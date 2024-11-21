-- ROBLOX NOTE: no upstream
local JestGlobals = require("@DevPackages/JestGlobals")
local test, expect = JestGlobals.test, JestGlobals.expect

local intersectPointOfLines, create, fromPoints
do
	local ref = require("./init")
	intersectPointOfLines, create, fromPoints = ref.intersectPointOfLines, ref.create, ref.fromPoints
end
local compareVectors = require("../../../test/helpers/init").compareVectors
test("line2. intersectPointOfLines() should return proper points", function()
	local line1 = create()
	local line2 = fromPoints(create(), { 1, 0 }, { 0, 1 })
	local int2 = intersectPointOfLines(line1, line2)
	expect(compareVectors(int2, { 1, 0 })).toBe(true) -- same lines opposite directions
	local line3 = fromPoints(create(), { 0, 1 }, { 1, 0 })
	local int3 = intersectPointOfLines(line3, line2)
	expect(compareVectors(int3, { 0 / 0, 0 / 0 })).toBe(true) -- parallel lines
	local line4 = fromPoints(create(), { 0, 6 }, { 6, 0 })
	local int4 = intersectPointOfLines(line4, line3)
	expect(compareVectors(int4, { math.huge, -math.huge })).toBe(true) -- intersecting lines
	local line5 = fromPoints(create(), { 0, -6 }, { 6, 0 })
	local int5 = intersectPointOfLines(line5, line4)
	expect(compareVectors(int5, { 6, 0 }, 1e-15)).toBe(true)
	local line6 = fromPoints(create(), { -6, 0 }, { 0, -6 })
	local int6 = intersectPointOfLines(line6, line5)
	expect(compareVectors(int6, { 0, -6 }, 1e-15)).toBe(true)
end)
