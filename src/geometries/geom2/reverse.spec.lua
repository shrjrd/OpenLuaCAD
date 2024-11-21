-- ROBLOX NOTE: no upstream
local JestGlobals = require("@DevPackages/JestGlobals")
local test, expect = JestGlobals.test, JestGlobals.expect

local reverse, fromPoints
do
	local ref = require("./init")
	reverse, fromPoints = ref.reverse, ref.fromPoints
end
local comparePoints, compareVectors
do
	local ref = require("../../../test/helpers/")
	comparePoints, compareVectors = ref.comparePoints, ref.compareVectors
end
test("reverse: Reverses a populated geom2", function()
	local points = { { 0, 0 }, { 1, 0 }, { 0, 1 } }
	local expected = {
		sides = { { { 0, 1 }, { 1, 0 } }, { { 1, 0 }, { 0, 0 } }, { { 0, 0 }, { 0, 1 } } },
		transforms = { 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1 },
	}
	local geometry = fromPoints(points)
	local another = reverse(geometry)
	expect(geometry)["not"].toBe(another)
	expect(comparePoints(
		another.sides[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		],
		expected.sides[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		]
	)).toBe(true)
	expect(comparePoints(
		another.sides[
			2 --[[ ROBLOX adaptation: added 1 to array index ]]
		],
		expected.sides[
			2 --[[ ROBLOX adaptation: added 1 to array index ]]
		]
	)).toBe(true)
	expect(comparePoints(
		another.sides[
			3 --[[ ROBLOX adaptation: added 1 to array index ]]
		],
		expected.sides[
			3 --[[ ROBLOX adaptation: added 1 to array index ]]
		]
	)).toBe(true)
	expect(compareVectors(another.transforms, expected.transforms)).toBe(true)
end)
