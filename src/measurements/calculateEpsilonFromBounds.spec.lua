-- ROBLOX NOTE: no upstream
local JestGlobals = require("@DevPackages/JestGlobals")
local test, expect = JestGlobals.test, JestGlobals.expect

local EPS = require("../maths/constants").EPS
local calculateEpsilonFromBounds = require("./calculateEpsilonFromBounds")
test("calculateEpsilonFromBounds: 2 dimension", function()
	local bounds = { { -10, -100 }, { 100, 10 } }
	local calculatedEpsilon = calculateEpsilonFromBounds(bounds, 2)
	local expectedEpsilon = EPS * 110
	expect(calculatedEpsilon).toBe(expectedEpsilon)
end)
test("calculateEpsilonFromBounds: 3 dimension", function()
	local bounds = { { -500, 0, -100 }, { 0, 500, 100 } }
	local calculatedEpsilon = calculateEpsilonFromBounds(bounds, 3)
	local expectedEpsilon = EPS * 400
	expect(calculatedEpsilon).toBe(expectedEpsilon)
end)
