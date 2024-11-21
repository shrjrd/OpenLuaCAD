-- ROBLOX NOTE: no upstream
local JestGlobals = require("@DevPackages/JestGlobals")
local test, expect = JestGlobals.test, JestGlobals.expect

local angleDegrees = require("./init").angleDegrees
local nearlyEqual = require("../../../test/helpers/init").nearlyEqual
local EPS = require("../constants").EPS
test("vec2. angleDegrees() should return correct values", function()
	local distance1 = angleDegrees({ 0, 0 })
	nearlyEqual(distance1, 0.0, EPS)
	local distance2 = angleDegrees({ 1, 2 })
	nearlyEqual(distance2, 63.4349488, EPS)
	local distance3 = angleDegrees({ 1, -2 })
	nearlyEqual(distance3, -63.4349488, EPS)
	local distance4 = angleDegrees({ -1, -2 })
	nearlyEqual(distance4, -116.5650511, EPS)
	local distance5 = angleDegrees({ -1, 2 })
	nearlyEqual(distance5, 116.5650511, EPS)
	expect(true).toBe(true)
end)
