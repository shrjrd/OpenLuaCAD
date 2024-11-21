-- ROBLOX NOTE: no upstream
local JestGlobals = require("@DevPackages/JestGlobals")
local test, expect = JestGlobals.test, JestGlobals.expect

local equals, fromValues
do
	local ref = require("./init")
	equals, fromValues = ref.equals, ref.fromValues
end
test("vec3. equals() should return correct booleans", function()
	local vec0 = fromValues(0, 0, 0)
	local vec1 = fromValues(0, 0, 0)
	expect(equals(vec0, vec1)).toBe(true)
	local vec2 = fromValues(1, 1, 1)
	expect(equals(vec0, vec2)).toBe(false)
	local vec3 = fromValues(0, 1, 1)
	expect(equals(vec0, vec3)).toBe(false)
	local vec4 = fromValues(0, 0, 1)
	expect(equals(vec0, vec4)).toBe(false)
end)
