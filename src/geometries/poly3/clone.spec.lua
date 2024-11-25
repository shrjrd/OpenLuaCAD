-- ROBLOX NOTE: no upstream
local JestGlobals = require("@DevPackages/JestGlobals")
local test, expect = JestGlobals.test, JestGlobals.expect

local create, clone, fromPoints
do
	local ref = require("./init")
	create, clone, fromPoints = ref.create, ref.clone, ref.fromPoints
end
local comparePolygons = require("../../../test/helpers/init").comparePolygons
test("poly3. clone() should return a new poly3 with same values", function()
	local org1 = create()
	local ret1 = clone(org1)
	expect(comparePolygons(ret1, org1)).toBe(true)
	expect(ret1).never.toBe(org1)
	local org2 = fromPoints({ { 1, 1, 0 }, { -1, 1, 0 }, { -1, -1, 0 }, { 1, -1, 0 } })
	local ret2 = clone(org2)
	expect(comparePolygons(ret2, org2)).toBe(true)
	expect(ret2).never.toBe(org2)
end)
test("poly3. clone() with two params should update a poly3 with same values", function()
	local org1 = create()
	local out1 = create()
	local ret1 = clone(out1, org1)
	expect(comparePolygons(org1, out1)).toBe(true)
	expect(comparePolygons(org1, ret1)).toBe(true)
	expect(out1).never.toBe(org1)
	expect(ret1).never.toBe(org1)
	expect(ret1).toBe(out1)
	local org2 = fromPoints({ { 1, 1, 0 }, { -1, 1, 0 }, { -1, -1, 0 }, { 1, -1, 0 } })
	local out2 = create()
	local ret2 = clone(out2, org2)
	expect(comparePolygons(ret2, org2)).toBe(true)
	expect(out2).never.toBe(org2)
	expect(ret2).never.toBe(org2)
	expect(ret2).toBe(out2)
end)
