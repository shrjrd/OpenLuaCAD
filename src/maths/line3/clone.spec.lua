-- ROBLOX NOTE: no upstream
local JestGlobals = require("@DevPackages/JestGlobals")
local test, expect = JestGlobals.test, JestGlobals.expect

local create, clone, fromPointAndDirection
do
	local ref = require("./init")
	create, clone, fromPointAndDirection = ref.create, ref.clone, ref.fromPointAndDirection
end
local compareVectors = require("../../../test/helpers/init").compareVectors
test("line3: clone() should return a new line3 with same values", function()
	local org1 = fromPointAndDirection(create(), { 0, 0, 0 }, { 1, 0, 0 })
	local obs1 = clone(org1)
	expect(compareVectors(
		obs1[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		],
		{ 0, 0, 0 }
	)).toBe(true)
	expect(compareVectors(
		obs1[
			2 --[[ ROBLOX adaptation: added 1 to array index ]]
		],
		{ 1, 0, 0 }
	)).toBe(true)
	expect(obs1)["not"].toBe(org1)
	local org2 = fromPointAndDirection(create(), { 1, 2, 3 }, { 1, 0, 1 })
	local obs2 = clone(org2)
	expect(compareVectors(
		obs2[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		],
		{ 1, 2, 3 }
	)).toBe(true)
	expect(compareVectors(
		obs2[
			2 --[[ ROBLOX adaptation: added 1 to array index ]]
		],
		{ 0.7071067811865475, 0, 0.7071067811865475 }
	)).toBe(true)
	expect(obs2)["not"].toBe(org2)
	local org3 = fromPointAndDirection(create(), { -1, -2, -3 }, { 0, -1, -1 })
	local obs3 = clone(org3)
	expect(compareVectors(
		obs3[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		],
		{ -1, -2, -3 }
	)).toBe(true)
	expect(compareVectors(
		obs3[
			2 --[[ ROBLOX adaptation: added 1 to array index ]]
		],
		{ 0, -0.7071067811865475, -0.7071067811865475 }
	)).toBe(true)
	expect(obs3)["not"].toBe(org3)
end)
