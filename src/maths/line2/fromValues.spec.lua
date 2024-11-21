-- ROBLOX NOTE: no upstream
local JestGlobals = require("@DevPackages/JestGlobals")
local test, expect = JestGlobals.test, JestGlobals.expect

local fromValues = require("./init").fromValues
local compareVectors = require("../../../test/helpers/init").compareVectors
test("line2. fromValues() should return a new line2 with correct values", function()
	local obs1 = fromValues(0, 0, 0)
	expect(compareVectors(obs1, { 0, 0, 0 })).toBe(true)
	local obs2 = fromValues(0, 1, -5)
	expect(compareVectors(obs2, { 0, 1, -5 })).toBe(true)
end)
