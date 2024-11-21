-- ROBLOX NOTE: no upstream
local JestGlobals = require("@DevPackages/JestGlobals")
local test, expect = JestGlobals.test, JestGlobals.expect

local dot, fromValues
do
	local ref = require("./init")
	dot, fromValues = ref.dot, ref.fromValues
end
test("vec4. dot() should return proper values", function()
	local vecA = fromValues(1, 2, 3, 4)
	local vecB = fromValues(5, 6, 7, 8)
	local obs = dot(vecA, vecB)
	expect(obs).toBe(70)
end)
