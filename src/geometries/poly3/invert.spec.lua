-- ROBLOX NOTE: no upstream
local JestGlobals = require("@DevPackages/JestGlobals")
local test, expect = JestGlobals.test, JestGlobals.expect

local invert, fromPoints
do
	local ref = require("./init")
	invert, fromPoints = ref.invert, ref.fromPoints
end
local comparePolygons = require("../../../test/helpers/init").comparePolygons
test("poly3. invert() should return a new poly3 with correct values", function()
	local exp1 = { vertices = { { 1, 1, 0 }, { 1, 0, 0 }, { 0, 0, 0 } } }
	local org1 = fromPoints({ { 0, 0, 0 }, { 1, 0, 0 }, { 1, 1, 0 } })
	local ret1 = invert(org1)
	expect(comparePolygons(ret1, exp1)).toBe(true)
	local exp2 = { vertices = { { 0, 0, 0 }, { 1, 0, 0 }, { 1, 1, 0 } } }
	local org2 = fromPoints({ { 1, 1, 0 }, { 1, 0, 0 }, { 0, 0, 0 } })
	local ret2 = invert(org2)
	expect(comparePolygons(ret2, exp2)).toBe(true)
	expect(comparePolygons(ret2, org2)).toBe(false) -- the original should NOT change
end)
