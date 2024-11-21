-- ROBLOX NOTE: no upstream
local JestGlobals = require("@DevPackages/JestGlobals")
local test, expect = JestGlobals.test, JestGlobals.expect

local fromPoints = require("./init").fromPoints
test("fromPoints: creates populated geom2", function()
	local points = { { 0, 0 }, { 1, 0 }, { 0, 1 } }
	local expected = {
		sides = { { { 0, 1 }, { 0, 0 } }, { { 0, 0 }, { 1, 0 } }, { { 1, 0 }, { 0, 1 } } },
		transforms = { 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1 },
	}
	expect(fromPoints(points)).toEqual(expected)
	local points2 = { { 0, 0 }, { 1, 0 }, { 0, 1 }, { 0, 0 } }
	expect(fromPoints(points2)).toEqual(expected)
end)
test("fromPoints: throws for improper points", function()
	expect(function()
		return fromPoints()
	end).toThrowError(--[[{ instanceOf = Error }]])
	expect(function()
		return fromPoints(0, 0)
	end).toThrowError(--[[{ instanceOf = Error }]])
	expect(function()
		return fromPoints({})
	end).toThrowError(--[[{ instanceOf = Error }]])
	expect(function()
		return fromPoints({ { 0, 0 } })
	end).toThrowError(--[[{ instanceOf = Error }]])
end)
