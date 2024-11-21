-- ROBLOX NOTE: no upstream
local JestGlobals = require("@DevPackages/JestGlobals")
local test, expect = JestGlobals.test, JestGlobals.expect

local direction, create, fromPoints
do
	local ref = require("./init")
	direction, create, fromPoints = ref.direction, ref.create, ref.fromPoints
end
local compareVectors = require("../../../test/helpers/init").compareVectors
test("line2. direction() should return proper direction", function()
	local line1 = create()
	local dir1 = direction(line1)
	expect(compareVectors(dir1, { 1, 0 })).toBe(true)
	local line2 = fromPoints(create(), { 1, 0 }, { 0, 1 })
	local dir2 = direction(line2)
	expect(compareVectors(dir2, { -0.7071067811865475, 0.7071067811865476 })).toBe(true)
	local line3 = fromPoints(create(), { 0, 1 }, { 1, 0 })
	local dir3 = direction(line3)
	expect(compareVectors(dir3, { 0.7071067811865475, -0.7071067811865476 })).toBe(true)
	local line4 = fromPoints(create(), { 0, 0 }, { 6, 0 })
	local dir4 = direction(line4)
	expect(compareVectors(dir4, { 1, 0 }, 1e-15)).toBe(true)
	local line5 = fromPoints(create(), { -5, 5 }, { 5, -5 })
	local dir5 = direction(line5)
	expect(compareVectors(dir5, { 0.7071067811865475, -0.7071067811865475 })).toBe(true)
	local line6 = fromPoints(create(), { 10, 0 }, { 0, 10 })
	local dir6 = direction(line6)
	expect(compareVectors(dir6, { -0.7071067811865475, 0.7071067811865475 })).toBe(true)
end)
