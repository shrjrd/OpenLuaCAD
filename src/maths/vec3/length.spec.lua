-- ROBLOX NOTE: no upstream
local JestGlobals = require("@DevPackages/JestGlobals")
local test, expect = JestGlobals.test, JestGlobals.expect

local length, fromValues
do
	local ref = require("./init")
	length, fromValues = ref["length"], ref.fromValues
end
local nearlyEqual = require("../../../test/helpers/init").nearlyEqual
local EPS = require("../constants").EPS
test("vec3. length() should return correct values", function()
	local vec1 = fromValues(0, 0, 0)
	local length1 = length(vec1)
	nearlyEqual(length1, 0.0, EPS)
	local vec2 = fromValues(1, 2, 3)
	local length2 = length(vec2)
	nearlyEqual(length2, 3.74165, EPS)
	local vec3 = fromValues(1, -2, 3)
	local length3 = length(vec3)
	nearlyEqual(length3, 3.74165, EPS)
	local vec4 = fromValues(-1, -2, 3)
	local length4 = length(vec4)
	nearlyEqual(length4, 3.74165, EPS)
	local vec5 = fromValues(-1, 2, 3)
	local length5 = length(vec5)
	nearlyEqual(length5, 3.74165, EPS)
	local vec6 = fromValues(1, 2, -3)
	local length6 = length(vec6)
	nearlyEqual(length6, 3.74165, EPS)
	local vec7 = fromValues(1, -2, -3)
	local length7 = length(vec7)
	nearlyEqual(length7, 3.74165, EPS)
	local vec8 = fromValues(-1, -2, -3)
	local length8 = length(vec8)
	nearlyEqual(length8, 3.74165, EPS)
	local vec9 = fromValues(-1, 2, -3)
	local length9 = length(vec9)
	nearlyEqual(length9, 3.74165, EPS)
	expect(true).toBe(true)
end)
