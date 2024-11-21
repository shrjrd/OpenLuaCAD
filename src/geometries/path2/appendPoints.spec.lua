-- ROBLOX NOTE: no upstream
local JestGlobals = require("@DevPackages/JestGlobals")
local test, expect = JestGlobals.test, JestGlobals.expect

local appendPoints, fromPoints, toPoints
do
	local ref = require("./init")
	appendPoints, fromPoints, toPoints = ref.appendPoints, ref.fromPoints, ref.toPoints
end
test("appendPoints: appending to an empty path produces a new path with expected points", function()
	local p1 = fromPoints({}, {})
	local obs = appendPoints({ { 1, 1 } }, p1)
	local pts = toPoints(obs)
	expect(p1)["not"].toBe(obs)
	expect(#pts).toBe(1)
end)
test("appendPoints: appending to a path produces a new path with expected points", function()
	local p1 = fromPoints({}, { { 1, 1 }, { 2, 2 } })
	local obs = appendPoints({ { 3, 3 }, { 4, 4 } }, p1)
	local pts = toPoints(obs)
	expect(p1)["not"].toBe(obs)
	expect(#pts).toBe(4)
end)
test("appendPoints: appending empty points to a path produces a new path with expected points", function()
	local p1 = fromPoints({}, { { 1, 1 }, { 2, 2 } })
	local obs = appendPoints({}, p1)
	local pts = toPoints(obs)
	expect(p1)["not"].toBe(obs)
	expect(#pts).toBe(2)
end)
test("appendPoints: appending same points to a path produces a new path with expected points", function()
	local p1 = fromPoints({}, { { 1, 1 }, { 2, 2 } })
	local obs = appendPoints({ { 2, 2 }, { 3, 3 } }, p1)
	local pts = toPoints(obs)
	expect(p1)["not"].toBe(obs)
	expect(#pts).toBe(3)
end)
