-- ROBLOX NOTE: no upstream
local JestGlobals = require("@DevPackages/JestGlobals")
local test, expect = JestGlobals.test, JestGlobals.expect

local isConvex, create, fromPoints
do
	local ref = require("./init")
	isConvex, create, fromPoints = ref.isConvex, ref.create, ref.fromPoints
end
test("poly3. isConvex() should return correct values", function()
	local ply1 = create()
	expect(isConvex(ply1)).toBe(true)
	local ply2 = fromPoints({ { 1, 1, 0 }, { 1, 0, 0 }, { 0, 0, 0 } })
	expect(isConvex(ply2)).toBe(true)
	local points2ccw = { { 0, 0, 3 }, { 10, 10, 3 }, { 0, 5, 3 } }
	local ply3 = fromPoints(points2ccw)
	expect(isConvex(ply3)).toBe(true)
	local points2cw = { { 0, 0, 3 }, { -10, 10, 3 }, { 0, 5, 3 } }
	local ply4 = fromPoints(points2cw)
	expect(isConvex(ply4)).toBe(true) -- V-shape
	local pointsV = { { 0, 0, 3 }, { -10, 10, 3 }, { 0, 5, 3 }, { 10, 10, 3 } }
	local ply5 = fromPoints(pointsV)
	expect(isConvex(ply5)).toBe(false)
end)
