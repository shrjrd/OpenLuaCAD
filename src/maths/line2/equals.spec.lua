-- ROBLOX NOTE: no upstream
local JestGlobals = require("@DevPackages/JestGlobals")
local test, expect = JestGlobals.test, JestGlobals.expect

local equals, fromValues
do
	local ref = require("./init")
	equals, fromValues = ref.equals, ref.fromValues
end
test("line2. equals() should return correct booleans", function()
	local line0 = fromValues(0, 0, 0)
	local line1 = fromValues(0, 0, 0)
	expect(equals(line0, line1)).toBe(true)
	local line2 = fromValues(1, 1, 1)
	expect(equals(line0, line2)).toBe(false)
	local line3 = fromValues(1, 1, 0)
	expect(equals(line0, line3)).toBe(false)
	local line4 = fromValues(0, 1, 1)
	expect(equals(line0, line4)).toBe(false)
	local line5 = fromValues(1, 0, 0)
	expect(equals(line0, line5)).toBe(false)
	local line6 = fromValues(0, 1, 0)
	expect(equals(line0, line6)).toBe(false)
	local line7 = fromValues(0, 0, 1)
	expect(equals(line0, line7)).toBe(false)
end)
