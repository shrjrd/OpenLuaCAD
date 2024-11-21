-- ROBLOX NOTE: no upstream
local JestGlobals = require("@DevPackages/JestGlobals")
local test, expect = JestGlobals.test, JestGlobals.expect

local rgbToHsl = require("./init").rgbToHsl
test("rgbToHsl", function()
	local obs = rgbToHsl({ 1, 0, 0.5 })
	local exp = { 0.9166666666666666, 1, 0.5 }
	expect(obs).toEqual(exp)
	obs = rgbToHsl(0.5, 0.5, 0.5)
	exp = { 0, 0, 0.5 }
	expect(obs).toEqual(exp)
	obs = rgbToHsl({ 0.8, 0.7, 0.6 })
	exp = { 0.08333333333333329, 0.3333333333333335, 0.7 }
	expect(obs).toEqual(exp)
	obs = rgbToHsl({ 0.7, 0.8, 0.6 })
	exp = { 0.25000000000000006, 0.3333333333333335, 0.7 }
	expect(obs).toEqual(exp)
	obs = rgbToHsl({ 0.6, 0.7, 0.8 })
	exp = { 0.5833333333333334, 0.3333333333333335, 0.7 }
	expect(obs).toEqual(exp)
	obs = rgbToHsl(0.6, 0.7, 0.8, 0.5)
	exp = { 0.5833333333333334, 0.3333333333333335, 0.7, 0.5 }
	expect(obs).toEqual(exp)
end)
