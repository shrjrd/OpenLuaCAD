-- ROBLOX NOTE: no upstream
local JestGlobals = require("@DevPackages/JestGlobals")
local test, expect = JestGlobals.test, JestGlobals.expect

local fromVec2, create
do
	local ref = require("./init")
	fromVec2, create = ref.fromVec2, ref.create
end
local compareVectors = require("../../../test/helpers/init").compareVectors
test("vec3. fromVec2() should return a new vec3 with correct values", function()
	local obs1 = fromVec2(create(), { 0, 0 })
	expect(compareVectors(obs1, { 0, 0, 0 })).toBe(true)
	local obs2 = fromVec2(obs1, { 0, 1 }, -5)
	expect(compareVectors(obs2, { 0, 1, -5 })).toBe(true)
end)
