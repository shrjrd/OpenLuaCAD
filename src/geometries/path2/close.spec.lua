-- ROBLOX NOTE: no upstream
local JestGlobals = require("@DevPackages/JestGlobals")
local test, expect = JestGlobals.test, JestGlobals.expect

local close, create, fromPoints
do
	local ref = require("./init")
	close, create, fromPoints = ref.close, ref.create, ref.fromPoints
end
test("close: closes an empty path", function()
	local p1 = create()
	expect(p1.isClosed).toBe(false)
	local p2 = close(p1)
	expect(p2.isClosed).toBe(true)
	expect(p1)["not"].toBe(p2)
	local p3 = close(p2)
	expect(p3.isClosed).toBe(true)
	expect(p2).toBe(p3)
end)
test("close: closes various paths", function()
	local p1 = create()
	p1 = close(p1)
	expect(p1.isClosed).toBe(true)
	expect(0).toBe(#p1.points)
	local p2 = fromPoints({ closed = false }, {})
	p2 = close(p2)
	expect(p2.isClosed).toBe(true)
	expect(0).toBe(#p2.points)
	local p3 = fromPoints({ closed = true }, { { 0, 0 } })
	p3 = close(p3)
	expect(p3.isClosed).toBe(true)
	expect(1).toBe(#p3.points)
	local p4 = fromPoints({ closed = true }, { { 0, 0 }, { 0, 0 } })
	p4 = close(p4)
	expect(p4.isClosed).toBe(true)
	expect(1).toBe(#p4.points) -- the last point is removed
	local p5 = fromPoints({ closed = true }, { { 0, 0 }, { 1, 1 }, { 0, 0 } })
	p5 = close(p5)
	expect(p5.isClosed).toBe(true)
	expect(2).toBe(#p5.points) -- the last point is removed
end)
