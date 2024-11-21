-- ROBLOX NOTE: no upstream
local JestGlobals = require("@DevPackages/JestGlobals")
local test, expect = JestGlobals.test, JestGlobals.expect

local fromPoints = require("./init").fromPoints
local applyTransforms = require("./applyTransforms")
local comparePoints, compareVectors
do
	local ref = require("../../../test/helpers/")
	comparePoints, compareVectors = ref.comparePoints, ref.compareVectors
end
test("applyTransforms: Updates a populated path with transformed points", function()
	local points = { { 0, 0 }, { 1, 0 }, { 0, 1 } }
	local expected = {
		points = { { 0, 0 }, { 1, 0 }, { 0, 1 } },
		isClosed = false,
		transforms = { 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1 },
	}
	local geometry = fromPoints({}, points)
	local updated = applyTransforms(geometry)
	expect(geometry).toBe(updated)
	expect(comparePoints(updated.points, expected.points)).toBe(true)
	expect(updated.isClosed).toBe(false)
	expect(compareVectors(updated.transforms, expected.transforms)).toBe(true)
	local updated2 = applyTransforms(updated)
	expect(updated).toBe(updated2)
	expect(comparePoints(updated2.points, expected.points)).toBe(true)
	expect(updated2.isClosed).toBe(false)
	expect(compareVectors(updated2.transforms, expected.transforms)).toBe(true)
end)
