-- ROBLOX NOTE: no upstream
local JestGlobals = require("@DevPackages/JestGlobals")
local test, expect = JestGlobals.test, JestGlobals.expect

local bezier = require("../init").bezier
local lengths = require("./lengths")
local nearlyEqual = require("../../../test/helpers/init").nearlyEqual
test("calculate lengths for a 1D linear bezier with numeric control points", function()
	local bezierCurve = bezier.create({ 0, 10 })
	local result = lengths(100, bezierCurve)
	expect(#result).toBe(101) -- with the default number of segments (100) the length of the array should be 101
	nearlyEqual(
		result[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		],
		0,
		0.0001
	) -- first element is always 0
	nearlyEqual(
		result[
			51 --[[ ROBLOX adaptation: added 1 to array index ]]
		],
		5,
		0.0001
	) -- the mid element contains half the curve length
	nearlyEqual(
		result[
			101 --[[ ROBLOX adaptation: added 1 to array index ]]
		],
		10,
		0.0001
	) -- the last element of the array contains the entire curve length
end)
test("calculate lengths for a 1D linear bezier with array control points", function()
	local bezierCurve = bezier.create({ { 0 }, { 10 } })
	local result = lengths(100, bezierCurve)
	expect(#result).toBe(101)
	nearlyEqual(
		result[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		],
		0,
		0.0001
	)
	nearlyEqual(
		result[
			51 --[[ ROBLOX adaptation: added 1 to array index ]]
		],
		5,
		0.0001
	)
	nearlyEqual(
		result[
			101 --[[ ROBLOX adaptation: added 1 to array index ]]
		],
		10,
		0.0001
	)
end)
test("calculate lengths for a 2D linear bezier", function()
	local bezierCurve = bezier.create({ { 0, 0 }, { 10, 10 } })
	local result = lengths(100, bezierCurve)
	expect(#result).toBe(101)
	nearlyEqual(
		result[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		],
		0,
		0.0001
	)
	nearlyEqual(
		result[
			51 --[[ ROBLOX adaptation: added 1 to array index ]]
		],
		7.0710,
		0.0001
	)
	nearlyEqual(
		result[
			101 --[[ ROBLOX adaptation: added 1 to array index ]]
		],
		14.1421,
		0.0001
	)
end)
test("calculate lengths for a 2D quadratic (3 control points) bezier", function()
	local bezierCurve = bezier.create({ { 0, 0 }, { 0, 10 }, { 10, 10 } })
	local result = lengths(100, bezierCurve)
	expect(#result).toBe(101)
	nearlyEqual(
		result[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		],
		0,
		0.0001
	)
	nearlyEqual(
		result[
			51 --[[ ROBLOX adaptation: added 1 to array index ]]
		],
		8.1160,
		0.0001
	)
	nearlyEqual(
		result[
			101 --[[ ROBLOX adaptation: added 1 to array index ]]
		],
		16.2320,
		0.0001
	)
end)
test("calculate lengths for a 2D cubic (4 control points) bezier", function()
	local bezierCurve = bezier.create({ { 0, 0 }, { 0, 10 }, { 10, 10 }, { 10, 0 } })
	local result = lengths(100, bezierCurve)
	expect(#result).toBe(101)
	nearlyEqual(
		result[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		],
		0,
		0.0001
	)
	nearlyEqual(
		result[
			51 --[[ ROBLOX adaptation: added 1 to array index ]]
		],
		9.9996,
		0.0001
	)
	nearlyEqual(
		result[
			101 --[[ ROBLOX adaptation: added 1 to array index ]]
		],
		19.9992,
		0.0001
	)
end)
test("calculate lengths for a 3D linear bezier", function()
	local bezierCurve = bezier.create({ { 0, 0, 0 }, { 10, 10, 10 } })
	local result = lengths(100, bezierCurve)
	expect(#result).toBe(101)
	nearlyEqual(
		result[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		],
		0,
		0.0001
	)
	nearlyEqual(
		result[
			51 --[[ ROBLOX adaptation: added 1 to array index ]]
		],
		8.6602,
		0.0001
	)
	nearlyEqual(
		result[
			101 --[[ ROBLOX adaptation: added 1 to array index ]]
		],
		17.3205,
		0.0001
	)
end)
test("calculate lengths for a 3D quadratic (3 control points) bezier", function()
	local bezierCurve = bezier.create({ { 0, 0, 0 }, { 5, 5, 5 }, { 0, 0, 10 } })
	local result = lengths(100, bezierCurve)
	expect(#result).toBe(101)
	nearlyEqual(
		result[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		],
		0,
		0.0001
	)
	nearlyEqual(
		result[
			51 --[[ ROBLOX adaptation: added 1 to array index ]]
		],
		6.3562,
		0.0001
	)
	nearlyEqual(
		result[
			101 --[[ ROBLOX adaptation: added 1 to array index ]]
		],
		12.7125,
		0.0001
	)
end)
test("calculate lengths for a 3D cubic (4 control points) bezier", function()
	local bezierCurve = bezier.create({ { 0, 0, 0 }, { 5, 5, 5 }, { 0, 0, 10 }, { -5, -5, 5 } })
	local result = lengths(100, bezierCurve)
	expect(#result).toBe(101)
	nearlyEqual(
		result[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		],
		0,
		0.0001
	)
	nearlyEqual(
		result[
			51 --[[ ROBLOX adaptation: added 1 to array index ]]
		],
		7.7617,
		0.0001
	)
	nearlyEqual(
		result[
			101 --[[ ROBLOX adaptation: added 1 to array index ]]
		],
		17.2116,
		0.0001
	)
end)
