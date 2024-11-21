-- ROBLOX NOTE: no upstream
local JestGlobals = require("@DevPackages/JestGlobals")
local test, expect = JestGlobals.test, JestGlobals.expect

local measureArea, create
do
	local ref = require("./init")
	measureArea, create = ref.measureArea, ref.create
end
test("poly2. measureArea() should return correct values", function()
	local ply1 = create()
	local ret1 = measureArea(ply1)
	expect(ret1).toBe(0.0) -- simple triangle
	local ply2 = create({ { 0, 0 }, { 10, 0 }, { 10, 10 } })
	local ret2 = measureArea(ply2)
	expect(ret2).toBe(50.0)
	ply2 = create({ { 10, 10 }, { 10, 0 }, { 0, 0 } })
	ret2 = measureArea(ply2)
	expect(ret2).toBe(-50.0) -- simple square
	local ply3 = create({ { 0, 0 }, { 10, 0 }, { 10, 10 }, { 0, 10 } })
	local ret3 = measureArea(ply3)
	expect(ret3).toBe(100.0)
	ply3 = create({ { 0, 10 }, { 10, 10 }, { 10, 0 }, { 0, 0 } })
	ret3 = measureArea(ply3)
	expect(ret3).toBe(-100.0) -- V-shape
	local points = {
		{ 3, 0 },
		{ 5, 0 },
		{ 8, 2 },
		{ 6, 5 },
		{ 8, 6 },
		{ 5, 6 },
		{ 5, 2 },
		{ 2, 5 },
		{ 1, 3 },
		{
			3,
			3,
		},
	}
	local ply4 = create(points)
	local ret4 = measureArea(ply4)
	expect(ret4).toBe(19.5)
end)
