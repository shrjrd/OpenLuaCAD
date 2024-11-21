-- ROBLOX NOTE: no upstream
local JestGlobals = require("@DevPackages/JestGlobals")
local test, expect = JestGlobals.test, JestGlobals.expect

local reverse, create, fromPoints
do
	local ref = require("./init")
	reverse, create, fromPoints = ref.reverse, ref.create, ref.fromPoints
end
local compareVectors = require("../../../test/helpers/init").compareVectors
test("line2. reverse() called with two parameters should update a line2 with proper values", function()
	local line1 = create()
	local obs1 = create()
	local ret1 = reverse(obs1, line1)
	expect(compareVectors(ret1, { 0, -1, 0 })).toBe(true)
	expect(compareVectors(obs1, { 0, -1, 0 })).toBe(true)
	local line2 = fromPoints(create(), { 1, 0 }, { 0, 1 })
	local obs2 = create()
	local ret2 = reverse(obs2, line2)
	expect(compareVectors(ret2, { 0.7071067811865476, 0.7071067811865475, 0.7071067811865476 })).toBe(true)
	expect(compareVectors(obs2, { 0.7071067811865476, 0.7071067811865475, 0.7071067811865476 })).toBe(true)
	local line3 = fromPoints(create(), { 0, 1 }, { 1, 0 })
	local obs3 = create()
	local ret3 = reverse(obs3, line3)
	expect(compareVectors(ret3, { -0.7071067811865476, -0.7071067811865475, -0.7071067811865475 })).toBe(true)
	expect(compareVectors(obs3, { -0.7071067811865476, -0.7071067811865475, -0.7071067811865475 })).toBe(true)
	local line4 = fromPoints(create(), { 0, 6 }, { 6, 0 })
	local obs4 = create()
	local ret4 = reverse(obs4, line4)
	expect(compareVectors(ret4, { -0.7071067811865476, -0.7071067811865476, -4.242640687119286 })).toBe(true)
	expect(compareVectors(obs4, { -0.7071067811865476, -0.7071067811865476, -4.242640687119286 })).toBe(true)
	local line5 = fromPoints(create(), { -5, 5 }, { 5, -5 })
	local obs5 = create()
	local ret5 = reverse(obs5, line5)
	expect(compareVectors(ret5, { -0.7071067811865475, -0.7071067811865475, -0 })).toBe(true)
	expect(compareVectors(obs5, { -0.7071067811865475, -0.7071067811865475, -0 })).toBe(true)
end)
