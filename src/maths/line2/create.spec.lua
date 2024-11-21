-- ROBLOX NOTE: no upstream
local JestGlobals = require("@DevPackages/JestGlobals")
local test, expect = JestGlobals.test, JestGlobals.expect

local create = require("./init").create
local compareVectors = require("../../../test/helpers/init").compareVectors
test("line2. create() should return a line2 with initial values", function()
	local obs = create()
	expect(compareVectors(obs, { 0, 1, 0 })).toBe(true)
end)
