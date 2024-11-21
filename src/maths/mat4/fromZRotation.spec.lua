-- ROBLOX NOTE: no upstream
local JestGlobals = require("@DevPackages/JestGlobals")
local test, expect = JestGlobals.test, JestGlobals.expect

local fromZRotation, create
do
	local ref = require("./init")
	fromZRotation, create = ref.fromZRotation, ref.create
end
local compareVectors = require("../../../test/helpers/init").compareVectors
test("mat4. fromZRotation() should return a new mat4 with correct values", function()
	local rotation = 90 * 0.017453292519943295
	local obs2 = fromZRotation(create(), rotation)
	expect(compareVectors(obs2, { 0, 1, 0, 0, -1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1 })).toBe(true)
	local obs3 = fromZRotation(obs2, -rotation)
	expect(compareVectors(obs3, { 0, -1, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1 })).toBe(true)
end)
