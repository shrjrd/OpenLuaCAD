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
test("vec3. distance() should return correct values", function()
	local vec0 = fromValues(0, 0, 0)
	local vec1 = fromValues(0, 0, 0)
	local distance1 = distance(vec0, vec1)
	nearlyEqual(distance1, 0.0, EPS)
	local vec2 = fromValues(1, 2, 3)
	local distance2 = distance(vec0, vec2)
	nearlyEqual(distance2, 3.74165, EPS)
	local vec3 = fromValues(1, -2, 3)
	local distance3 = distance(vec0, vec3)
	nearlyEqual(distance3, 3.74165, EPS)
	local vec4 = fromValues(-1, -2, 3)
	local distance4 = distance(vec0, vec4)
	nearlyEqual(distance4, 3.74165, EPS)
	local vec5 = fromValues(-1, 2, 3)
	local distance5 = distance(vec0, vec5)
	nearlyEqual(distance5, 3.74165, EPS)
	local vec6 = fromValues(1, 2, -3)
	local distance6 = distance(vec0, vec6)
	nearlyEqual(distance6, 3.74165, EPS)
	local vec7 = fromValues(1, -2, -3)
	local distance7 = distance(vec0, vec7)
	nearlyEqual(distance7, 3.74165, EPS)
	local vec8 = fromValues(-1, -2, -3)
	local distance8 = distance(vec0, vec8)
	nearlyEqual(distance8, 3.74165, EPS)
	local vec9 = fromValues(-1, 2, -3)
	local distance9 = distance(vec0, vec9)
	nearlyEqual(distance9, 3.74165, EPS)
	expect(true).toBe(true)
end)
