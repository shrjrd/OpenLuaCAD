-- ROBLOX NOTE: no upstream
local JestGlobals = require("@DevPackages/JestGlobals")
local test, expect = JestGlobals.test, JestGlobals.expect

local create, copy, fromPointAndDirection
do
	local ref = require("./init")
	create, copy, fromPointAndDirection = ref.create, ref.copy, ref.fromPointAndDirection
end
local compareVectors = require("../../../test/helpers/init").compareVectors
test("line3: copy() with two params should update a line3 with same values", function()
	local line1 = create()
	local org1 = fromPointAndDirection(create(), { 0, 0, 0 }, { 1, 0, 0 })
	local ret1 = copy(line1, org1)
	expect(compareVectors(
		line1[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		],
		{ 0, 0, 0 }
	)).toBe(true)
	expect(compareVectors(
		line1[
			2 --[[ ROBLOX adaptation: added 1 to array index ]]
		],
		{ 1, 0, 0 }
	)).toBe(true)
	expect(compareVectors(
		ret1[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		],
		{ 0, 0, 0 }
	)).toBe(true)
	expect(compareVectors(
		ret1[
			2 --[[ ROBLOX adaptation: added 1 to array index ]]
		],
		{ 1, 0, 0 }
	)).toBe(true)
	expect(ret1).never.toBe(org1)
	local line2 = create()
	local org2 = fromPointAndDirection(create(), { 1, 2, 3 }, { 1, 0, 1 })
	local ret2 = copy(line2, org2)
	expect(compareVectors(
		line2[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		],
		{ 1, 2, 3 }
	)).toBe(true)
	expect(compareVectors(
		line2[
			2 --[[ ROBLOX adaptation: added 1 to array index ]]
		],
		{ 0.7071067811865475, 0, 0.7071067811865475 }
	)).toBe(true)
	expect(compareVectors(
		ret2[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		],
		{ 1, 2, 3 }
	)).toBe(true)
	expect(compareVectors(
		ret2[
			2 --[[ ROBLOX adaptation: added 1 to array index ]]
		],
		{ 0.7071067811865475, 0, 0.7071067811865475 }
	)).toBe(true)
	expect(ret2).never.toBe(org2)
	local line3 = create()
	local org3 = fromPointAndDirection(create(), { -1, -2, -3 }, { 0, -1, -1 })
	local ret3 = copy(line3, org3)
	expect(compareVectors(
		line3[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		],
		{ -1, -2, -3 }
	)).toBe(true)
	expect(compareVectors(
		line3[
			2 --[[ ROBLOX adaptation: added 1 to array index ]]
		],
		{ 0, -0.7071067811865475, -0.7071067811865475 }
	)).toBe(true)
	expect(compareVectors(
		ret3[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		],
		{ -1, -2, -3 }
	)).toBe(true)
	expect(compareVectors(
		ret3[
			2 --[[ ROBLOX adaptation: added 1 to array index ]]
		],
		{ 0, -0.7071067811865475, -0.7071067811865475 }
	)).toBe(true)
	expect(ret3).never.toBe(org3)
end)
