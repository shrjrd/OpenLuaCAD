-- ROBLOX NOTE: no upstream
local JestGlobals = require("@DevPackages/JestGlobals")
local test, expect = JestGlobals.test, JestGlobals.expect

local min, fromValues
do
	local ref = require("./init")
	min, fromValues = ref.min, ref.fromValues
end
local compareVectors = require("../../../test/helpers/init").compareVectors
test("vec2. min() called with three parameters should update a vec2 with correct values", function()
	local obs1 = fromValues(0, 0)
	local vec0 = fromValues(0, 0)
	local vec1 = fromValues(0, 0)
	local ret1 = min(obs1, vec0, vec1)
	expect(compareVectors(obs1, { 0, 0 })).toBe(true)
	expect(compareVectors(ret1, { 0, 0 })).toBe(true)
	local obs2 = fromValues(0, 0)
	local vec2 = fromValues(1, 1)
	local ret2 = min(obs2, vec0, vec2)
	expect(compareVectors(obs2, { 0, 0 })).toBe(true)
	expect(compareVectors(ret2, { 0, 0 })).toBe(true)
	local obs3 = fromValues(0, 0)
	local vec3 = fromValues(0, 1)
	local ret3 = min(obs3, vec0, vec3)
	expect(compareVectors(obs3, { 0, 0 })).toBe(true)
	expect(compareVectors(ret3, { 0, 0 })).toBe(true)
	local obs4 = fromValues(0, 0)
	local vec4 = fromValues(0, 0)
	local ret4 = min(obs4, vec0, vec4)
	expect(compareVectors(obs4, { 0, 0 })).toBe(true)
	expect(compareVectors(ret4, { 0, 0 })).toBe(true)
end)
