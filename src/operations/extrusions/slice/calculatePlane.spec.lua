-- ROBLOX NOTE: no upstream
local JestGlobals = require("@DevPackages/JestGlobals")
local test, expect = JestGlobals.test, JestGlobals.expect

local TAU = require("../../../maths/constants").TAU
local mat4 = require("../../../maths").mat4
local calculatePlane, fromPoints, transform
do
	local ref = require("./init")
	calculatePlane, fromPoints, transform = ref.calculatePlane, ref.fromPoints, ref.transform
end
local compareVectors = require("../../../../test/helpers/init").compareVectors
test("slice. calculatePlane() returns correct plans for various slices", function()
	-- do not do this... it's an error
	-- const slice1 = create()
	-- const plane1 = calculatePlane(slice1)
	local slice2 = fromPoints({ { 0, 0 }, { 1, 0 }, { 1, 1 } })
	local plane2 = calculatePlane(slice2)
	expect(compareVectors(plane2, { 0, 0, 1, 0 })).toBe(true)
	local slice3 = transform(mat4.fromXRotation(mat4.create(), TAU / 4), slice2)
	local plane3 = calculatePlane(slice3)
	expect(compareVectors(plane3, { 0, -1, 0, 0 })).toBe(true)
	local slice4 = transform(mat4.fromZRotation(mat4.create(), TAU / 4), slice3)
	local plane4 = calculatePlane(slice4)
	expect(compareVectors(plane4, { 1, 0, 0, 0 })).toBe(true) -- Issue #749
	local slice5 = fromPoints({
		{ -4, 0, 2 },
		{ 4, 0, 2 },
		{ 4, 5, 2 },
		{ 6, 5, 2 },
		{ 4, 7, 2 },
		{ -4, 7, 2 },
		{ -6, 5, 2 },
		{ -4, 5, 2 },
	})
	local plane5 = calculatePlane(slice5)
	expect(compareVectors(plane5, { 0, 0, 1, 2 })).toBe(true)
	local slice6 = fromPoints({
		{ 4, 0, 0 },
		{ -4, 0, 0 },
		{ -4, 5, 0 },
		{ -6, 5, 0 },
		{ -4, 7, 0 },
		{ 4, 7, 0 },
		{ 6, 5, 0 },
		{ 4, 5, 0 },
	})
	local plane6 = calculatePlane(slice6)
	expect(compareVectors(plane6, { 0, 0, -1, 0 })).toBe(true)
end)
