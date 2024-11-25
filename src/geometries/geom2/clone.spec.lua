-- ROBLOX NOTE: no upstream
local JestGlobals = require("@DevPackages/JestGlobals")
local test, expect = JestGlobals.test, JestGlobals.expect

local clone, create, fromPoints
do
	local ref = require("./init")
	clone, create, fromPoints = ref.clone, ref.create, ref.fromPoints
end
test("clone: Creates a clone on an empty geom2", function()
	local expected = { sides = {}, transforms = { 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1 } }
	local geometry = create()
	local another = clone(geometry)
	expect(another).never.toBe(geometry)
	expect(another).toEqual(expected)
end)
test("clone: Creates a clone of a complete geom2", function()
	local points = { { 0, 0 }, { 1, 0 }, { 0, 1 } }
	local expected = {
		sides = { { { 0, 1 }, { 0, 0 } }, { { 0, 0 }, { 1, 0 } }, { { 1, 0 }, { 0, 1 } } },
		transforms = { 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1 },
	}
	local geometry = fromPoints(points)
	local another = clone(geometry)
	expect(another).never.toBe(geometry)
	expect(another).toEqual(expected)
end)
