-- ROBLOX NOTE: no upstream
local JestGlobals = require("@DevPackages/JestGlobals")
local test, expect = JestGlobals.test, JestGlobals.expect

local scale = require("./init").scale
local compareVectors = require("../../../test/helpers/init").compareVectors
test("mat4. scale() called with out parameter should return a new mat4 with correct values", function()
	local obs1 = { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 }
	local ret1 = scale(obs1, { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16 }, { 1, 1, 1 })
	expect(compareVectors(obs1, { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16 })).toBe(true)
	expect(compareVectors(ret1, { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16 })).toBe(true)
	local obs2 = { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 }
	local ret2 = scale(obs2, { -1, -2, -3, -4, -5, -6, -7, -8, -9, -10, -11, -12, -13, -14, -15, -16 }, { 2, 4, 6 })
	expect(compareVectors(obs2, { -2, -4, -6, -8, -20, -24, -28, -32, -54, -60, -66, -72, -13, -14, -15, -16 })).toBe(
		true
	)
	expect(compareVectors(ret2, { -2, -4, -6, -8, -20, -24, -28, -32, -54, -60, -66, -72, -13, -14, -15, -16 })).toBe(
		true
	)
	local obs3 = { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 }
	local ret3 = scale(obs3, { -1, -2, -3, -4, -5, -6, -7, -8, -9, -10, -11, -12, -13, -14, -15, -16 }, { 6, 4, 2 })
	expect(compareVectors(obs3, { -6, -12, -18, -24, -20, -24, -28, -32, -18, -20, -22, -24, -13, -14, -15, -16 })).toBe(
		true
	)
	expect(compareVectors(ret3, { -6, -12, -18, -24, -20, -24, -28, -32, -18, -20, -22, -24, -13, -14, -15, -16 })).toBe(
		true
	)
end)
