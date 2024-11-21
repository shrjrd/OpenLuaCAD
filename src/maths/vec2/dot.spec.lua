-- ROBLOX NOTE: no upstream
local JestGlobals = require("@DevPackages/JestGlobals")
local test, expect = JestGlobals.test, JestGlobals.expect

local dot, fromValues
do
	local ref = require("./init")
	dot, fromValues = ref.dot, ref.fromValues
end
test("vec2. dot() should return correct values", function()
	local veca1 = fromValues(0, 0)
	local vecb1 = fromValues(0, 0)
	local dot1 = dot(veca1, vecb1)
	expect(dot1 == 0.0).toBe(true)
	local veca2 = fromValues(1, 1)
	local vecb2 = fromValues(-1, -1)
	local dot2 = dot(veca2, vecb2)
	expect(dot2 == -2.0).toBe(true)
	local veca3 = fromValues(5, 5)
	local vecb3 = fromValues(5, 5)
	local dot3 = dot(veca3, vecb3)
	expect(dot3 == 50.0).toBe(true)
	local veca4 = fromValues(5, 5)
	local vecb4 = fromValues(-2, 3)
	local dot4 = dot(veca4, vecb4)
	expect(dot4 == 5.0).toBe(true)
end)
