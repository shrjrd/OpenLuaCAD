-- ROBLOX NOTE: no upstream
local JestGlobals = require("@DevPackages/JestGlobals")
local test, expect = JestGlobals.test, JestGlobals.expect

local squaredLength, fromValues
do
	local ref = require("./init")
	squaredLength, fromValues = ref.squaredLength, ref.fromValues
end
local nearlyEqual = require("../../../test/helpers/init").nearlyEqual
local EPS = require("../constants").EPS
test("vec3. length() should return correct values", function()
	local vec1 = fromValues(0, 0, 0)
	local length1 = squaredLength(vec1)
	nearlyEqual(length1, 0.0, EPS)
	local vec2 = fromValues(1, 2, 3)
	local length2 = squaredLength(vec2)
	nearlyEqual(length2, 14.00000, EPS)
	local vec3 = fromValues(1, -2, 3)
	local length3 = squaredLength(vec3)
	nearlyEqual(length3, 14.00000, EPS)
	local vec4 = fromValues(-1, -2, 3)
	local length4 = squaredLength(vec4)
	nearlyEqual(length4, 14.00000, EPS)
	local vec5 = fromValues(-1, 2, 3)
	local length5 = squaredLength(vec5)
	nearlyEqual(length5, 14.00000, EPS)
	local vec6 = fromValues(1, 2, -3)
	local length6 = squaredLength(vec6)
	nearlyEqual(length6, 14.00000, EPS)
	local vec7 = fromValues(1, -2, -3)
	local length7 = squaredLength(vec7)
	nearlyEqual(length7, 14.00000, EPS)
	local vec8 = fromValues(-1, -2, -3)
	local length8 = squaredLength(vec8)
	nearlyEqual(length8, 14.00000, EPS)
	local vec9 = fromValues(-1, 2, -3)
	local length9 = squaredLength(vec9)
	nearlyEqual(length9, 14.00000, EPS)
	expect(true).toBe(true)
end)
