-- ROBLOX NOTE: no upstream
local JestGlobals = require("@DevPackages/JestGlobals")
local test, expect = JestGlobals.test, JestGlobals.expect

local fromSides = require("./init").fromSides
test("slice. fromSides() should return a new slice with correct values", function()
	local exp1 = {
		edges = {
			{ { 0, 0, 0 }, { 1, 0, 0 } },
			{ { 1, 0, 0 }, { 1, 1, 0 } },
			{
				{ 1, 1, 0 },
				{ 0, 0, 0 },
			},
		},
	}
	local obs1 = fromSides({ { { 0, 0 }, { 1, 0 } }, { { 1, 0 }, { 1, 1 } }, { { 1, 1 }, { 0, 0 } } })
	expect(obs1).toEqual(exp1)
end)
