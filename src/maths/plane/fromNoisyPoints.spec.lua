-- ROBLOX NOTE: no upstream
local JestGlobals = require("@DevPackages/JestGlobals")
local test, expect = JestGlobals.test, JestGlobals.expect

local fromNoisyPoints, create
do
	local ref = require("./init")
	fromNoisyPoints, create = ref.fromNoisyPoints, ref.create
end
local compareVectors = require("../../../test/helpers/init").compareVectors
test("plane. fromNoisyPoints() should return a new plane with correct values", function()
	local obs1 = fromNoisyPoints(create(), { 0, 0, 0 }, { 1, 0, 0 }, { 1, 1, 0 })
	expect(compareVectors(obs1, { 0, 0, 1, 0 })).toBe(true)
	local obs2 = fromNoisyPoints(obs1, { 0, 6, 0 }, { 0, 2, 2 }, { 0, 6, 6 })
	expect(compareVectors(obs2, { 1, 0, 0, 0 })).toBe(true) -- same vertices results in an invalid plane
	local obs3 = fromNoisyPoints(obs1, { 0, 6, 0 }, { 0, 6, 0 }, { 0, 6, 0 })
	expect(compareVectors(obs3, { 0 / 0, 0 / 0, 0 / 0, 0 / 0 })).toBe(true) -- co-linear vertices
	local obs4 = fromNoisyPoints(obs1, { 0, 0, 0 }, { 1, 0, 0 }, { 2, 0, 0 }, { 0, 1, 0 })
	expect(compareVectors(obs4, { 0, 0, 1, 0 })).toBe(true) -- random vertices
	local obs5 = fromNoisyPoints(obs1, { 0, 0, 0 }, { 5, 1, -2 }, { 3, -2, 4 }, { 1, 1, 0 })
	expect(compareVectors(obs5, { 0.08054818365229491, 0.8764542170444571, 0.47469990050062555, 0.4185833634679763 })).toBe(
		true
	)
end)
