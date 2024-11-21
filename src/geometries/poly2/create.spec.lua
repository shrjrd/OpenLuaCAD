-- ROBLOX NOTE: no upstream
local JestGlobals = require("@DevPackages/JestGlobals")
local test, expect = JestGlobals.test, JestGlobals.expect

local create = require("./init").create
test("poly2. create() should return a poly2 with initial values", function()
	local obs = create()
	local exp = { vertices = {} }
	expect(obs).toEqual(exp)
	obs = create({ { 1, 1 }, { 2, 2 }, { 3, 3 } })
	exp = { vertices = { { 1, 1 }, { 2, 2 }, { 3, 3 } } }
	expect(obs).toEqual(exp)
end)
