-- ROBLOX NOTE: no upstream
local JestGlobals = require("@DevPackages/JestGlobals")
local test, expect = JestGlobals.test, JestGlobals.expect

local create, normal
do
	local ref = require("./init")
	create, normal = ref.create, ref.normal
end
local compareVectors = require("../../../test/helpers/init").compareVectors
test("vec2. normal() with two params should update a vec2 with correct values", function()
	local out1 = create()
	local ret1 = normal(out1, { 0, 0 })
	expect(compareVectors(out1, { 0, 0 })).toBe(true)
	expect(compareVectors(ret1, { 0, 0 })).toBe(true)
	expect(out1).toBe(ret1)
	local out2 = create()
	local ret2 = normal(out2, { 1, 2 })
	expect(compareVectors(out2, { -2, 1 }, 1e-15)).toBe(true)
	expect(compareVectors(ret2, { -2, 1 }, 1e-15)).toBe(true)
	expect(out2).toBe(ret2)
	local out3 = create()
	local ret3 = normal(out3, { -1, -2 })
	expect(compareVectors(out3, { 2, -1 }, 1e-15)).toBe(true)
	expect(compareVectors(ret3, { 2, -1 }, 1e-15)).toBe(true)
	expect(out3).toBe(ret3)
	local out4 = create()
	local ret4 = normal(out4, { -1, 2 })
	expect(compareVectors(out4, { -2, -1 }, 1e-15)).toBe(true)
	expect(compareVectors(ret4, { -2, -1 }, 1e-15)).toBe(true)
	expect(out4).toBe(ret4)
end)
