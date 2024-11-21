-- ROBLOX NOTE: no upstream
local JestGlobals = require("@DevPackages/JestGlobals")
local test, expect = JestGlobals.test, JestGlobals.expect

local transform, create, fromValues
do
	local ref = require("./init")
	transform, create, fromValues = ref.transform, ref.create, ref.fromValues
end
local compareVectors = require("../../../test/helpers/init").compareVectors
test("plane. transform() called with three parameters should return a plane with correct values", function()
	local identityMatrix = { 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1 }
	local out = create()
	local obs1 = transform(out, fromValues(0, 0, 1, 0), identityMatrix)
	expect(compareVectors(obs1, { 0 / 0, 0 / 0, 0 / 0, 0 / 0 })).toBe(true)
	expect(out).toBe(obs1)
	local plane2 = fromValues(0, 0, -1, 0)
	local obs2 = transform(out, plane2, identityMatrix)
	expect(compareVectors(obs2, { 0, 0, -1, 0 })).toBe(true)
	local x = 1
	local y = 5
	local z = 7
	local translationMatrix = { 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, x, y, z, 1 }
	local plane3 = fromValues(0, 0, 1, 0)
	local obs3 = transform(out, plane3, translationMatrix)
	expect(compareVectors(obs3, { 0, 0, 1, 7 })).toBe(true)
	local w = 1
	local h = 3
	local d = 5
	local scaleMatrix = { w, 0, 0, 0, 0, h, 0, 0, 0, 0, d, 0, 0, 0, 0, 1 }
	local plane4 = fromValues(0, -1, 0, 0)
	local obs4 = transform(out, plane4, scaleMatrix)
	expect(compareVectors(obs4, { 0, -1, 0, 0 })).toBe(true)
	local r = 90 * 0.017453292519943295
	local rotateZMatrix = {
		math.cos(r),
		-math.sin(r),
		0,
		0,
		math.sin(r),
		math.cos(r),
		0,
		0,
		0,
		0,
		1,
		0,
		0,
		0,
		0,
		1,
	}
	local plane5 = fromValues(-1, 0, 0, 0)
	local obs5 = transform(plane5, plane5, rotateZMatrix)
	expect(compareVectors(obs5, { -0, 1, 0, 0 })).toBe(true)
	local mirrorMatrix = { -1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1 }
	local plane6 = fromValues(1, 0, 0, 0)
	local obs6 = transform(plane6, plane6, mirrorMatrix)
	expect(compareVectors(obs6, { -1, 0, 0, 0 })).toBe(true)
end)
