-- ROBLOX NOTE: no upstream
local JestGlobals = require("@DevPackages/JestGlobals")
local test, expect = JestGlobals.test, JestGlobals.expect

local plane = require("../plane")
local mirrorByPlane, create
do
	local ref = require("./init")
	mirrorByPlane, create = ref.mirrorByPlane, ref.create
end
local compareVectors = require("../../../test/helpers").compareVectors
test("mat4. mirrorByPlane() called with out parameter should return a new mat4 with correct values", function()
	local planeX = plane.fromPoints(plane.create(), { 0, 0, 0 }, { 0, 1, 1 }, { 0, 1, 0 })
	local planeY = plane.fromPoints(plane.create(), { 0, 0, 0 }, { 1, 0, 0 }, { 1, 0, 1 })
	local planeZ = plane.fromPoints(plane.create(), { 0, 0, 0 }, { 1, 0, 0 }, { 1, 1, 0 })
	local out1 = create()
	local ret1 = mirrorByPlane(out1, planeX)
	expect(compareVectors(out1, { -1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1 })).toBe(true)
	expect(compareVectors(ret1, { -1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1 })).toBe(true)
	local out2 = create()
	local ret2 = mirrorByPlane(out2, planeY)
	expect(compareVectors(out2, { 1, 0, 0, 0, 0, -1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1 })).toBe(true)
	expect(compareVectors(ret2, { 1, 0, 0, 0, 0, -1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1 })).toBe(true)
	local out3 = create()
	local ret3 = mirrorByPlane(out3, planeZ)
	expect(compareVectors(out3, { 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, -1, 0, 0, 0, 0, 1 })).toBe(true)
	expect(compareVectors(ret3, { 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, -1, 0, 0, 0, 0, 1 })).toBe(true)
end)
