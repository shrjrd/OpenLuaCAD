-- ROBLOX NOTE: no upstream
local JestGlobals = require("@DevPackages/JestGlobals")
local test, expect = JestGlobals.test, JestGlobals.expect

local TAU = require("../constants").TAU
local cos, sin
do
	local ref = require("./trigonometry")
	cos, sin = ref.cos, ref.sin
end
test("utils: sin() should return rounded values", function()
	expect(sin(0)).toBe(0)
	expect(sin(9)).toBe(math.sin(9))
	expect(sin(0.25 * TAU)).toBe(1)
	expect(sin(0.5 * TAU)).toBe(0)
	expect(sin(0.75 * TAU)).toBe(-1)
	expect(sin(TAU)).toBe(0)
	expect(sin(0 / 0)).toBe(0 / 0)
	expect(sin(math.huge)).toBe(0 / 0)
end)
test("utils: cos() should return rounded values", function()
	expect(cos(0)).toBe(1)
	expect(cos(9)).toBe(math.cos(9))
	expect(cos(0.25 * TAU)).toBe(0)
	expect(cos(0.5 * TAU)).toBe(-1)
	expect(cos(0.75 * TAU)).toBe(0)
	expect(cos(TAU)).toBe(1)
	expect(cos(0 / 0)).toBe(0 / 0)
	expect(cos(math.huge)).toBe(0 / 0)
end)
