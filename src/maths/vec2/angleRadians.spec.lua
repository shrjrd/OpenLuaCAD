-- ROBLOX NOTE: no upstream
local JestGlobals = require("@DevPackages/JestGlobals")
local test, expect = JestGlobals.test, JestGlobals.expect

local angleRadians = require("./init").angleRadians
local nearlyEqual = require("../../../test/helpers/init").nearlyEqual
local EPS = require("../constants").EPS
test("vec2. angleRadians() should return correct values", function()
	local distance1 = angleRadians({ 0, 0 })
	nearlyEqual(distance1, 0.0, EPS)
	local distance2 = angleRadians({ 1, 2 })
	nearlyEqual(distance2, 1.1071487177940904, EPS)
	local distance3 = angleRadians({ 1, -2 })
	nearlyEqual(distance3, -1.1071487177940904, EPS)
	local distance4 = angleRadians({ -1, -2 })
	nearlyEqual(distance4, -2.0344439357957027, EPS)
	local distance5 = angleRadians({ -1, 2 })
	nearlyEqual(distance5, 2.0344439357957027, EPS)
	expect(true).toBe(true)
end)
