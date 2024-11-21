-- ROBLOX NOTE: no upstream
local JestGlobals = require("@DevPackages/JestGlobals")
local test, expect = JestGlobals.test, JestGlobals.expect

local plane = require("../plane/")
local intersectPointOfLineAndPlane, fromPoints, create
do
	local ref = require("./init")
	intersectPointOfLineAndPlane, fromPoints, create = ref.intersectPointOfLineAndPlane, ref.fromPoints, ref.create
end
local compareVectors = require("../../../test/helpers/init").compareVectors
test("line3: intersectPointOfLineAndPlane() should return a new line3 with correct values", function()
	local planeXY = plane.fromPoints(plane.create(), { 0, 0, 0 }, { 1, 0, 0 }, { 1, 1, 0 }) -- flat on XY
	local planeXZ = plane.fromPoints(plane.create(), { 0, 0, 0 }, { 1, 0, 0 }, { 0, 0, 1 }) -- flat on XZ
	local planeYZ = plane.fromPoints(plane.create(), { 0, 0, 0 }, { 0, 1, 0 }, { 0, 0, 1 }) -- flat on YZ
	local line1 = fromPoints(create(), { 0, 0, 0 }, { 1, 0, 0 }) -- const line2 = fromPoints(create(), [1, 0, 0], [1, 1, 0])
	-- const line3 = fromPoints(create(), [0, 6, 0], [0, 0, 6])
	local obs = intersectPointOfLineAndPlane(line1, planeXY) -- no intersection, line on plane
	expect(compareVectors(obs, { 0 / 0, 0 / 0, 0 / 0 })).toBe(true)
	obs = intersectPointOfLineAndPlane(line1, planeXY)
	expect(compareVectors(obs, { 0, 6, 0 })).toBe(true)
	obs = intersectPointOfLineAndPlane(line1, planeXZ)
	expect(compareVectors(obs, { 0, 0, 6 })).toBe(true)
	obs = intersectPointOfLineAndPlane(line1, planeYZ) -- no intersection, line parallel to plane
	expect(compareVectors(obs, { 0 / 0, math.huge, 0 / 0 })).toBe(true)
end)
