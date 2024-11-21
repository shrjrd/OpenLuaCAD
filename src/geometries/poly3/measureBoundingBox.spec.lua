-- ROBLOX NOTE: no upstream
local JestGlobals = require("@DevPackages/JestGlobals")
local test, expect = JestGlobals.test, JestGlobals.expect

local measureBoundingBox, create, fromPoints, transform
do
	local ref = require("./init")
	measureBoundingBox, create, fromPoints, transform =
		ref.measureBoundingBox, ref.create, ref.fromPoints, ref.transform
end
local mat4 = require("../../maths/mat4")
local compareVectors = require("../../../test/helpers/init").compareVectors
test("poly3. measureBoundingBox() should return correct values", function()
	local ply1 = create()
	local exp1 = { { 0, 0, 0 }, { 0, 0, 0 } }
	local ret1 = measureBoundingBox(ply1)
	expect(compareVectors(
		ret1[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		],
		exp1[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		]
	)).toBe(true)
	expect(compareVectors(
		ret1[
			2 --[[ ROBLOX adaptation: added 1 to array index ]]
		],
		exp1[
			2 --[[ ROBLOX adaptation: added 1 to array index ]]
		]
	)).toBe(true) -- simple triangle
	local ply2 = fromPoints({ { 0, 0, 0 }, { 0, 10, 0 }, { 0, 10, 10 } })
	local exp2 = { { 0, 0, 0 }, { 0, 10, 10 } }
	local ret2 = measureBoundingBox(ply2)
	expect(compareVectors(
		ret2[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		],
		exp2[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		]
	)).toBe(true)
	expect(compareVectors(
		ret2[
			2 --[[ ROBLOX adaptation: added 1 to array index ]]
		],
		exp2[
			2 --[[ ROBLOX adaptation: added 1 to array index ]]
		]
	)).toBe(true) -- simple square
	local ply3 = fromPoints({ { 0, 0, 0 }, { 0, 10, 0 }, { 0, 10, 10 }, { 0, 0, 10 } })
	local exp3 = { { 0, 0, 0 }, { 0, 10, 10 } }
	local ret3 = measureBoundingBox(ply3)
	expect(compareVectors(
		ret3[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		],
		exp3[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		]
	)).toBe(true)
	expect(compareVectors(
		ret3[
			2 --[[ ROBLOX adaptation: added 1 to array index ]]
		],
		exp3[
			2 --[[ ROBLOX adaptation: added 1 to array index ]]
		]
	)).toBe(true) -- V-shape
	local points = {
		{ 0, 3, 0 },
		{ 0, 5, 0 },
		{ 0, 8, 2 },
		{ 0, 6, 5 },
		{ 0, 8, 6 },
		{ 0, 5, 6 },
		{ 0, 5, 2 },
		{ 0, 2, 5 },
		{ 0, 1, 3 },
		{ 0, 3, 3 },
	}
	local ply4 = fromPoints(points)
	local exp4 = { { 0, 1, 0 }, { 0, 8, 6 } }
	local ret4 = measureBoundingBox(ply4)
	expect(compareVectors(
		ret4[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		],
		exp4[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		]
	)).toBe(true)
	expect(compareVectors(
		ret4[
			2 --[[ ROBLOX adaptation: added 1 to array index ]]
		],
		exp4[
			2 --[[ ROBLOX adaptation: added 1 to array index ]]
		]
	)).toBe(true) -- rotated to various angles
	local rotation = mat4.fromZRotation(mat4.create(), 45 * 0.017453292519943295)
	ply1 = transform(rotation, ply1)
	ply2 = transform(rotation, ply2)
	ply3 = transform(rotation, ply3)
	ply4 = transform(rotation, ply4)
	ret1 = measureBoundingBox(ply1)
	ret2 = measureBoundingBox(ply2)
	ret3 = measureBoundingBox(ply3)
	ret4 = measureBoundingBox(ply4)
	exp1 = { { 0, 0, 0 }, { 0, 0, 0 } }
	expect(compareVectors(
		ret1[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		],
		exp1[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		]
	)).toBe(true)
	expect(compareVectors(
		ret1[
			2 --[[ ROBLOX adaptation: added 1 to array index ]]
		],
		exp1[
			2 --[[ ROBLOX adaptation: added 1 to array index ]]
		]
	)).toBe(true)
	exp2 = { { -7.071067811865475, 0, 0 }, { 0, 7.0710678118654755, 10 } }
	expect(compareVectors(
		ret2[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		],
		exp2[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		]
	)).toBe(true)
	expect(compareVectors(
		ret2[
			2 --[[ ROBLOX adaptation: added 1 to array index ]]
		],
		exp2[
			2 --[[ ROBLOX adaptation: added 1 to array index ]]
		]
	)).toBe(true)
	exp3 = { { -7.071067811865475, 0, 0 }, { 0, 7.0710678118654755, 10 } }
	expect(compareVectors(
		ret3[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		],
		exp3[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		]
	)).toBe(true)
	expect(compareVectors(
		ret3[
			2 --[[ ROBLOX adaptation: added 1 to array index ]]
		],
		exp3[
			2 --[[ ROBLOX adaptation: added 1 to array index ]]
		]
	)).toBe(true)
	exp4 = {
		{ -5.65685424949238, 0.7071067811865476, 0 },
		{ -0.7071067811865475, 5.656854249492381, 6 },
	}
	expect(compareVectors(
		ret4[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		],
		exp4[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		]
	)).toBe(true)
	expect(compareVectors(
		ret4[
			2 --[[ ROBLOX adaptation: added 1 to array index ]]
		],
		exp4[
			2 --[[ ROBLOX adaptation: added 1 to array index ]]
		]
	)).toBe(true)
end)
