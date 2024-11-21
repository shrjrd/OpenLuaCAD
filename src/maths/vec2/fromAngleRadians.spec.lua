-- ROBLOX NOTE: no upstream
local JestGlobals = require("@DevPackages/JestGlobals")
local test, expect = JestGlobals.test, JestGlobals.expect

local TAU = require("../constants").TAU
local fromAngleRadians, create
do
	local ref = require("./init")
	fromAngleRadians, create = ref.fromAngleRadians, ref.create
end
local compareVectors = require("../../../test/helpers/init").compareVectors
test("vec2. fromAngleRadians() should return a new vec2 with correct values", function()
	local obs1 = fromAngleRadians(create(), 0)
	expect(compareVectors(obs1, { 1.0, 0.0 })).toBe(true)
	local obs2 = fromAngleRadians(obs1, TAU / 2)
	expect(compareVectors(obs2, { -1, 1.2246468525851679e-16 })).toBe(true)
end)
