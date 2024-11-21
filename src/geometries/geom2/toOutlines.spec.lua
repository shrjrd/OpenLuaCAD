-- ROBLOX NOTE: no upstream
local JestGlobals = require("@DevPackages/JestGlobals")
local test, expect = JestGlobals.test, JestGlobals.expect

local create = require("./init").create
local comparePoints = require("../../../test/helpers").comparePoints
local toOutlines = require("./toOutlines")
test("geom2. toOutlines() should return no outlines for empty geom2", function()
	local shp1 = create()
	local exp1 = {}
	local ret1 = toOutlines(shp1)
	expect(comparePoints(exp1, ret1)).toBe(true)
end)
test("geom2. toOutlines() should return one or more outlines", function()
	local shp1 = create({ { { -1, -1 }, { 1, -1 } }, { { 1, -1 }, { 1, 1 } }, { { 1, 1 }, { -1, -1 } } })
	local ret1 = toOutlines(shp1)
	local exp1 = { { { 1, -1 }, { 1, 1 }, { -1, -1 } } }
	expect(comparePoints(
		ret1[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		],
		exp1[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		]
	)).toBe(true)
	local shp2 = create({
		{ { -1, -1 }, { 1, -1 } },
		{ { 1, -1 }, { 1, 1 } },
		{ { 1, 1 }, { -1, -1 } },
		{ { 4, 4 }, { 6, 4 } },
		{ { 6, 4 }, { 6, 6 } },
		{ { 6, 6 }, { 4, 4 } },
	})
	local ret2 = toOutlines(shp2)
	local exp2 = { { { 1, -1 }, { 1, 1 }, { -1, -1 } }, { { 6, 4 }, { 6, 6 }, { 4, 4 } } }
	expect(comparePoints(
		ret2[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		],
		exp2[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		]
	)).toBe(true)
	expect(comparePoints(
		ret2[
			2 --[[ ROBLOX adaptation: added 1 to array index ]]
		],
		exp2[
			2 --[[ ROBLOX adaptation: added 1 to array index ]]
		]
	)).toBe(true)
end)
test("geom2. toOutlines() should return outlines for holes in geom2", function()
	local shp1 = create({
		{ { 10, 10 }, { -10, -10 } },
		{ { -10, -10 }, { 10, -10 } },
		{ { 10, -10 }, { 10, 10 } },
		{ { 5, -5 }, { 6, -4 } },
		{ { 6, -5 }, { 5, -5 } },
		{ { 6, -4 }, { 6, -5 } },
	})
	local ret1 = toOutlines(shp1)
	local exp1 = { { { -10, -10 }, { 10, -10 }, { 10, 10 } }, { { 6, -4 }, { 6, -5 }, { 5, -5 } } }
	expect(comparePoints(
		ret1[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		],
		exp1[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		]
	)).toBe(true)
	expect(comparePoints(
		ret1[
			2 --[[ ROBLOX adaptation: added 1 to array index ]]
		],
		exp1[
			2 --[[ ROBLOX adaptation: added 1 to array index ]]
		]
	)).toBe(true)
	local shp2 = create({
		{ { 6, -4 }, { 5, -5 } },
		{ { 5, -5 }, { 6, -5 } },
		{ { 6, -5 }, { 6, -4 } },
		{ { 10, 10 }, { -10, -10 } },
		{ { -10, -10 }, { 10, -10 } },
		{ { 10, -10 }, { 10, 10 } },
		{ { -6, -8 }, { 8, 6 } },
		{ { 8, -8 }, { -6, -8 } },
		{ { 8, 6 }, { 8, -8 } },
	})
	local ret2 = toOutlines(shp2)
	local exp2 = {
		{ { 5, -5 }, { 6, -5 }, { 6, -4 } },
		{ { -10, -10 }, { 10, -10 }, { 10, 10 } },
		{ { 8, 6 }, { 8, -8 }, { -6, -8 } },
	}
	expect(comparePoints(
		ret2[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		],
		exp2[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		]
	)).toBe(true)
	expect(comparePoints(
		ret2[
			2 --[[ ROBLOX adaptation: added 1 to array index ]]
		],
		exp2[
			2 --[[ ROBLOX adaptation: added 1 to array index ]]
		]
	)).toBe(true)
	expect(comparePoints(
		ret2[
			3 --[[ ROBLOX adaptation: added 1 to array index ]]
		],
		exp2[
			3 --[[ ROBLOX adaptation: added 1 to array index ]]
		]
	)).toBe(true)
end)
test("geom2. toOutlines() should return outlines for edges that touch in geom2", function()
	local shp1 = create({
		{ { 5, 15 }, { 5, 5 } },
		{ { 5, 5 }, { 15, 5 } },
		{ { 15, 5 }, { 15, 15 } },
		{ { 15, 15 }, { 5, 15 } },
		{ { -5, 5 }, { -5, -5 } },
		{ { -5, -5 }, { 5, -5 } },
		{ { 5, -5 }, { 5, 5 } },
		{ { 5, 5 }, { -5, 5 } },
	})
	local ret1 = toOutlines(shp1)
	local exp1 = {
		{ { 5, 5 }, { 15, 5 }, { 15, 15 }, { 5, 15 } },
		{ { -5, 5 }, { -5, -5 }, { 5, -5 }, {
			5,
			5,
		} },
	}
	expect(comparePoints(
		ret1[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		],
		exp1[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		]
	)).toBe(true)
	expect(comparePoints(
		ret1[
			2 --[[ ROBLOX adaptation: added 1 to array index ]]
		],
		exp1[
			2 --[[ ROBLOX adaptation: added 1 to array index ]]
		]
	)).toBe(true)
end)
test("geom2. toOutlines() should return outlines for holes that touch in geom2", function()
	local shp1 = create({
		{ { -20, 20 }, { -20, -20 } },
		{ { -20, -20 }, { 20, -20 } },
		{ { 20, -20 }, { 20, 20 } },
		{ { 20, 20 }, { -20, 20 } },
		{ { 5, 5 }, { 5, 15 } },
		{ { 15, 5 }, { 5, 5 } },
		{ { 15, 15 }, { 15, 5 } },
		{ { 5, 15 }, { 15, 15 } },
		{ { -5, -5 }, { -5, 5 } },
		{ { 5, -5 }, { -5, -5 } },
		{ { 5, 5 }, { 5, -5 } },
		{ { -5, 5 }, { 5, 5 } },
	})
	local ret1 = toOutlines(shp1)
	local exp1 = {
		{ { -20, -20 }, { 20, -20 }, { 20, 20 }, { -20, 20 } },
		{ { 5, 15 }, { 15, 15 }, { 15, 5 }, { 5, 5 } },
		{ { 5, -5 }, { -5, -5 }, { -5, 5 }, { 5, 5 } },
	}
	expect(comparePoints(
		ret1[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		],
		exp1[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		]
	)).toBe(true)
	expect(comparePoints(
		ret1[
			2 --[[ ROBLOX adaptation: added 1 to array index ]]
		],
		exp1[
			2 --[[ ROBLOX adaptation: added 1 to array index ]]
		]
	)).toBe(true)
	expect(comparePoints(
		ret1[
			3 --[[ ROBLOX adaptation: added 1 to array index ]]
		],
		exp1[
			3 --[[ ROBLOX adaptation: added 1 to array index ]]
		]
	)).toBe(true)
end) -- touching holes
