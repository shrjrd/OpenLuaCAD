-- ROBLOX NOTE: no upstream
local JestGlobals = require("@DevPackages/JestGlobals")
local test, expect = JestGlobals.test, JestGlobals.expect

local distanceToPoint, create, fromPoints
do
	local ref = require("./init")
	distanceToPoint, create, fromPoints = ref.distanceToPoint, ref.create, ref.fromPoints
end
local nearlyEqual = require("../../../test/helpers/init").nearlyEqual
local EPS = require("../constants").EPS
test("line3: distanceToPoint() should return proper values", function()
	local line1 = create()
	local dis1 = distanceToPoint(line1, { 0, 0, 0 })
	nearlyEqual(dis1, 0, EPS)
	local dis2 = distanceToPoint(line1, { 1, 0, 0 })
	nearlyEqual(dis2, 1, EPS)
	local dis3 = distanceToPoint(line1, { 0, 1, 0 })
	nearlyEqual(dis3, 1, EPS)
	local line2 = fromPoints(create(), { -5, -5, -4 }, { 5, 5, 6 })
	local dis4 = distanceToPoint(line2, { 0, 0, 0 })
	nearlyEqual(dis4, 0.8164965809277724, EPS)
	local dis5 = distanceToPoint(line2, { 1, 0, 0 })
	nearlyEqual(dis5, 1.4142135381698608, EPS)
	local dis6 = distanceToPoint(line2, { 2, 0, 0 })
	nearlyEqual(dis6, 2.1602468994693043, EPS)
	local dis7 = distanceToPoint(line2, { 3, 0, 0 })
	nearlyEqual(dis7, 2.9439202887759617, EPS)
	local dis8 = distanceToPoint(line2, { 4, 0, 0 })
	nearlyEqual(dis8, 3.7416573867739413, EPS)
	local dis9 = distanceToPoint(line2, { 5, 0, 0 })
	nearlyEqual(dis9, 4.546060565661961, EPS)
	expect(true).toBe(true)
end)
