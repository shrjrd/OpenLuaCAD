-- ROBLOX NOTE: no upstream
local JestGlobals = require("@DevPackages/JestGlobals")
local test, expect = JestGlobals.test, JestGlobals.expect

local fromValues = require("./init").fromValues
local compareVectors = require("../../../test/helpers/init").compareVectors
test("mat4. fromValues() should return a new mat4 with correct values", function()
	local obs1 = fromValues(0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15)
	expect(compareVectors(obs1, { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15 })).toBe(true)
	local obs2 = fromValues(0, -1, -2, -3, -4, -5, -6, -7, -8, -9, -10, -11, -12, -13, -14, -15)
	expect(compareVectors(obs2, { 0, -1, -2, -3, -4, -5, -6, -7, -8, -9, -10, -11, -12, -13, -14, -15 })).toBe(true)
end)
