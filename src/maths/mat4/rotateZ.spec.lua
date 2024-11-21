-- ROBLOX NOTE: no upstream
local JestGlobals = require("@DevPackages/JestGlobals")
local test, expect = JestGlobals.test, JestGlobals.expect

local rotateZ, create
do
	local ref = require("./init")
	rotateZ, create = ref.rotateZ, ref.create
end
local compareVectors = require("../../../test/helpers/init").compareVectors
test("mat4. rotateZ() called with out parameter should return a new mat4 with correct values", function()
	local rotation = 90 * 0.017453292519943295
	local idn = create()
	local out2 = { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 }
	local ret2 = rotateZ(out2, idn, rotation)
	expect(compareVectors(out2, { 0, 1, 0, 0, -1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1 })).toBe(true)
	expect(compareVectors(ret2, { 0, 1, 0, 0, -1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1 })).toBe(true)
	expect(out2).toBe(ret2)
	local out3 = create()
	local ret3 = rotateZ(out3, out3, -rotation)
	expect(compareVectors(out3, { 0, -1, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1 })).toBe(true)
	expect(compareVectors(ret3, { 0, -1, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1 })).toBe(true)
end)
