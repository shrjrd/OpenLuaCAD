-- ROBLOX NOTE: no upstream
local JestGlobals = require("@DevPackages/JestGlobals")
local test, expect = JestGlobals.test, JestGlobals.expect

local rotateY, create
do
	local ref = require("./init")
	rotateY, create = ref.rotateY, ref.create
end
local compareVectors = require("../../../test/helpers/init").compareVectors
test("mat4. rotateY() called with out parameter should return a new mat4 with correct values", function()
	local rotation = 90 * 0.017453292519943295
	local idn = create()
	local out2 = { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 }
	local ret2 = rotateY(out2, idn, rotation)
	expect(compareVectors(out2, { 0, 0, -1, 0, 0, 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, 1 })).toBe(true)
	expect(compareVectors(ret2, { 0, 0, -1, 0, 0, 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, 1 })).toBe(true)
	expect(out2).toBe(ret2)
	local out3 = create()
	local ret3 = rotateY(out3, out3, -rotation)
	expect(compareVectors(out3, { 0, 0, 1, 0, 0, 1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 1 })).toBe(true)
	expect(compareVectors(ret3, { 0, 0, 1, 0, 0, 1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 1 })).toBe(true)
end)
