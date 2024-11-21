-- ROBLOX NOTE: no upstream
local JestGlobals = require("@DevPackages/JestGlobals")
local test, expect = JestGlobals.test, JestGlobals.expect

local fromPoints = require("./init").fromPoints
test("slice. fromPoints() should return a new slice with correct values", function()
	local exp1 = {
		edges = {
			{ { 1, 1, 0 }, { 0, 0, 0 } },
			{ { 0, 0, 0 }, { 1, 0, 0 } },
			{
				{ 1, 0, 0 },
				{ 1, 1, 0 },
			},
		},
	}
	local obs1 = fromPoints({ { 0, 0 }, { 1, 0 }, { 1, 1 } })
	expect(obs1).toEqual(exp1)
end)
