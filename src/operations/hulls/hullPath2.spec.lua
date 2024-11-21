-- ROBLOX NOTE: no upstream
local JestGlobals = require("@DevPackages/JestGlobals")
local test, expect = JestGlobals.test, JestGlobals.expect

local path2 = require("../../geometries").path2
local hullPath2 = require("./hullPath2")
test("hullPath2", function()
	local closed = true
	local geometry1 = path2.fromPoints({ closed = closed }, { { 0, 0 }, { -4, 4 }, { -4, -4 } })
	local geometry2 = path2.fromPoints({ closed = closed }, { { 0, 0 }, { 4, -4 }, { 4, 4 } })
	local obs = hullPath2(geometry1, geometry2)
	expect(function()
		return path2.validate(obs)
	end)["not"].toThrow()
	local pts = path2.toPoints(obs)
	expect(#pts).toBe(4)
end)
