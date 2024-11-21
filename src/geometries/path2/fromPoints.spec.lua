-- ROBLOX NOTE: no upstream
local JestGlobals = require("@DevPackages/JestGlobals")
local test, expect = JestGlobals.test, JestGlobals.expect

local vec2 = require("../../maths/vec2")
local fromPoints, toPoints, toString
do
	local ref = require("./init")
	fromPoints, toPoints, toString = ref.fromPoints, ref.toPoints, ref.toString
end
test("fromPoints: creating a path from no points produces an open, empty non-canonical path", function()
	local created = fromPoints({}, {})
	expect(created.isClosed).toBe(false)
	expect(toPoints(created)).toEqual({})
end)
test("fromPoints: creating a path from one point produces a open, non-canonical path", function()
	local created = fromPoints({}, { { 1, 1 } })
	toString(created)
	expect(created.isClosed).toBe(false)
	expect(toPoints(created)).toEqual({ vec2.fromValues(1, 1) })
end)
test("fromPoints: creating a closed path from one point produces a closed, non-canonical path", function()
	local created = fromPoints({ closed = true }, { { 1, 1 } })
	expect(created.isClosed).toBe(true)
	expect(toPoints(created)).toEqual({ vec2.fromValues(1, 1) })
	toString(created)
end)
test("fromPoints: creating a path from a closed set of points creates a closed, non-canonical path", function()
	local created = fromPoints({ closed = false }, { { 0, 0 }, { 1, 0 }, { 1, 1 }, { 0, 0 } })
	expect(created.isClosed).toBe(true)
	expect(3).toBe(#created.points) -- the last given point is dropped
end)
