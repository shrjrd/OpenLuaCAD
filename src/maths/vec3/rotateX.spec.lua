-- ROBLOX NOTE: no upstream
local JestGlobals = require("@DevPackages/JestGlobals")
local test, expect = JestGlobals.test, JestGlobals.expect

local TAU = require("../constants").TAU
local rotateX, fromValues
do
	local ref = require("./init")
	rotateX, fromValues = ref.rotateX, ref.fromValues
end
local compareVectors = require("../../../test/helpers/init").compareVectors
test("vec3. rotateX() called with four parameters should update a vec3 with correct values", function()
	local radians = TAU / 4
	local obs1 = fromValues(0, 0, 0)
	local ret1 = rotateX(obs1, { 0, 0, 0 }, { 0, 0, 0 }, 0)
	expect(compareVectors(obs1, { 0, 0, 0 })).toBe(true)
	expect(compareVectors(ret1, { 0, 0, 0 })).toBe(true)
	local obs2 = fromValues(0, 0, 0)
	local ret2 = rotateX(obs2, { 3, 2, 1 }, { 1, 2, 3 }, 0)
	expect(compareVectors(obs2, { 3, 2, 1 })).toBe(true)
	expect(compareVectors(ret2, { 3, 2, 1 })).toBe(true)
	local obs3 = fromValues(0, 0, 0)
	local ret3 = rotateX(obs3, { -1, -2, -3 }, { 1, 2, 3 }, radians)
	expect(compareVectors(obs3, { -1, 8, -1 })).toBe(true)
	expect(compareVectors(ret3, { -1, 8, -1 })).toBe(true)
	local obs4 = fromValues(0, 0, 0)
	local ret4 = rotateX(obs4, { 1, 2, 3 }, { -1, -2, -3 }, -radians)
	expect(compareVectors(obs4, { 1, 4, -7 })).toBe(true)
	expect(compareVectors(ret4, { 1, 4, -7 })).toBe(true)
end)