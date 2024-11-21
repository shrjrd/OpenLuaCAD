-- ROBLOX NOTE: no upstream
local JestGlobals = require("@DevPackages/JestGlobals")
local test, expect = JestGlobals.test, JestGlobals.expect

local equals, fromValues
do
	local ref = require("./init")
	equals, fromValues = ref.equals, ref.fromValues
end
test("plane. equals() should return correct booleans", function()
	local plane0 = fromValues(0, 0, 0, 0)
	local plane1 = fromValues(0, 0, 0, 0)
	expect(equals(plane0, plane1)).toBe(true)
	local plane2 = fromValues(1, 1, 1, 1)
	expect(equals(plane0, plane2)).toBe(false)
	local plane3 = fromValues(0, 1, 1, 0)
	expect(equals(plane0, plane3)).toBe(false)
	local plane4 = fromValues(0, 0, 1, 1)
	expect(equals(plane0, plane4)).toBe(false)
end)
