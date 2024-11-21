-- ROBLOX NOTE: no upstream
local JestGlobals = require("@DevPackages/JestGlobals")
local test, expect = JestGlobals.test, JestGlobals.expect

local fromPoints = require("./init").fromPoints
local applyTransforms = require("./applyTransforms")
test("applyTransforms: Updates a populated geom2 with transformed sides", function()
	local points = { { 0, 0 }, { 1, 0 }, { 0, 1 } }
	local expected = {
		sides = { { { 0, 1 }, { 0, 0 } }, { { 0, 0 }, { 1, 0 } }, { { 1, 0 }, { 0, 1 } } },
		transforms = { 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1 },
	}
	local geometry = fromPoints(points)
	local updated = applyTransforms(geometry)
	expect(geometry).toBe(updated)
	expect(updated).toEqual(expected)
	local updated2 = applyTransforms(updated)
	expect(updated).toBe(updated2)
	expect(updated).toEqual(expected)
end)
