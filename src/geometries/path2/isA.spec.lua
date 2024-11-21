-- ROBLOX NOTE: no upstream
local JestGlobals = require("@DevPackages/JestGlobals")
local test, expect = JestGlobals.test, JestGlobals.expect

local isA, create, fromPoints
do
	local ref = require("./init")
	isA, create, fromPoints = ref.isA, ref.create, ref.fromPoints
end
test("isA: identifies created paths", function()
	local p1 = create()
	local p2 = fromPoints({}, { { 0, 0 } })
	expect(isA(p1)).toBe(true)
	expect(isA(p2)).toBe(true)
end)
test("isA: identifies non paths", function()
	local p1 = nil
	local p2 = {}
	local p3 = { points = 1, transforms = 1, isClosed = 1 }
	expect(isA(p1)).toBe(false)
	expect(isA(p2)).toBe(false)
	expect(isA(p3)).toBe(false)
end)
