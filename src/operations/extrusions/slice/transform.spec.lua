-- ROBLOX NOTE: no upstream
local JestGlobals = require("@DevPackages/JestGlobals")
local test, expect = JestGlobals.test, JestGlobals.expect

local transform, fromPoints, toEdges
do
	local ref = require("./init")
	transform, fromPoints, toEdges = ref.transform, ref.fromPoints, ref.toEdges
end
test("slice. transform() should return a new slice with correct values", function()
	local identityMatrix = { 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1 }
	local org1 = fromPoints({ { 0, 0 }, { 1, 0 }, { 1, 1 } })
	local ret1 = transform(identityMatrix, org1)
	expect(org1)["not"].toBe(ret1)
	local edges1 = toEdges(ret1)
	local exp1 = { { { 1, 1, 0 }, { 0, 0, 0 } }, { { 0, 0, 0 }, { 1, 0, 0 } }, { { 1, 0, 0 }, { 1, 1, 0 } } }
	expect(edges1).toEqual(exp1)
	local x = 1
	local y = 5
	local z = 7
	local translationMatrix = { 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, x, y, z, 1 }
	local org2 = fromPoints({ { 0, 0 }, { 1, 0 }, { 1, 1 } })
	local ret2 = transform(translationMatrix, org2)
	expect(org2)["not"].toBe(ret2)
	local edges2 = toEdges(ret2)
	local exp2 = { { { 2, 6, 7 }, { 1, 5, 7 } }, { { 1, 5, 7 }, { 2, 5, 7 } }, { { 2, 5, 7 }, { 2, 6, 7 } } }
	expect(edges2).toEqual(exp2)
	local r = 90 * 0.017453292519943295
	local rotateZMatrix = { math.cos(r), -math.sin(r), 0, 0, math.sin(r), math.cos(r), 0, 0, 0, 0, 1, 0, 0, 0, 0, 1 }
	local org3 = fromPoints({ { 0, 0 }, { 1, 0 }, { 1, 1 } })
	local ret3 = transform(rotateZMatrix, org3)
	expect(org3)["not"].toBe(ret3)
	local edges3 = toEdges(ret3)
	local exp3 = {
		{ { 1, -0.9999999999999999, 0 }, { 0, 0, 0 } },
		{ { 0, 0, 0 }, { 6.123233995736766e-17, -1, 0 } },
		{ { 6.123233995736766e-17, -1, 0 }, { 1, -0.9999999999999999, 0 } },
	}
	expect(edges3).toEqual(exp3)
end)
