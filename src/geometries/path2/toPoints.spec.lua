-- ROBLOX NOTE: no upstream
local JestGlobals = require("@DevPackages/JestGlobals")
local test, expect = JestGlobals.test, JestGlobals.expect

local vec2 = require("../../maths/vec2")
local toPoints, fromPoints
do
	local ref = require("./init")
	toPoints, fromPoints = ref.toPoints, ref.fromPoints
end
test("toPoints: An empty path produces an empty point array", function()
	expect(toPoints(fromPoints({}, {}))).toEqual({})
end)
test("toPoints: An non-empty open path produces a matching point array", function()
	expect(toPoints(fromPoints({}, { { 1, 1 } }))).toEqual({ vec2.fromValues(1, 1) })
end)
