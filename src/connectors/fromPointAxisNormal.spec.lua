-- ROBLOX NOTE: no upstream
local JestGlobals = require("@DevPackages/JestGlobals")
local test, expect = JestGlobals.test, JestGlobals.expect

local fromPointAxisNormal = require("./init").fromPointAxisNormal
local compareVectors = require("../../test/helpers/").compareVectors
test("connector: fromPointAxisNormal() should return a new connector with correct values", function()
	local obs = fromPointAxisNormal({ 0, 0, 0 }, { 1, 0, 0 }, { 0, 1, 0 })
	expect(compareVectors(obs.point, { 0, 0, 0 })).toBe(true)
	expect(compareVectors(obs.axis, { 1, 0, 0 })).toBe(true)
	expect(compareVectors(obs.normal, { 0, 1, 0 })).toBe(true)
	obs = fromPointAxisNormal({ 0, 0, 0 }, { 0, 2, 0 }, { 0, 0, 4 })
	expect(compareVectors(obs.point, { 0, 0, 0 })).toBe(true)
	expect(compareVectors(obs.axis, { 0, 1, 0 })).toBe(true)
	expect(compareVectors(obs.normal, { 0, 0, 1 })).toBe(true)
	obs = fromPointAxisNormal({ 5, 5, 5 }, { 0, 0, 10 }, { 0, 10, 5 })
	expect(compareVectors(obs.point, { 5, 5, 5 })).toBe(true)
	expect(compareVectors(obs.axis, { 0, 0, 1 })).toBe(true)
	expect(compareVectors(obs.normal, { 0, 0.8944271909999159, 0.4472135954999579 })).toBe(true)
end)
