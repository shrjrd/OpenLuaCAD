-- ROBLOX NOTE: no upstream
local JestGlobals = require("@DevPackages/JestGlobals")
local test, expect = JestGlobals.test, JestGlobals.expect

local poly3 = require("../poly3")
local create = require("./init").create
test("create: Creates an empty geom3", function()
	local expected = { polygons = {}, transforms = { 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1 } }
	expect(create()).toEqual(expected)
end)
test("create: Creates a populated geom3", function()
	local points = { { 0, 0, 0 }, { 0, 10, 0 }, { 0, 10, 10 } }
	local polygon = poly3.create(points)
	local polygons = { polygon }
	local expected = { polygons = polygons, transforms = { 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1 } }
	expect(create(polygons)).toEqual(expected)
end)
