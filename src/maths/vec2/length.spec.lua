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
test("vec2. length() should return correct values", function()
	local vec1 = fromValues(0, 0)
	local length1 = length(vec1)
	nearlyEqual(length1, 0.0, EPS)
	local vec2 = fromValues(1, 2)
	local length2 = length(vec2)
	nearlyEqual(length2, 2.23606, EPS)
	local vec3 = fromValues(1, -2)
	local length3 = length(vec3)
	nearlyEqual(length3, 2.23606, EPS)
	local vec4 = fromValues(-1, -2)
	local length4 = length(vec4)
	nearlyEqual(length4, 2.23606, EPS)
	local vec5 = fromValues(-1, 2)
	local length5 = length(vec5)
	nearlyEqual(length5, 2.23606, EPS)
	expect(true).toBe(true)
end)
