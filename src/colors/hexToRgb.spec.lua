-- ROBLOX NOTE: no upstream
local JestGlobals = require("@DevPackages/JestGlobals")
local test, expect = JestGlobals.test, JestGlobals.expect

local hexToRgb = require("./init").hexToRgb
test("hexToRgb (RGB notations)", function()
	local obs = hexToRgb("#ff007f")
	local exp = { 1, 0, 0.4980392156862745 }
	expect(obs).toEqual(exp)
	obs = hexToRgb("#FF007F")
	exp = { 1, 0, 0.4980392156862745 }
	expect(obs).toEqual(exp)
	obs = hexToRgb("FF007F")
	exp = { 1, 0, 0.4980392156862745 }
	expect(obs).toEqual(exp)
end)
test("hexToRgb (RGBA notations)", function()
	local obs = hexToRgb("#ff007f01")
	local exp = { 1, 0, 0.4980392156862745, 0.00392156862745098 }
	expect(obs).toEqual(exp)
	obs = hexToRgb("#FF007F01")
	exp = { 1, 0, 0.4980392156862745, 0.00392156862745098 }
	expect(obs).toEqual(exp)
	obs = hexToRgb("FF007F01")
	exp = { 1, 0, 0.4980392156862745, 0.00392156862745098 }
	expect(obs).toEqual(exp)
end)
