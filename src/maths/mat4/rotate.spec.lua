-- ROBLOX NOTE: no upstream
local JestGlobals = require("@DevPackages/JestGlobals")
local test, expect = JestGlobals.test, JestGlobals.expect

local rotate, create
do
	local ref = require("./init")
	rotate, create = ref.rotate, ref.create
end
local compareVectors = require("../../../test/helpers/init").compareVectors
test("mat4. rotate() called with out parameter should return a new mat4 with correct values", function()
	local rotation = 90 * 0.017453292519943295
	local idn = create() -- invalid condition when axis is 0,0,0
	local out1 = { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 }
	local ret1 = rotate(out1, idn, rotation, { 0, 0, 0 })
	expect(out1).toBe(ret1)
	expect(compareVectors(out1, { 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1 })).toBe(true)
	local out2 = { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 }
	local ret2 = rotate(out2, idn, rotation, { 0, 0, 1 })
	expect(compareVectors(out2, { 0, 1, 0, 0, -1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1 })).toBe(true)
	expect(compareVectors(ret2, { 0, 1, 0, 0, -1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1 })).toBe(true)
	expect(out2).toBe(ret2)
	local out3 = create()
	local ret3 = rotate(out3, out3, -rotation, { 0, 0, 1 })
	expect(compareVectors(out3, { 0, -1, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1 })).toBe(true)
	expect(compareVectors(ret3, { 0, -1, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1 })).toBe(true)
end)
