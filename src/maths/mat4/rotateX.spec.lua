-- ROBLOX NOTE: no upstream
local JestGlobals = require("@DevPackages/JestGlobals")
local test, expect = JestGlobals.test, JestGlobals.expect

local rotateX, create
do
	local ref = require("./init")
	rotateX, create = ref.rotateX, ref.create
end
local compareVectors = require("../../../test/helpers/init").compareVectors
test("mat4. rotateX() called with out parameter should return a new mat4 with correct values", function()
	local rotation = 90 * 0.017453292519943295
	local idn = create()
	local out2 = { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 }
	local ret2 = rotateX(out2, idn, rotation)
	expect(compareVectors(out2, { 1, 0, 0, 0, 0, 0, 1, 0, 0, -1, 0, 0, 0, 0, 0, 1 })).toBe(true)
	expect(compareVectors(ret2, { 1, 0, 0, 0, 0, 0, 1, 0, 0, -1, 0, 0, 0, 0, 0, 1 })).toBe(true)
	expect(out2).toBe(ret2)
	local out3 = create()
	local ret3 = rotateX(out3, out3, -rotation)
	expect(compareVectors(out3, { 1, 0, 0, 0, 0, 0, -1, 0, 0, 1, 0, 0, 0, 0, 0, 1 })).toBe(true)
	expect(compareVectors(ret3, { 1, 0, 0, 0, 0, 0, -1, 0, 0, 1, 0, 0, 0, 0, 0, 1 })).toBe(true)
end)
