-- ROBLOX NOTE: no upstream
local JestGlobals = require("@DevPackages/JestGlobals")
local test, expect = JestGlobals.test, JestGlobals.expect

local transform, create, fromPoints
do
	local ref = require("./init")
	transform, create, fromPoints = ref.transform, ref.create, ref.fromPoints
end
local compareVectors = require("../../../test/helpers/init").compareVectors
test("line3: transform() called with three parameters should update a line3 with correct values", function()
	local line1 = create()
	local line2 = fromPoints(create(), { 1, 0, 0 }, { 0, 1, 0 })
	local line3 = fromPoints(create(), { -3, -3, -3 }, { 3, 3, 3 })
	local identityMatrix = { 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1 }
	local obs1 = create()
	local ret1 = transform(obs1, line1, identityMatrix)
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
		{ 0, 0, 1 }
	)).toBe(true)
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
		{ 0, 0, 1 }
	)).toBe(true)
	expect(line1).never.toBe(obs1)
	expect(ret1).toBe(obs1)
	ret1 = transform(obs1, line2, identityMatrix)
	expect(compareVectors(
		ret1[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		],
		{ 1, 0, 0 }
	)).toBe(true)
	expect(compareVectors(
		ret1[
			2 --[[ ROBLOX adaptation: added 1 to array index ]]
		],
		{ -0.7071067811865475, 0.7071067811865475, 0 }
	)).toBe(true)
	expect(compareVectors(
		obs1[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		],
		{ 1, 0, 0 }
	)).toBe(true)
	expect(compareVectors(
		obs1[
			2 --[[ ROBLOX adaptation: added 1 to array index ]]
		],
		{ -0.7071067811865475, 0.7071067811865475, 0 }
	)).toBe(true)
	ret1 = transform(obs1, line3, identityMatrix)
	expect(compareVectors(
		ret1[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		],
		{ -3, -3, -3 }
	)).toBe(true)
	expect(compareVectors(
		ret1[
			2 --[[ ROBLOX adaptation: added 1 to array index ]]
		],
		{ 0.5773502691896258, 0.5773502691896258, 0.5773502691896258 }
	)).toBe(true)
	expect(compareVectors(
		obs1[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		],
		{ -3, -3, -3 }
	)).toBe(true)
	expect(compareVectors(
		obs1[
			2 --[[ ROBLOX adaptation: added 1 to array index ]]
		],
		{ 0.5773502691896258, 0.5773502691896258, 0.5773502691896258 }
	)).toBe(true)
	local x = 1
	local y = 5
	local z = 7
	local translationMatrix = { 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, x, y, z, 1 } -- transform in place
	local ret2 = transform(line1, line1, translationMatrix)
	expect(compareVectors(
		ret2[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		],
		{ 1, 5, 7 }
	)).toBe(true)
	expect(compareVectors(
		ret2[
			2 --[[ ROBLOX adaptation: added 1 to array index ]]
		],
		{ 0, 0, 1 }
	)).toBe(true)
	expect(compareVectors(
		line1[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		],
		{ 1, 5, 7 }
	)).toBe(true)
	expect(compareVectors(
		line1[
			2 --[[ ROBLOX adaptation: added 1 to array index ]]
		],
		{ 0, 0, 1 }
	)).toBe(true)
	expect(ret2).toBe(line1)
	ret2 = transform(line2, line2, translationMatrix)
	expect(compareVectors(
		ret2[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		],
		{ 2, 5, 7 }
	)).toBe(true)
	expect(compareVectors(
		ret2[
			2 --[[ ROBLOX adaptation: added 1 to array index ]]
		],
		{ -0.7071067811865474, 0.7071067811865478, 0 }
	)).toBe(true)
	expect(compareVectors(
		line2[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		],
		{ 2, 5, 7 }
	)).toBe(true)
	expect(compareVectors(
		line2[
			2 --[[ ROBLOX adaptation: added 1 to array index ]]
		],
		{ -0.7071067811865474, 0.7071067811865478, 0 }
	)).toBe(true)
	expect(ret2).toBe(line2)
	ret2 = transform(line3, line3, translationMatrix)
	expect(compareVectors(
		ret2[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		],
		{ -2, 2, 4 }
	)).toBe(true)
	expect(compareVectors(
		ret2[
			2 --[[ ROBLOX adaptation: added 1 to array index ]]
		],
		{ 0.5773502691896256, 0.5773502691896256, 0.5773502691896261 }
	)).toBe(true)
	expect(compareVectors(
		line3[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		],
		{ -2, 2, 4 }
	)).toBe(true)
	expect(compareVectors(
		line3[
			2 --[[ ROBLOX adaptation: added 1 to array index ]]
		],
		{ 0.5773502691896256, 0.5773502691896256, 0.5773502691896261 }
	)).toBe(true)
	expect(ret2).toBe(line3)
end)
