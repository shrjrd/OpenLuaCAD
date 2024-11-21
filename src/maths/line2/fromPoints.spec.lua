-- ROBLOX NOTE: no upstream
local JestGlobals = require("@DevPackages/JestGlobals")
local test, expect = JestGlobals.test, JestGlobals.expect

local fromPoints, create
do
	local ref = require("./init")
	fromPoints, create = ref.fromPoints, ref.create
end
local compareVectors = require("../../../test/helpers/init").compareVectors
test("line2. fromPoints() should return a new line2 with correct values", function()
	local out = create()
	local obs1 = fromPoints(out, { 0, 0 }, { 0, 0 })
	expect(compareVectors(obs1, { 0, 0, 0 })).toBe(true)
	local obs2 = fromPoints(out, { 1, 0 }, { 0, 1 })
	expect(compareVectors(obs2, { -0.7071067811865476, -0.7071067811865475, -0.7071067811865476 })).toBe(true)
	local obs3 = fromPoints(out, { 0, 1 }, { 1, 0 })
	expect(compareVectors(obs3, { 0.7071067811865476, 0.7071067811865475, 0.7071067811865475 })).toBe(true)
	local obs4 = fromPoints(out, { 0, 6 }, { 6, 0 })
	expect(compareVectors(obs4, { 0.7071067811865476, 0.7071067811865476, 4.242640687119286 })).toBe(true) -- line2 created from the same points results in an invalid line2
	local obs9 = fromPoints(out, { 0, 5 }, { 0, 5 })
	expect(compareVectors(obs9, { 0, 0, 0 })).toBe(true)
end)
