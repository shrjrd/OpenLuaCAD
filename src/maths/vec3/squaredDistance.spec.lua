-- ROBLOX NOTE: no upstream
local JestGlobals = require("@DevPackages/JestGlobals")
local test, expect = JestGlobals.test, JestGlobals.expect

local squaredDistance, fromValues
do
	local ref = require("./init")
	squaredDistance, fromValues = ref.squaredDistance, ref.fromValues
end
local nearlyEqual = require("../../../test/helpers/init").nearlyEqual
local EPS = require("../constants").EPS
test("vec3. squaredDistance() should return correct values", function()
	local vec0 = fromValues(0, 0, 0)
	local vec1 = fromValues(0, 0, 0)
	local distance1 = squaredDistance(vec0, vec1)
	nearlyEqual(distance1, 0.0, EPS)
	local vec2 = fromValues(1, 2, 3)
	local distance2 = squaredDistance(vec1, vec2)
	nearlyEqual(distance2, 14.00000, EPS)
	local vec3 = fromValues(1, -2, 3)
	local distance3 = squaredDistance(vec1, vec3)
	nearlyEqual(distance3, 14.00000, EPS)
	local vec4 = fromValues(-1, -2, 3)
	local distance4 = squaredDistance(vec1, vec4)
	nearlyEqual(distance4, 14.00000, EPS)
	local vec5 = fromValues(-1, 2, 3)
	local distance5 = squaredDistance(vec1, vec5)
	nearlyEqual(distance5, 14.00000, EPS)
	local vec6 = fromValues(1, 2, -3)
	local distance6 = squaredDistance(vec1, vec6)
	nearlyEqual(distance6, 14.00000, EPS)
	local vec7 = fromValues(1, -2, -3)
	local distance7 = squaredDistance(vec1, vec7)
	nearlyEqual(distance7, 14.00000, EPS)
	local vec8 = fromValues(-1, -2, -3)
	local distance8 = squaredDistance(vec1, vec8)
	nearlyEqual(distance8, 14.00000, EPS)
	local vec9 = fromValues(-1, 2, -3)
	local distance9 = squaredDistance(vec1, vec9)
	nearlyEqual(distance9, 14.00000, EPS)
	expect(true).toBe(true)
end)
