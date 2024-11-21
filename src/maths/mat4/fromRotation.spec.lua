-- ROBLOX NOTE: no upstream
local JestGlobals = require("@DevPackages/JestGlobals")
local test, expect = JestGlobals.test, JestGlobals.expect

local fromRotation, create
do
	local ref = require("./init")
	fromRotation, create = ref.fromRotation, ref.create
end
local compareVectors = require("../../../test/helpers/init").compareVectors
test("mat4. fromRotation() should return a mat4 with correct values", function()
	local rotation = 90 * 0.017453292519943295 -- invalid condition when axis is 0,0,0
	local obs1 = fromRotation(create(), rotation, { 0, 0, 0 })
	expect(compareVectors(obs1, { 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1 })).toBe(true)
	local obs2 = fromRotation(create(), rotation, { 0, 0, 1 })
	expect(compareVectors(obs2, { 0, 1, 0, 0, -1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1 })).toBe(true)
	local obs3 = fromRotation(obs2, -rotation, { 0, 0, 1 })
	expect(compareVectors(obs3, { 0, -1, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1 })).toBe(true)
end)
