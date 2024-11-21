-- ROBLOX NOTE: no upstream
local JestGlobals = require("@DevPackages/JestGlobals")
local test, expect = JestGlobals.test, JestGlobals.expect

local cube, cuboid
do
	local ref = require("../primitives")
	cube, cuboid = ref.cube, ref.cuboid
end
local measureAggregateArea = require("./measureAggregateArea")
test("measureAggregateArea (single objects)", function()
	local aCube = cube({ size = 4, center = { 4, 10, 20 } })
	local area = measureAggregateArea(aCube)
	expect(area).toBe(4 * 4 * 6)
end)
test("measureAggregateArea (multiple objects)", function()
	local cube1 = cube({ size = 4, center = { 4, -10, 20 } })
	local cuboid2 = cuboid({ size = { 1, 4, 10 }, center = { 0, -20, 20 } })
	local expectedArea = 4 * 4 * 6 + 2 * (1 * 4 + 1 * 10 + 4 * 10)
	local volume = measureAggregateArea(cube1, cuboid2)
	expect(volume).toBe(expectedArea)
	volume = measureAggregateArea({ cube1, cuboid2 })
	expect(volume).toBe(expectedArea)
end)
