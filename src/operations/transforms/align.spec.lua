-- ROBLOX NOTE: no upstream
local JestGlobals = require("@DevPackages/JestGlobals")
local test, expect = JestGlobals.test, JestGlobals.expect

local comparePoints = require("../../../test/helpers").comparePoints
local geom3 = require("../../geometries").geom3
local measureBoundingBox, measureAggregateBoundingBox
do
	local ref = require("../../measurements")
	measureBoundingBox, measureAggregateBoundingBox = ref.measureBoundingBox, ref.measureAggregateBoundingBox
end
local cube = require("../../primitives").cube
local align = require("./init").align
test("align: single object returns geometry unchanged if all axes are none", function()
	local original = cube({ size = 4, center = { 10, 10, 10 } })
	local aligned = align({ modes = { "none", "none", "none" } }, original)
	local bounds = measureBoundingBox(aligned)
	local expectedBounds = { { 8, 8, 8 }, { 12, 12, 12 } }
	expect(function()
		return geom3.validate(aligned)
	end).never.toThrow()
	expect(comparePoints(bounds, expectedBounds)).toBe(true)
end)
test("align: single objects returns geometry aligned, different modes on each axis", function()
	local original = cube({ size = 4, center = { 10, 10, 10 } })
	local aligned = align({ modes = { "center", "min", "max" } }, original)
	local bounds = measureBoundingBox(aligned)
	local expectedBounds = { { -2, 0, -4 }, { 2, 4, 0 } }
	expect(function()
		return geom3.validate(aligned)
	end).never.toThrow()
	expect(comparePoints(bounds, expectedBounds)).toBe(true)
end)
test("align: unfilled modes and relativeTo arrays return results with expected values", function()
	local original = cube({ size = 4, center = { 10, 10, 10 } })
	local aligned = align({ modes = { "center" }, relativeTo = { 0 } }, original)
	local bounds = measureBoundingBox(aligned)
	local expectedBounds = { { -2, 8, 8 }, { 2, 12, 12 } }
	expect(function()
		return geom3.validate(aligned)
	end).never.toThrow()
	expect(comparePoints(bounds, expectedBounds)).toBe(true)
end)
test("align: multiple objects grouped returns geometry aligned, different modes on each axis", function()
	local original = {
		cube({ size = 4, center = { 10, 10, 10 } }),
		cube({ size = 2, center = { 4, 4, 4 } }),
	}
	local aligned = align({ modes = { "center", "min", "max" }, relativeTo = { 6, -10, 0 }, grouped = true }, original)
	local bounds = measureAggregateBoundingBox(aligned)
	local expectedBounds = { { 1.5, -10, -9 }, { 10.5, -1, 0 } }
	expect(function()
		return geom3.validate(aligned[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		])
	end).never.toThrow()
	expect(function()
		return geom3.validate(aligned[
			2 --[[ ROBLOX adaptation: added 1 to array index ]]
		])
	end).never.toThrow()
	expect(comparePoints(bounds, expectedBounds)).toBe(true)
end)
test("align: multiple objects ungrouped returns geometry aligned, different modes on each axis", function()
	local original = {
		cube({ size = 4, center = { 10, 10, 10 } }),
		cube({ size = 2, center = { 4, 4, 4 } }),
	}
	local aligned = align({ modes = { "center", "min", "max" }, relativeTo = { 30, 30, 30 } }, original)
	local bounds = measureAggregateBoundingBox(aligned)
	local expectedBounds = { { 28, 30, 26 }, { 32, 34, 30 } }
	expect(function()
		return geom3.validate(aligned[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		])
	end).never.toThrow()
	expect(function()
		return geom3.validate(aligned[
			2 --[[ ROBLOX adaptation: added 1 to array index ]]
		])
	end).never.toThrow()
	expect(comparePoints(bounds, expectedBounds)).toBe(true)
end)
test("align: multiple objects grouped, relativeTo is nulls, returns geometry unchanged", function()
	local original = { cube({ size = 4, center = { 10, 10, 10 } }), cube({ size = 2, center = { 4, 4, 4 } }) }
	local aligned =
		align({ modes = { "center", "min", "max" }, relativeTo = { nil, nil, nil }, grouped = true }, original)
	local bounds = measureAggregateBoundingBox(aligned)
	local expectedBounds = { { 3, 3, 3 }, { 12, 12, 12 } }
	expect(function()
		return geom3.validate(aligned[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		])
	end).never.toThrow()
	expect(function()
		return geom3.validate(aligned[
			2 --[[ ROBLOX adaptation: added 1 to array index ]]
		])
	end).never.toThrow()
	expect(comparePoints(bounds, expectedBounds)).toBe(true)
end)
test("align: multiple objects ungrouped, relativeTo is nulls, returns geometry aligned to group bounds", function()
	local original = {
		cube({ size = 2, center = { 4, 4, 4 } }),
		cube({ size = 4, center = { 10, 10, 10 } }),
	}
	local aligned =
		align({ modes = { "center", "min", "max" }, relativeTo = { nil, nil, nil }, grouped = false }, original)
	local bounds = measureAggregateBoundingBox(aligned)
	local expectedBounds = { { 5.5, 3, 8 }, { 9.5, 7, 12 } }
	expect(function()
		return geom3.validate(aligned[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		])
	end).never.toThrow()
	expect(function()
		return geom3.validate(aligned[
			2 --[[ ROBLOX adaptation: added 1 to array index ]]
		])
	end).never.toThrow()
	expect(comparePoints(bounds, expectedBounds)).toBe(true)
end)
test("align: throws errors on bad options", function()
	local aCube = cube({ size = 4, center = { 10, 10, 10 } })
	expect(function()
		return align({ grouped = 3 }, aCube)
	end).toThrowError(--[[{ instanceOf = Error }]])
	expect(function()
		return align({ relativeTo = { 3, 4, 9, 12 } }, aCube)
	end).toThrowError(--[[{ instanceOf = Error }]])
	expect(function()
		return align({ relativeTo = { 3, 4, "dog" } }, aCube)
	end).toThrowError(--[[{ instanceOf = Error }]])
	expect(function()
		return align({ modes = { "center", "max", "james" } }, aCube)
	end).toThrowError(--[[{ instanceOf = Error }]])
	expect(function()
		return align({ modes = { "center", "max", "min", "none" } }, aCube)
	end).toThrowError(--[[{ instanceOf = Error }]])
end)
