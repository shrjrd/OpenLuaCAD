-- ROBLOX NOTE: no upstream
local JestGlobals = require("@DevPackages/JestGlobals")
local test, expect = JestGlobals.test, JestGlobals.expect

local create = require("./init").create
test("slice. create() should return a slice with initial values", function()
	local obs = create()
	local exp = { edges = {} }
	expect(obs).toEqual(exp)
end)
