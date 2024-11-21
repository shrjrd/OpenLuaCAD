-- ROBLOX NOTE: no upstream
local JestGlobals = require("@DevPackages/JestGlobals")
local test, expect = JestGlobals.test, JestGlobals.expect

local TAU = require("../constants").TAU
local rotate, fromValues
do
	local ref = require("./init")
	rotate, fromValues = ref.rotate, ref.fromValues
end
local compareVectors = require("../../../test/helpers/init").compareVectors
test("vec2. rotate() called with three parameters should update a vec2 with correct values", function()
	local radians = TAU / 4
	local obs1 = fromValues(0, 0)
	local ret1 = rotate(obs1, { 0, 0 }, { 0, 0 }, 0)
	expect(compareVectors(obs1, { 0, 0 })).toBe(true)
	expect(compareVectors(ret1, { 0, 0 })).toBe(true)
	local obs2 = fromValues(0, 0)
	local ret2 = rotate(obs2, { 1, 2 }, { 0, 0 }, 0)
	expect(compareVectors(obs2, { 1, 2 })).toBe(true)
	expect(compareVectors(ret2, { 1, 2 })).toBe(true)
	local obs3 = fromValues(0, 0)
	local ret3 = rotate(obs3, { -1, -2 }, { 0, 0 }, radians)
	expect(compareVectors(obs3, { 2, -1 }, 1e-15)).toBe(true)
	expect(compareVectors(ret3, { 2, -1 }, 1e-15)).toBe(true)
	local obs4 = fromValues(0, 0)
	local ret4 = rotate(obs4, { -1, 2 }, { -3, -3 }, -radians)
	expect(compareVectors(obs4, { 2, -5 }, 1e-15)).toBe(true)
	expect(compareVectors(ret4, { 2, -5 }, 1e-15)).toBe(true)
end)
