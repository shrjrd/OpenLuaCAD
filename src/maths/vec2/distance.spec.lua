-- ROBLOX NOTE: no upstream
local JestGlobals = require("@DevPackages/JestGlobals")
local test, expect = JestGlobals.test, JestGlobals.expect

local distance, fromValues
do
	local ref = require("./init")
	distance, fromValues = ref.distance, ref.fromValues
end
local nearlyEqual = require("../../../test/helpers/init").nearlyEqual
local EPS = require("../constants").EPS
test("vec2. distance() should return correct values", function()
	local vec0 = fromValues(0, 0)
	local vec1 = fromValues(0, 0)
	local distance1 = distance(vec0, vec1)
	nearlyEqual(distance1, 0.0, EPS)
	local vec2 = fromValues(1, 2)
	local distance2 = distance(vec0, vec2)
	nearlyEqual(distance2, 2.23606, EPS)
	local vec3 = fromValues(1, -2)
	local distance3 = distance(vec0, vec3)
	nearlyEqual(distance3, 2.23606, EPS)
	local vec4 = fromValues(-1, -2)
	local distance4 = distance(vec0, vec4)
	nearlyEqual(distance4, 2.23606, EPS)
	local vec5 = fromValues(-1, 2)
	local distance5 = distance(vec0, vec5)
	nearlyEqual(distance5, 2.23606, EPS)
	expect(true).toBe(true)
end)
