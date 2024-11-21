-- ROBLOX NOTE: no upstream
local JestGlobals = require("@DevPackages/JestGlobals")
local test, expect = JestGlobals.test, JestGlobals.expect

local hslToRgb = require("./init").hslToRgb
test("hslToRgb (HSL values)", function()
	local obs = hslToRgb({ 0, 1, 0 })
	local exp = { 0, 0, 0 }
	expect(obs).toEqual(exp)
	obs = hslToRgb({ 0.9166666666666666, 1, 0.5 })
	exp = { 1, 0, 0.5000000000000002 }
	expect(obs).toEqual(exp)
	obs = hslToRgb(0.9166666666666666, 0, 0.5)
	exp = { 0.5, 0.5, 0.5 }
	expect(obs).toEqual(exp)
end)
test("hslToRgb (HSLA values)", function()
	local obs = hslToRgb({ 0, 1, 0, 1 })
	local exp = { 0, 0, 0, 1 }
	expect(obs).toEqual(exp)
	obs = hslToRgb({ 0.9166666666666666, 1, 0.5, 1 })
	exp = { 1, 0, 0.5000000000000002, 1 }
	expect(obs).toEqual(exp)
	obs = hslToRgb(0.9166666666666666, 0, 0.5, 0.5)
	exp = { 0.5, 0.5, 0.5, 0.5 }
	expect(obs).toEqual(exp)
end)
