-- ROBLOX NOTE: no upstream
local Packages = game.ReplicatedStorage.Packages
local LuauPolyfill = require(Packages.LuauPolyfill)
local Number = LuauPolyfill.Number
local JestGlobals = require("@DevPackages/JestGlobals")
local test, expect = JestGlobals.test, JestGlobals.expect

local xAtY, create, fromPoints
do
	local ref = require("./init")
	xAtY, create, fromPoints = ref.xAtY, ref.create, ref.fromPoints
end
local nearlyEqual = require("../../../test/helpers/init").nearlyEqual
local EPS = require("../constants").EPS
test("line2. xAtY() should return proper values", function()
	local line1 = create()
	local x1 = xAtY(line1, 0)
	nearlyEqual(x1, 0, EPS)
	local x2 = xAtY(line1, 6)
	expect(Number.isFinite(x2)).toBe(false) -- X is infinite, as the line is parallel to X-axis
	local x3 = xAtY(line1, -6)
	expect(Number.isFinite(x3)).toBe(false) -- X is infinite, as the line is parallel to X-axis
	local line2 = fromPoints(create(), { -5, 4 }, { 5, -6 })
	local y1 = xAtY(line2, 0)
	nearlyEqual(y1, -1, EPS)
	local y2 = xAtY(line2, 1)
	nearlyEqual(y2, -2, EPS)
	local y3 = xAtY(line2, 2)
	nearlyEqual(y3, -3, EPS)
	local y4 = xAtY(line2, -1)
	nearlyEqual(y4, 0, EPS)
	local y5 = xAtY(line2, -2)
	nearlyEqual(y5, 1, EPS)
	local y6 = xAtY(line2, -3)
	nearlyEqual(y6, 2, EPS)
	expect(true).toBe(true)
end)
