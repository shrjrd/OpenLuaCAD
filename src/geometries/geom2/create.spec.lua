-- ROBLOX NOTE: no upstream
local JestGlobals = require("@DevPackages/JestGlobals")
local test, expect = JestGlobals.test, JestGlobals.expect

local create = require("./init").create
test("create: Creates an empty geom2", function()
	local expected = { sides = {}, transforms = { 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1 } }
	expect(create()).toEqual(expected)
end)
test("create: Creates a populated geom2", function()
	local sides = { { { 0, 0 }, { 1, 1 } } }
	local expected = { sides = sides, transforms = { 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1 } }
	expect(create(sides)).toEqual(expected)
end)
