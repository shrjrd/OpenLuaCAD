-- ROBLOX NOTE: no upstream
local JestGlobals = require("@DevPackages/JestGlobals")
local test, expect = JestGlobals.test, JestGlobals.expect

local fromScaling, create
do
	local ref = require("./init")
	fromScaling, create = ref.fromScaling, ref.create
end
local compareVectors = require("../../../test/helpers/init").compareVectors
test("mat4. fromScaling() should return a new mat4 with correct values", function()
	local obs1 = fromScaling(create(), { 2, 4, 6 })
	expect(compareVectors(obs1, { 2, 0, 0, 0, 0, 4, 0, 0, 0, 0, 6, 0, 0, 0, 0, 1 })).toBe(true)
	local obs2 = fromScaling(obs1, { -2, -4, -6 })
	expect(compareVectors(obs2, { -2, 0, 0, 0, 0, -4, 0, 0, 0, 0, -6, 0, 0, 0, 0, 1 })).toBe(true)
end)
