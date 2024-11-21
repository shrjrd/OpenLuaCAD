-- ROBLOX NOTE: no upstream
local JestGlobals = require("@DevPackages/JestGlobals")
local test, expect = JestGlobals.test, JestGlobals.expect

local colorNameToRgb = require("./init").colorNameToRgb
test("colorNameToRgb", function()
	local obs = colorNameToRgb("bad")
	expect(obs).toBe(nil)
	obs = colorNameToRgb("lightblue")
	local exp = { 0.6784313725490196, 0.8470588235294118, 0.9019607843137255 }
	expect(obs).toEqual(exp)
end)
