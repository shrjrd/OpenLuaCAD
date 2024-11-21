-- ROBLOX NOTE: no upstream
local JestGlobals = require("@DevPackages/JestGlobals")
local test, expect = JestGlobals.test, JestGlobals.expect

local fromScalar, create
do
	local ref = require("./init")
	fromScalar, create = ref.fromScalar, ref.create
end
local compareVectors = require("../../../test/helpers/init").compareVectors
test("vec2. fromScalar() should return a new vec2 with correct values", function()
	local obs1 = fromScalar(create(), 0)
	expect(compareVectors(obs1, { 0, 0 })).toBe(true)
	local obs2 = fromScalar(obs1, -5)
	expect(compareVectors(obs2, { -5, -5 })).toBe(true)
end)
