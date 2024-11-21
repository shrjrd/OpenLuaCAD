-- ROBLOX NOTE: no upstream
local JestGlobals = require("@DevPackages/JestGlobals")
local test, expect = JestGlobals.test, JestGlobals.expect

local hsvToRgb = require("./init").hsvToRgb
test("hsvToRgb (HSV values)", function()
	local obs = hsvToRgb({ 0, 0.2, 0 })
	local exp = { 0, 0, 0 }
	expect(obs).toEqual(exp)
	obs = hsvToRgb(0.9166666666666666, 1, 1)
	exp = { 1, 0, 0.5 }
	expect(obs).toEqual(exp)
end)
test("hsvToRgb (HSVA values)", function()
	local obs = hsvToRgb({ 0, 0.2, 0, 1 })
	local exp = { 0, 0, 0, 1 }
	expect(obs).toEqual(exp)
	obs = hsvToRgb(0.9166666666666666, 1, 1, 0.5)
	exp = { 1, 0, 0.5, 0.5 }
	expect(obs).toEqual(exp)
end)
