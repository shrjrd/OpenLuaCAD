-- ROBLOX NOTE: no upstream
local JestGlobals = require("@DevPackages/JestGlobals")
local test, expect = JestGlobals.test, JestGlobals.expect

local concat, equals, fromPoints
do
	local ref = require("./init")
	concat, equals, fromPoints = ref.concat, ref.equals, ref.fromPoints
end
test("concat: No paths produces an empty open path", function()
	expect(equals(concat(), fromPoints({ closed = false }, {}))).toBe(true)
end)
test("concat: empty paths produces an empty open path", function()
	expect(equals(concat(fromPoints({}, {}), fromPoints({}, {})), fromPoints({ closed = false }, {}))).toBe(true)
end)
test("concat: many open paths produces a open path", function()
	local p1 = fromPoints({ closed = false }, { { 0, 0 } })
	local p2 = fromPoints({ closed = false }, { { 1, 1 } })
	local p3 = fromPoints({ closed = false }, { { 1, 1 }, { 3, 3 } })
	local result = concat(p1, p2, p3)
	expect(equals(result, fromPoints({}, { { 0, 0 }, { 1, 1 }, { 3, 3 } }))).toBe(true)
	expect(#p1.points).toBe(1)
	expect(#p2.points).toBe(1)
	expect(#p3.points).toBe(2)
end)
test("concat: An open path and a closed path produces a closed path", function()
	expect(
		equals(
			concat(fromPoints({ closed = false }, { { 0, 0 } }), fromPoints({ closed = true }, { { 1, 1 } })),
			fromPoints({ closed = true }, { { 0, 0 }, { 1, 1 } })
		)
	).toBe(true)
end)
test("concat: A closed path and an open path throws an error", function()
	local p1 = fromPoints({ closed = true }, { { 0, 0 } })
	local p2 = fromPoints({ closed = false }, { { 1, 1 } })
	expect(function()
		return concat(p1, p2)
	end).toThrowError({ message = "Cannot concatenate to a closed path; check the 1th path" })
end)
