-- ROBLOX NOTE: no upstream
local JestGlobals = require("@DevPackages/JestGlobals")
local test, expect = JestGlobals.test, JestGlobals.expect

local direction, create, fromPoints
do
	local ref = require("./init")
	direction, create, fromPoints = ref.direction, ref.create, ref.fromPoints
end
local compareVectors = require("../../../test/helpers/init").compareVectors
test("line3: direction() should return proper direction", function()
	local line1 = create()
	local dir1 = direction(line1)
	expect(compareVectors(dir1, { 0, 0, 1 })).toBe(true)
	local line2 = fromPoints(line1, { 1, 0, 0 }, { 0, 1, 0 })
	local dir2 = direction(line2)
	expect(compareVectors(dir2, { -0.7071067811865475, 0.7071067811865475, 0 })).toBe(true)
	local line3 = fromPoints(line1, { 0, 1, 0 }, { 1, 0, 0 })
	local dir3 = direction(line3)
	expect(compareVectors(dir3, { 0.7071067811865475, -0.7071067811865475, 0 })).toBe(true)
	local line4 = fromPoints(line1, { 0, 0, 1 }, { 0, 0, -6 })
	local dir4 = direction(line4)
	expect(compareVectors(dir4, { 0, 0, -1 })).toBe(true)
	local line5 = fromPoints(line1, { -5, -5, -5 }, { 5, 5, 5 })
	local dir5 = direction(line5)
	expect(compareVectors(dir5, { 0.5773502691896258, 0.5773502691896258, 0.5773502691896258 })).toBe(true)
end)
