-- ROBLOX NOTE: no upstream
local JestGlobals = require("@DevPackages/JestGlobals")
local test, expect = JestGlobals.test, JestGlobals.expect

local transform, fromPoints
do
	local ref = require("./init")
	transform, fromPoints = ref.transform, ref.fromPoints
end
local comparePolygons = require("../../../test/helpers/init").comparePolygons
test("poly3. transform() should return a new poly3 with correct values", function()
	local identityMatrix = { 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1 }
	local exp1 = { vertices = { { 0, 0, 0 }, { 1, 0, 0 }, { 1, 1, 0 } } }
	local org1 = fromPoints({ { 0, 0, 0 }, { 1, 0, 0 }, { 1, 1, 0 } })
	local ret1 = transform(identityMatrix, org1)
	expect(comparePolygons(ret1, exp1)).toBe(true)
	expect(org1)["not"].toBe(ret1)
	local x = 1
	local y = 5
	local z = 7
	local translationMatrix = { 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, x, y, z, 1 }
	local exp2 = { vertices = { { 1, 5, 7 }, { 2, 5, 7 }, { 2, 6, 7 } } }
	local org2 = fromPoints({ { 0, 0, 0 }, { 1, 0, 0 }, { 1, 1, 0 } })
	local ret2 = transform(translationMatrix, org2)
	expect(comparePolygons(ret2, exp2)).toBe(true)
	expect(org2)["not"].toBe(ret2)
	local r = 90 * 0.017453292519943295
	local rotateZMatrix = { math.cos(r), -math.sin(r), 0, 0, math.sin(r), math.cos(r), 0, 0, 0, 0, 1, 0, 0, 0, 0, 1 }
	local exp3 = { vertices = { { 0, 0, 0 }, { 0, -1, 0 }, { 1, -1, 0 } } }
	local org3 = fromPoints({ { 0, 0, 0 }, { 1, 0, 0 }, { 1, 1, 0 } })
	local ret3 = transform(rotateZMatrix, org3)
	expect(comparePolygons(ret3, exp3)).toBe(true)
	expect(org3)["not"].toBe(ret3)
	local mirrorMatrix = { -1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1 }
	local exp4 = { vertices = { { -1, 1, 0 }, { -1, 0, 0 }, { 0, 0, 0 } } }
	local org4 = fromPoints({ { 0, 0, 0 }, { 1, 0, 0 }, { 1, 1, 0 } })
	local ret4 = transform(mirrorMatrix, org4)
	expect(comparePolygons(ret4, exp4)).toBe(true)
	expect(org4)["not"].toBe(ret4)
end)
