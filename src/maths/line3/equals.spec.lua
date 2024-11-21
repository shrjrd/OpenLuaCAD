-- ROBLOX NOTE: no upstream
local JestGlobals = require("@DevPackages/JestGlobals")
local test, expect = JestGlobals.test, JestGlobals.expect

local equals, fromPointAndDirection, create
do
	local ref = require("./init")
	equals, fromPointAndDirection, create = ref.equals, ref.fromPointAndDirection, ref.create
end
test("line3: equals() should return correct booleans", function()
	local line0 = fromPointAndDirection(create(), { 0, 0, 0 }, { 1, 1, 1 })
	local line1 = fromPointAndDirection(create(), { 0, 0, 0 }, { 1, 1, 1 })
	expect(equals(line0, line1)).toBe(true)
	local line2 = fromPointAndDirection(create(), { 0, 0, 0 }, { 0, 1, 0 })
	expect(equals(line0, line2)).toBe(false)
	local line3 = fromPointAndDirection(create(), { 1, 0, 1 }, { 0, 0, 0 })
	expect(equals(line0, line3)).toBe(false)
	local line4 = fromPointAndDirection(create(), { 1, 1, 1 }, { 1, 1, 1 })
	expect(equals(line0, line4)).toBe(false)
end)
