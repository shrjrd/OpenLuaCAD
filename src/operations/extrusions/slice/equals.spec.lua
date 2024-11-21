-- ROBLOX NOTE: no upstream
local JestGlobals = require("@DevPackages/JestGlobals")
local test, expect = JestGlobals.test, JestGlobals.expect

local equals, fromPoints
do
	local ref = require("./init")
	equals, fromPoints = ref.equals, ref.fromPoints
end
test("slice. equals() should return proper value", function()
	local sliceA = fromPoints({ { 0, 0 }, { 1, 0 }, { 1, 1 } })
	local sliceB = fromPoints({ { 0, 1 }, { 1, 0 }, { 1, 1 } })
	local sliceC = fromPoints({ { 0, 0 }, { 1, 0 }, { 1, 1 }, { 0, 0 } })
	expect(equals(sliceA, sliceA)).toBe(true)
	expect(equals(sliceA, sliceB)).toBe(false)
	expect(equals(sliceB, sliceA)).toBe(false)
	expect(equals(sliceA, sliceC)).toBe(false)
	expect(equals(sliceC, sliceA)).toBe(false)
end)
