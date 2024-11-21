-- ROBLOX NOTE: no upstream
local JestGlobals = require("@DevPackages/JestGlobals")
local test, expect = JestGlobals.test, JestGlobals.expect

local rgbToHex = require("./init").rgbToHex
test("rgbToHex", function()
	local obs = rgbToHex({ 1, 0, 0.5 })
	local exp = "#ff007f"
	expect(obs).toEqual(exp)
	obs = rgbToHex(1, 0, 0.5, 0.8)
	exp = "#ff007fcc"
	expect(obs).toEqual(exp)
end)
