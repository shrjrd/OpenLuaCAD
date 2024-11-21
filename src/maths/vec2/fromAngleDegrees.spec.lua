-- ROBLOX NOTE: no upstream
local JestGlobals = require("@DevPackages/JestGlobals")
local test, expect = JestGlobals.test, JestGlobals.expect

local fromAngleDegrees, create
do
	local ref = require("./init")
	fromAngleDegrees, create = ref.fromAngleDegrees, ref.create
end
local compareVectors = require("../../../test/helpers/init").compareVectors
test("vec2. fromAngleDegrees() should return a new vec2 with correct values", function()
	local obs1 = fromAngleDegrees(create(), 0)
	expect(compareVectors(obs1, { 1.0, 0.0 })).toBe(true)
	local obs2 = fromAngleDegrees(obs1, 180)
	expect(compareVectors(obs2, { -1, 1.2246468525851679e-16 })).toBe(true)
end)
