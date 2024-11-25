-- ROBLOX NOTE: no upstream
local JestGlobals = require("@DevPackages/JestGlobals")
local test, expect = JestGlobals.test, JestGlobals.expect

local mat4 = require("../../maths/mat4")
local measureArea = require("../../measurements").measureArea
local mirrorX, mirrorY, mirrorZ
do
	local ref = require("../../operations/transforms")
	mirrorX, mirrorY, mirrorZ = ref.mirrorX, ref.mirrorY, ref.mirrorZ
end
local square = require("../../primitives").square
local fromPoints, transform, toOutlines, toSides
do
	local ref = require("./init")
	fromPoints, transform, toOutlines, toSides = ref.fromPoints, ref.transform, ref.toOutlines, ref.toSides
end
local comparePoints, compareVectors
do
	local ref = require("../../../test/helpers/")
	comparePoints, compareVectors = ref.comparePoints, ref.compareVectors
end
test("transform: adjusts the transforms of geom2", function()
	local points = { { 0, 0 }, { 1, 0 }, { 0, 1 } }
	local rotation = 90 * 0.017453292519943295
	local rotate90 = mat4.fromZRotation(mat4.create(), rotation) -- continue with typical user scenario, several iterations of transforms and access
	-- expect lazy transform, i.e. only the transforms change
	local expected = {
		sides = { { { 0, 1 }, { 0, 0 } }, { { 0, 0 }, { 1, 0 } }, { { 1, 0 }, { 0, 1 } } },
		transforms = { 0, 1, 0, 0, -1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1 },
	}
	local geometry = fromPoints(points)
	local another = transform(rotate90, geometry)
	expect(geometry).never.toBe(another)
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
	expect(compareVectors(another.transforms, expected.transforms)).toBe(true) -- expect lazy transform, i.e. only the transforms change
	expected.transforms = { 0, 1, 0, 0, -1, 0, 0, 0, 0, 0, 1, 0, 5, 10, 15, 1 }
	another = transform(mat4.fromTranslation(mat4.create(), { 5, 10, 15 }), another)
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
	expect(compareVectors(another.transforms, expected.transforms)).toBe(true) -- expect application of the transforms to the sides
	expected.sides = { { { 4, 10 }, { 5, 10 } }, { { 5, 10 }, { 5, 11 } }, { { 5, 11 }, { 4, 10 } } }
	expected.transforms = mat4.create()
	toSides(another)
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
	expect(compareVectors(another.transforms, expected.transforms)).toBe(true) -- expect lazy transform, i.e. only the transforms change
	expected.transforms = { 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 5, 10, 15, 1 }
	another = transform(mat4.fromTranslation(mat4.create(), { 5, 10, 15 }), another)
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
test("transform: geom2 mirrorX", function()
	local geometry = square()
	local transformed = mirrorX(geometry)
	expect(measureArea(geometry)).toBe(4) -- area will be negative unless we reversed the points
	expect(measureArea(transformed)).toBe(4)
	local pts = toOutlines(transformed)[
		1 --[[ ROBLOX adaptation: added 1 to array index ]]
	]
	local exp = { { -1, 1 }, { -1, -1 }, { 1, -1 }, { 1, 1 } }
	expect(comparePoints(pts, exp)).toBe(true)
	expect(toSides(transformed)).toEqual({
		{ { 1, 1 }, { -1, 1 } },
		{ { -1, 1 }, { -1, -1 } },
		{ { -1, -1 }, { 1, -1 } },
		{ { 1, -1 }, { 1, 1 } },
	})
end)
test("transform: geom2 mirrorY", function()
	local geometry = square()
	local transformed = mirrorY(geometry)
	expect(measureArea(geometry)).toBe(4) -- area will be negative unless we reversed the points
	expect(measureArea(transformed)).toBe(4)
	local pts = toOutlines(transformed)[
		1 --[[ ROBLOX adaptation: added 1 to array index ]]
	]
	local exp = { { 1, -1 }, { 1, 1 }, { -1, 1 }, { -1, -1 } }
	expect(comparePoints(pts, exp)).toBe(true)
	expect(toSides(transformed)).toEqual({
		{ { -1, -1 }, { 1, -1 } },
		{ { 1, -1 }, { 1, 1 } },
		{ { 1, 1 }, { -1, 1 } },
		{ { -1, 1 }, { -1, -1 } },
	})
end)
test("transform: geom2 mirrorZ", function()
	local geometry = square()
	local transformed = mirrorZ(geometry)
	expect(measureArea(geometry)).toBe(4) -- area will be negative unless we DIDN'T reverse the points
	expect(measureArea(transformed)).toBe(4)
	local pts = toOutlines(transformed)[
		1 --[[ ROBLOX adaptation: added 1 to array index ]]
	]
	local exp = { { -1, -1 }, { 1, -1 }, { 1, 1 }, { -1, 1 } }
	expect(comparePoints(pts, exp)).toBe(true)
	expect(toSides(transformed)).toEqual({
		{ { -1, 1 }, { -1, -1 } },
		{ { -1, -1 }, { 1, -1 } },
		{ { 1, -1 }, { 1, 1 } },
		{ { 1, 1 }, { -1, 1 } },
	})
end)
