-- ROBLOX NOTE: no upstream
local JestGlobals = require("@DevPackages/JestGlobals")
local test, expect = JestGlobals.test, JestGlobals.expect

local fromTaitBryanRotation, create
do
	local ref = require("./init")
	fromTaitBryanRotation, create = ref.fromTaitBryanRotation, ref.create
end
local compareVectors = require("../../../test/helpers/init").compareVectors
test("mat4. fromTaitBryanRotation() should return a new mat4 with correct values", function()
	local rotation = 90 * 0.017453292519943295 -- rotation using YAW / Z
	local obs1 = fromTaitBryanRotation(create(), rotation, 0, 0)
	expect(compareVectors(obs1, { 0, 1, 0, 0, -1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1 })).toBe(true) -- rotation using PITCH / Y
	local obs2 = fromTaitBryanRotation(create(), 0, rotation, 0)
	expect(compareVectors(obs2, { 0, 0, -1, 0, 0, 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, 1 })).toBe(true) -- rotation using ROLL / X
	local obs3 = fromTaitBryanRotation(create(), 0, 0, rotation)
	expect(compareVectors(obs3, { 1, 0, 0, 0, 0, 0, 1, 0, 0, -1, 0, 0, 0, 0, 0, 1 })).toBe(true)
	local obs4 = fromTaitBryanRotation(obs3, -rotation, -rotation, -rotation)
	expect(compareVectors(obs4, { 0, 0, 1, 0, 0, -1, 0, 0, 1, 0, 0, 0, 0, 0, 0, 1 })).toBe(true)
end)
