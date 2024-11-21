-- ROBLOX NOTE: no upstream
local JestGlobals = require("@DevPackages/JestGlobals")
local test, expect = JestGlobals.test, JestGlobals.expect

local create = require("./init").create
local compareVectors = require("../../../test/helpers/init").compareVectors
test("vec4. create() should return a vec4 with initial values", function()
	local obs = create()
	expect(compareVectors(obs, { 0, 0, 0, 0 })).toBe(true)
end)
