-- ROBLOX NOTE: no upstream
local JestGlobals = require("@DevPackages/JestGlobals")
local test, expect = JestGlobals.test, JestGlobals.expect

local TAU = require("../maths/constants").TAU
local radiusToSegments = require("./init").radiusToSegments
test("utils: radiusToSegments() should return correct values", function()
	-- test defaults
	local segments = radiusToSegments(100.0)
	expect(segments).toBe(4.0)
	segments = radiusToSegments(100.0, 0, 0)
	expect(segments).toBe(4.0) -- test specifying only length or angle
	segments = radiusToSegments(100.0, 2.0, 0)
	expect(segments).toBe(315)
	segments = radiusToSegments(100.0, 0, TAU / 20.0)
	expect(segments).toBe(20.0) -- test minimum length versus minimum angle
	segments = radiusToSegments(100.0, 31, TAU / 20.0)
	expect(segments).toBe(21.0)
	segments = radiusToSegments(100.0, 32, TAU / 20.0)
	expect(segments).toBe(20.0)
end)
