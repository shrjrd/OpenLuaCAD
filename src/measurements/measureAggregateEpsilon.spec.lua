-- ROBLOX NOTE: no upstream
local JestGlobals = require("@DevPackages/JestGlobals")
local test, expect = JestGlobals.test, JestGlobals.expect

local EPS = require("../maths/constants").EPS
local cube, square
do
	local ref = require("../primitives")
	cube, square = ref.cube, ref.square
end
local measureAggregateEpsilon = require("./measureAggregateEpsilon")
test("measureAggregateEpsilon (single objects)", function()
	local aCube = cube({ size = 4, center = { 4, 10, 20 } })
	local calculatedEpsilon = measureAggregateEpsilon(aCube)
	local expectedEpsilon = EPS * 4
	expect(calculatedEpsilon).toBe(expectedEpsilon)
end)
test("measureAggregateEpsilon (multiple objects)", function()
	local highCube = cube({ size = 4, center = { -40, 100, 20 } })
	local lowCube = cube({ size = 60, center = { 20, -10, 20 } })
	local calculatedEpsilon = measureAggregateEpsilon(highCube, lowCube)
	local expectedEpsilon = EPS * 98
	expect(calculatedEpsilon).toBe(expectedEpsilon)
end)
test("measureAggregateEpsilon (multiple 2D objects)", function()
	local highCube = cube({ size = 4, center = { -42, 100, 20 } })
	local lowCube = square({ size = 60, center = { 20, -10, 0 } })
	local calculatedEpsilon = measureAggregateEpsilon(highCube, lowCube)
	local expectedEpsilon = EPS * 86
	expect(calculatedEpsilon).toBe(expectedEpsilon)
end)
