-- ROBLOX NOTE: no upstream
local JestGlobals = require("@DevPackages/JestGlobals")
local test, expect = JestGlobals.test, JestGlobals.expect

local cube, cuboid
do
	local ref = require("../primitives")
	cube, cuboid = ref.cube, ref.cuboid
end
local measureAggregateVolume = require("./measureAggregateVolume")
test("measureAggregateVolume (single objects)", function()
	local aCube = cube({ size = 4, center = { 4, 10, 20 } })
	local volume = measureAggregateVolume(aCube)
	expect(volume).toBe(64)
end)
test("measureAggregateVolume (multiple objects)", function()
	local cube1 = cube({ size = 4, center = { 4, -10, 20 } })
	local cuboid2 = cuboid({ size = { 1, 4, 10 }, center = { 0, -20, 20 } })
	local volume = measureAggregateVolume(cube1, cuboid2)
	expect(volume).toBe(104)
	volume = measureAggregateVolume({ cube1, cuboid2 })
	expect(volume).toBe(104)
end)
