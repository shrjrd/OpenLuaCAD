-- ROBLOX NOTE: no upstream
local JestGlobals = require("@DevPackages/JestGlobals")
local test, expect = JestGlobals.test, JestGlobals.expect

local fromPoints, create
do
	local ref = require("./init")
	fromPoints, create = ref.fromPoints, ref.create
end
local compareVectors = require("../../../test/helpers/init").compareVectors
test("plane. fromPoints() should return a new plane with correct values", function()
	local obs1 = fromPoints(create(), { 0, 0, 0 }, { 1, 0, 0 }, { 1, 1, 0 })
	expect(compareVectors(obs1, { 0, 0, 1, 0 })).toBe(true)
	local obs2 = fromPoints(obs1, { 0, 6, 0 }, { 0, 2, 2 }, { 0, 6, 6 })
	expect(compareVectors(obs2, { -1, 0, 0, 0 })).toBe(true) -- planes created from the same points results in an invalid plane
	local obs3 = fromPoints(obs1, { 0, 6, 0 }, { 0, 6, 0 }, { 0, 6, 0 })
	expect(compareVectors(obs3, { 0 / 0, 0 / 0, 0 / 0, 0 / 0 })).toBe(true) -- polygon with co-linear vertices
	local obs4 = fromPoints(obs1, { 0, 0, 0 }, { 1, 0, 0 }, { 2, 0, 0 }, { 0, 1, 0 })
	expect(compareVectors(obs4, { 0, 0, 1, 0 })).toBe(true)
end)
