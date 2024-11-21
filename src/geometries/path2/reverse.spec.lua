-- ROBLOX NOTE: no upstream
local JestGlobals = require("@DevPackages/JestGlobals")
local test, expect = JestGlobals.test, JestGlobals.expect

local reverse, equals, fromPoints
do
	local ref = require("./init")
	reverse, equals, fromPoints = ref.reverse, ref.equals, ref.fromPoints
end
test("reverse: The reverse of a path has reversed points", function()
	local pointArray = { { 0, 0 }, { 1, 1 } }
	expect(equals(reverse(fromPoints({}, pointArray)), fromPoints({}, pointArray))).toBe(false)
end)
