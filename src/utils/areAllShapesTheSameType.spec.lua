-- ROBLOX NOTE: no upstream
local JestGlobals = require("@DevPackages/JestGlobals")
local test, expect = JestGlobals.test, JestGlobals.expect

local cube, square
do
	local ref = require("../primitives")
	cube, square = ref.cube, ref.square
end
local areAllShapesTheSameType = require("./init").areAllShapesTheSameType
test("utils: areAllShapesTheSameType() should return correct values", function()
	local geometry2 = square()
	local geometry3 = cube()
	expect(areAllShapesTheSameType({})).toBe(true)
	expect(areAllShapesTheSameType({ geometry2 })).toBe(true)
	expect(areAllShapesTheSameType({ geometry3 })).toBe(true)
	expect(areAllShapesTheSameType({ geometry2, geometry2 })).toBe(true)
	expect(areAllShapesTheSameType({ geometry3, geometry3 })).toBe(true)
	expect(areAllShapesTheSameType({ geometry2, geometry3 })).toBe(false)
end)
