-- ROBLOX NOTE: no upstream
local JestGlobals = require("@DevPackages/JestGlobals")
local test, expect = JestGlobals.test, JestGlobals.expect

local create, equals, fromPoints
do
	local ref = require("./init")
	create, equals, fromPoints = ref.create, ref.equals, ref.fromPoints
end
test("create: Creates an empty path", function()
	expect(equals(create(), fromPoints({ closed = false }, {}))).toBe(true)
end)
