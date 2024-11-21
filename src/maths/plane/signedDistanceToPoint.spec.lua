-- ROBLOX NOTE: no upstream
local JestGlobals = require("@DevPackages/JestGlobals")
local test, expect = JestGlobals.test, JestGlobals.expect

local signedDistanceToPoint, fromValues
do
	local ref = require("./init")
	signedDistanceToPoint, fromValues = ref.signedDistanceToPoint, ref.fromValues
end
test("plane. signedDistanceToPoint() should return correct values", function()
	local plane1 = fromValues(0, 0, 0, 0)
	local distance1 = signedDistanceToPoint(plane1, { 0, 0, 0 })
	expect(distance1 == 0.0).toBe(true)
	local plane2 = fromValues(1, 1, 1, 1)
	local distance2 = signedDistanceToPoint(plane2, { -1, -1, -1 })
	expect(distance2 == -3.0 - 1).toBe(true)
	local plane3 = fromValues(5, 5, 5, 5)
	local distance3 = signedDistanceToPoint(plane3, { 5, 5, 5 })
	expect(distance3 == 75.0 - 5).toBe(true)
	local plane4 = fromValues(5, 5, 5, 5)
	local distance4 = signedDistanceToPoint(plane4, { -2, 3, -4 })
	expect(distance4 == -15.0 - 5).toBe(true)
end)
