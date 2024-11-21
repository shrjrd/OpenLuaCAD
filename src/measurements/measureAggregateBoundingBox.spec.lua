-- ROBLOX NOTE: no upstream
local JestGlobals = require("@DevPackages/JestGlobals")
local test, expect = JestGlobals.test, JestGlobals.expect

local cube = require("../primitives").cube
local measureAggregateBoundingBox = require("./measureAggregateBoundingBox")
local measureBoundingBox = require("./measureBoundingBox")
test("measureAggregateBoundingBox (single objects)", function()
	local aCube = cube({ size = 4, center = { 4, 10, 20 } })
	local bounds = measureAggregateBoundingBox(aCube)
	expect(bounds).toEqual({ { 2, 8, 18 }, { 6, 12, 22 } })
end)
test("measureAggregateBoundingBox (multiple objects)", function()
	local cube1 = cube({ size = 4, center = { 4, -10, 20 } })
	local cube2 = cube({ size = 6, center = { 0, -20, 20 } })
	local expectedBounds = { { -3, -23, 17 }, { 6, -8, 23 } }
	local bounds = measureAggregateBoundingBox(cube1, cube2)
	expect(bounds).toEqual(expectedBounds)
	bounds = measureAggregateBoundingBox({ cube1, cube2 })
	expect(bounds).toEqual(expectedBounds)
end)
test("measureAggregateBoundingBox (multiple objects) does not change original bounds", function()
	local cube1 = cube({ size = 4, center = { 4, 10, 20 } })
	local cube2 = cube({ size = 6, center = { 0, 20, 20 } })
	local objectBoundsBefore = JSON.stringify(measureBoundingBox(cube1, cube2))
	measureAggregateBoundingBox(cube1, cube2)
	local objectBoundsAfter = JSON.stringify(measureBoundingBox(cube1, cube2))
	expect(objectBoundsBefore).toBe(objectBoundsAfter)
end)
