-- ROBLOX NOTE: no upstream
local JestGlobals = require("@DevPackages/JestGlobals")
local test, expect = JestGlobals.test, JestGlobals.expect

local multiply = require("./init").multiply
local compareVectors = require("../../../test/helpers/init").compareVectors
test("mat4. multiply() called with out parameter should return a new mat4 with correct values", function()
	local obs1 = { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 }
	local ret1 = multiply(
		obs1,
		{ 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16 },
		{ 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16 }
	)
	expect(compareVectors(obs1, { 90, 100, 110, 120, 202, 228, 254, 280, 314, 356, 398, 440, 426, 484, 542, 600 })).toBe(
		true
	)
	expect(compareVectors(ret1, { 90, 100, 110, 120, 202, 228, 254, 280, 314, 356, 398, 440, 426, 484, 542, 600 })).toBe(
		true
	)
	expect(obs1).toBe(ret1)
	local obs2 = { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 }
	local ret2 = multiply(
		obs2,
		{ -1, -2, -3, -4, -5, -6, -7, -8, -9, -10, -11, -12, -13, -14, -15, -16 },
		{ -1, -2, -3, -4, -5, -6, -7, -8, -9, -10, -11, -12, -13, -14, -15, -16 }
	)
	expect(compareVectors(obs2, { 90, 100, 110, 120, 202, 228, 254, 280, 314, 356, 398, 440, 426, 484, 542, 600 })).toBe(
		true
	)
	expect(compareVectors(ret2, { 90, 100, 110, 120, 202, 228, 254, 280, 314, 356, 398, 440, 426, 484, 542, 600 })).toBe(
		true
	)
	local obs3 = { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 }
	local ret3 = multiply(
		obs3,
		{ 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16 },
		{ -1, -2, -3, -4, -5, -6, -7, -8, -9, -10, -11, -12, -13, -14, -15, -16 }
	)
	expect(compareVectors(obs3, {
		-90,
		-100,
		-110,
		-120,
		-202,
		-228,
		-254,
		-280,
		-314,
		-356,
		-398,
		-440,
		-426,
		-484,
		-542,
		-600,
	})).toBe(true)
	expect(compareVectors(ret3, {
		-90,
		-100,
		-110,
		-120,
		-202,
		-228,
		-254,
		-280,
		-314,
		-356,
		-398,
		-440,
		-426,
		-484,
		-542,
		-600,
	})).toBe(true)
end)
