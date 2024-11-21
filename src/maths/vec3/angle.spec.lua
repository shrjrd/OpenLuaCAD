-- ROBLOX NOTE: no upstream
local JestGlobals = require("@DevPackages/JestGlobals")
local test, expect = JestGlobals.test, JestGlobals.expect

local angle, fromValues
do
	local ref = require("./init")
	angle, fromValues = ref.angle, ref.fromValues
end
local nearlyEqual = require("../../../test/helpers/init").nearlyEqual
local EPS = require("../constants").EPS
test("vec3. angle() should return correct values", function()
	local vec0 = fromValues(5, 5, 5)
	local vec1 = fromValues(0, 0, 0)
	local angle1 = angle(vec0, vec1)
	nearlyEqual(angle1, 1.57079, EPS) -- any vector with all zeros
	local veca3 = fromValues(1, 0, 0)
	local vec3 = fromValues(1, 0, 0)
	local angle3 = angle(veca3, vec3)
	nearlyEqual(angle3, 0.00000, EPS)
	local veca2 = fromValues(1, 0, 0)
	local vec2 = fromValues(0, 1, 0)
	local angle2 = angle(veca2, vec2)
	nearlyEqual(angle2, 1.57079, EPS)
	local veca4 = fromValues(1, 1, 1)
	local vec4 = fromValues(-1, -1, -1)
	local angle4 = angle(veca4, vec4)
	nearlyEqual(angle4, 3.14159, EPS)
	local vec5a = fromValues(1, 0, 0)
	local vec5b = fromValues(1, 1, 0)
	local angle5 = angle(vec5a, vec5b)
	nearlyEqual(angle5, 0.785398, EPS)
	expect(true).toBe(true)
end)
