-- ROBLOX NOTE: no upstream
local JestGlobals = require("@DevPackages/JestGlobals")
local test, expect = JestGlobals.test, JestGlobals.expect

local equals, fromPoints
do
	local ref = require("./init")
	equals, fromPoints = ref.equals, ref.fromPoints
end
test("equals: two paths with different points are not equal", function()
	local p1 = fromPoints({ closed = false }, { { 0, 0 }, { 2, 0 }, { 2, 1 } })
	local p2 = fromPoints({ closed = false }, { { 0, 0 }, { 2, 0 }, { 2, 1 }, { 0, 1 } })
	expect(equals(p1, p2)).toBe(false)
	local p3 = fromPoints({ closed = true }, { { 2, 0 }, { 2, 1 }, { 0, 1 }, { 1, 0 } })
	local p4 = fromPoints({ closed = true }, { { 0, 0 }, { 2, 0 }, { 2, 1 }, { 0, 1 } })
	expect(equals(p3, p4)).toBe(false)
end)
test("equals: two open paths with the same points are equal", function()
	local p1 = fromPoints({ closed = false }, { { 0, 0 }, { 2, 0 }, { 2, 1 }, { 0, 1 } })
	local p2 = fromPoints({ closed = false }, { { 0, 0 }, { 2, 0 }, { 2, 1 }, { 0, 1 } })
	expect(equals(p1, p2)).toBe(true)
end)
test("equals: two open paths with the same points rotated are unequal", function()
	expect(
		equals(
			fromPoints({ closed = false }, { { 0, 0 }, { 2, 0 }, { 2, 1 }, { 0, 1 } }),
			fromPoints({ closed = false }, { { 2, 0 }, { 2, 1 }, { 0, 1 }, { 0, 0 } })
		)
	).toBe(false)
end)
test("equals: two closed paths with the same points are equal", function()
	expect(
		equals(
			fromPoints({ closed = true }, { { 0, 0 }, { 2, 0 }, { 2, 1 }, { 0, 1 } }),
			fromPoints({ closed = true }, { { 0, 0 }, { 2, 0 }, { 2, 1 }, { 0, 1 } })
		)
	).toBe(true) -- rotated
	expect(
		equals(
			fromPoints({ closed = true }, { { 0, 0 }, { 2, 0 }, { 2, 1 }, { 0, 1 } }),
			fromPoints({ closed = true }, { { 2, 0 }, { 2, 1 }, { 0, 1 }, { 0, 0 } })
		)
	).toBe(true)
end)
test("equals: closed path and open path with the same points are unequal", function()
	expect(
		equals(
			fromPoints({ closed = true }, { { 0, 0 }, { 2, 0 }, { 2, 1 }, { 0, 1 } }),
			fromPoints({ closed = false }, { { 0, 0 }, { 2, 0 }, { 2, 1 }, { 0, 1 } })
		)
	).toBe(false)
end)
