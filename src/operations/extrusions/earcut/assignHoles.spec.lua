-- ROBLOX NOTE: no upstream
local JestGlobals = require("@DevPackages/JestGlobals")
local test, expect = JestGlobals.test, JestGlobals.expect

local subtract, union
do
	local ref = require("../../../operations/booleans")
	subtract, union = ref.subtract, ref.union
end
local square = require("../../../primitives/square")
local assignHoles = require("./assignHoles")
test("slice. assignHoles() should return a polygon hierarchy", function()
	local exp1 = {
		{
			solid = {
				{ -3.000013333333334, -3.000013333333334 },
				{ 3.000013333333334, -3.000013333333334 },
				{ 3.000013333333334, 3.000013333333334 },
				{ -3.000013333333334, 3.000013333333334 },
			},
			holes = {
				{
					{ -1.9999933333333335, 1.9999933333333335 },
					{ 1.9999933333333335, 1.9999933333333335 },
					{ 1.9999933333333335, -1.9999933333333335 },
					{ -1.9999933333333335, -1.9999933333333335 },
				},
			},
		},
	}
	local geometry = subtract(square({ size = 6 }), square({ size = 4 }))
	local obs1 = assignHoles(geometry)
	expect(obs1).toEqual(exp1)
end)
test("slice. assignHoles() should handle nested holes", function()
	local geometry = union(
		subtract(square({ size = 6 }), square({ size = 4 })),
		subtract(square({ size = 10 }), square({ size = 8 }))
	)
	local obs1 = assignHoles(geometry)
	local exp1 = {
		{
			solid = {
				{ -3.0000006060444444, -3.0000006060444444 },
				{ 3.0000006060444444, -3.0000006060444444 },
				{ 3.0000006060444444, 3.0000006060444444 },
				{ -3.0000006060444444, 3.0000006060444444 },
			},
			holes = {
				{
					{ -2.0000248485333336, 2.0000248485333336 },
					{ 2.0000248485333336, 2.0000248485333336 },
					{ 2.0000248485333336, -2.0000248485333336 },
					{ -2.0000248485333336, -2.0000248485333336 },
				},
			},
		},
		{
			solid = {
				{ -5.000025454577778, -5.000025454577778 },
				{ 5.000025454577778, -5.000025454577778 },
				{ 5.000025454577778, 5.000025454577778 },
				{ -5.000025454577778, 5.000025454577778 },
			},
			holes = {
				{
					{ -3.9999763635555556, 3.9999763635555556 },
					{ 3.9999763635555556, 3.9999763635555556 },
					{ 3.9999763635555556, -3.9999763635555556 },
					{ -3.9999763635555556, -3.9999763635555556 },
				},
			},
		},
	}
	expect(obs1).toEqual(exp1)
end)
