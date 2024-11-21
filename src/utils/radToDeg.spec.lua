-- ROBLOX NOTE: no upstream
local JestGlobals = require("@DevPackages/JestGlobals")
local test, expect = JestGlobals.test, JestGlobals.expect

local TAU = require("../maths/constants").TAU
local radToDeg = require("./init").radToDeg
test("utils: radToDeg() should return correct values", function()
	local obs1 = radToDeg(0)
	expect(obs1 == 0).toBe(true)
	local obs2 = radToDeg(TAU / 4)
	expect(obs2 == 90).toBe(true)
	local obs3 = radToDeg(TAU / 2)
	expect(obs3 == 180).toBe(true)
	local obs4 = radToDeg(TAU * 0.75)
	expect(obs4 == 270).toBe(true)
end)
