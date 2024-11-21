-- ROBLOX NOTE: no upstream
local JestGlobals = require("@DevPackages/JestGlobals")
local test, expect = JestGlobals.test, JestGlobals.expect

local create, clone, fromPoints, toEdges
do
	local ref = require("./init")
	create, clone, fromPoints, toEdges = ref.create, ref.clone, ref.fromPoints, ref.toEdges
end
test("slice. clone() should return a new slice with same values", function()
	local org1 = create()
	local ret1 = clone(org1)
	expect(ret1)["not"].toBe(org1)
	local org2 = fromPoints({ { 1, 1 }, { -1, 1 }, { -1, -1 }, { 1, -1 } })
	local ret2 = clone(org2)
	expect(ret2)["not"].toBe(org2)
	expect(toEdges(ret2)).toEqual(toEdges(org2))
end)
test("slice. clone() with two params should update a slice with same values", function()
	local org1 = create()
	local out1 = create()
	local ret1 = clone(out1, org1)
	expect(out1)["not"].toBe(org1)
	expect(ret1)["not"].toBe(org1)
	expect(ret1).toBe(out1)
	expect(toEdges(ret1)).toEqual(toEdges(org1))
	local org2 = fromPoints({ { 1, 1 }, { -1, 1 }, { -1, -1 }, { 1, -1 } })
	local out2 = create()
	local ret2 = clone(out2, org2)
	expect(out2)["not"].toBe(org2)
	expect(ret2)["not"].toBe(org2)
	expect(ret2).toBe(out2)
	expect(toEdges(ret2)).toEqual(toEdges(org2))
end)
