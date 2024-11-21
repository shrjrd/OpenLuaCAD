-- ROBLOX NOTE: no upstream
local JestGlobals = require("@DevPackages/JestGlobals")
local test, expect = JestGlobals.test, JestGlobals.expect

local fromValues = require("./init").fromValues
local compareVectors = require("../../../test/helpers/init").compareVectors
test("vec4. fromValues() should return a new vec4 with correct values", function()
	local obs1 = fromValues(0, 0, 0, 0)
	expect(compareVectors(obs1, { 0, 0, 0, 0 })).toBe(true)
	local obs2 = fromValues(5, 4, 3, 2)
	expect(compareVectors(obs2, { 5, 4, 3, 2 })).toBe(true)
	local obs3 = fromValues(-5, -4, -3, -2)
	expect(compareVectors(obs3, { -5, -4, -3, -2 })).toBe(true)
end)
