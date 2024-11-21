-- ROBLOX NOTE: no upstream
local JestGlobals = require("@DevPackages/JestGlobals")
local test, expect = JestGlobals.test, JestGlobals.expect

local fromTranslation, create
do
	local ref = require("./init")
	fromTranslation, create = ref.fromTranslation, ref.create
end
local compareVectors = require("../../../test/helpers/init").compareVectors
test("mat4. fromTranslation() should return a new mat4 with correct values", function()
	local obs1 = fromTranslation(create(), { 2, 4, 6 })
	expect(compareVectors(obs1, { 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 2, 4, 6, 1 })).toBe(true)
	local obs2 = fromTranslation(obs1, { -2, -4, -6 })
	expect(compareVectors(obs2, { 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, -2, -4, -6, 1 })).toBe(true)
end)
