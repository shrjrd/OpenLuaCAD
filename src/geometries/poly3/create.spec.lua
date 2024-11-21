-- ROBLOX NOTE: no upstream
local JestGlobals = require("@DevPackages/JestGlobals")
local test, expect = JestGlobals.test, JestGlobals.expect

local create = require("./init").create
test("poly3. create() should return a poly3 with initial values", function()
	local obs = create()
	local exp = { vertices = {} }
	expect(obs).toEqual(exp)
end)
