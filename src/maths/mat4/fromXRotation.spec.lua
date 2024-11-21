-- ROBLOX NOTE: no upstream
local JestGlobals = require("@DevPackages/JestGlobals")
local test, expect = JestGlobals.test, JestGlobals.expect

local fromXRotation, create
do
	local ref = require("./init")
	fromXRotation, create = ref.fromXRotation, ref.create
end
local compareVectors = require("../../../test/helpers/init").compareVectors
test("mat4. fromXRotation() should return a new mat4 with correct values", function()
	local rotation = 90 * 0.017453292519943295
	local obs2 = fromXRotation(create(), rotation)
	expect(compareVectors(obs2, { 1, 0, 0, 0, 0, 0, 1, 0, 0, -1, 0, 0, 0, 0, 0, 1 })).toBe(true)
	local obs3 = fromXRotation(obs2, -rotation)
	expect(compareVectors(obs3, { 1, 0, 0, 0, 0, 0, -1, 0, 0, 1, 0, 0, 0, 0, 0, 1 })).toBe(true)
end)
