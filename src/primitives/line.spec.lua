-- ROBLOX NOTE: no upstream
local JestGlobals = require("@DevPackages/JestGlobals")
local test, expect = JestGlobals.test, JestGlobals.expect

local line = require("./init").line
local path2 = require("../geometries/path2")
local comparePoints = require("../../test/helpers/comparePoints")
test("line (defaults)", function()
	local exp = { { 0, 0 }, { 1, 1 }, { -3, 3 } }
	local geometry = line({ { 0, 0 }, { 1, 1 }, { -3, 3 } })
	local obs = path2.toPoints(geometry)
	expect(function()
		return path2.validate(geometry)
	end).never.toThrow()
	expect(#obs).toEqual(3)
	expect(comparePoints(obs, exp)).toBe(true)
end)
