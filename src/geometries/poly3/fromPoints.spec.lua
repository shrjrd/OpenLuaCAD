-- ROBLOX NOTE: no upstream
local JestGlobals = require("@DevPackages/JestGlobals")
local test, expect = JestGlobals.test, JestGlobals.expect

local fromPoints = require("./init").fromPoints
local comparePolygons = require("../../../test/helpers/init").comparePolygons
test("poly3. fromPoints() should return a new poly3 with correct values", function()
	local exp1 = { vertices = { { 0, 0, 0 }, { 1, 0, 0 }, { 1, 1, 0 } } }
	local obs1 = fromPoints({ { 0, 0, 0 }, { 1, 0, 0 }, { 1, 1, 0 } })
	expect(comparePolygons(obs1, exp1)).toBe(true)
	local exp2 = { vertices = { { 1, 1, 0 }, { 1, 0, 0 }, { 0, 0, 0 } } }
	local obs2 = fromPoints({ { 1, 1, 0 }, { 1, 0, 0 }, { 0, 0, 0 } }) -- opposite orientation
	expect(comparePolygons(obs2, exp2)).toBe(true)
end)
