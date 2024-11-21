-- ROBLOX NOTE: no upstream
local JestGlobals = require("@DevPackages/JestGlobals")
local test, expect = JestGlobals.test, JestGlobals.expect

local compareVectors = require("../../../test/helpers/init").compareVectors
local projectionOfPoint, create, fromNormalAndPoint
do
	local ref = require("./init")
	projectionOfPoint, create, fromNormalAndPoint = ref.projectionOfPoint, ref.create, ref.fromNormalAndPoint
end
test("plane. projectionOfPoint() should return correct values", function()
	local temp = create()
	local plane1 = fromNormalAndPoint(temp, { 0, 0, 0 }, { 0, 0, 0 })
	local point1 = projectionOfPoint(plane1, { 0, 0, 0 })
	expect(point1).toEqual({ 0, 0, 0 }) -- axis aligned planes
	local plane2 = fromNormalAndPoint(temp, { 0, 0, 1 }, { 0, 0, 0 })
	local point2 = projectionOfPoint(plane2, { 1, 1, 1 })
	expect(point2).toEqual({ 1, 1, 0 })
	local plane3 = fromNormalAndPoint(temp, { 1, 0, 0 }, { 0, 0, 0 })
	local point3 = projectionOfPoint(plane3, { 1, 1, 1 })
	expect(point3).toEqual({ 0, 1, 1 })
	local plane4 = fromNormalAndPoint(temp, { 0, 1, 0 }, { 0, 0, 0 })
	local point4 = projectionOfPoint(plane4, { 1, 1, 1 })
	expect(point4).toEqual({ 1, 0, 1 }) -- diagonal planes
	local plane5 = fromNormalAndPoint(temp, { 1, 1, 1 }, { 0, 0, 0 })
	local point5 = projectionOfPoint(plane5, { 0, 0, 0 })
	expect(point5).toEqual({ 0, 0, 0 })
	local plane6 = fromNormalAndPoint(temp, { 1, 1, 1 }, { 0, 0, 0 })
	local point6 = projectionOfPoint(plane6, { 3, 3, 3 })
	expect(compareVectors(point6, { 0, 0, 0 })).toBe(true)
	local plane7 = fromNormalAndPoint(temp, { 1, 1, 1 }, { 0, 0, 0 })
	local point7 = projectionOfPoint(plane7, { -3, -3, -3 })
	expect(compareVectors(point7, { 0, 0, 0 })).toBe(true)
	local plane8 = fromNormalAndPoint(temp, { 1, 1, 1 }, { 0, 0, 0 })
	local point8 = projectionOfPoint(plane8, { 0, 0, 0 })
	expect(compareVectors(point8, { 0, 0, 0 })).toBe(true)
end)
