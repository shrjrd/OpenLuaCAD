-- ROBLOX NOTE: no upstream
local JestGlobals = require("@DevPackages/JestGlobals")
local test, expect = JestGlobals.test, JestGlobals.expect

local TAU = require("../maths/constants").TAU
local degToRad = require("./init").degToRad
test("utils: degToRad() should return correct values", function()
	local obs1 = degToRad(0)
	expect(obs1).toBeCloseTo(0) --expect(obs1 == 0).toBe(true)
	local obs2 = degToRad(90)
	expect(obs2).toBeCloseTo(TAU / 4) --expect(obs2 == TAU / 4).toBe(true)
	local obs3 = degToRad(180)
	expect(obs3).toBeCloseTo(TAU / 2) --expect(obs3 == TAU / 2).toBe(true)
	local obs4 = degToRad(270)
	expect(obs4).toBeCloseTo(TAU * 0.75) --expect(obs4 == TAU * 0.75).toBe(true)
end)
