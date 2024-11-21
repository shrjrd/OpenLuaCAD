-- ROBLOX NOTE: no upstream
local JestGlobals = require("@DevPackages/JestGlobals")
local test, expect = JestGlobals.test, JestGlobals.expect

local geom3 = require("../geometries/geom3")
local measureBoundingBox = require("../measurements/measureBoundingBox")
local TAU = require("../maths/constants").TAU
local comparePoints = require("../../test/helpers/comparePoints")
local torus = require("./init").torus
test("torus (defaults)", function()
	local obs = torus()
	local pts = geom3.toPoints(obs)
	expect(function()
		return geom3.validate(obs)
	end)["not"].toThrow()
	expect(#pts).toBe(2048) -- 32 * 32 * 2 (polys/segment) = 2048
	local bounds = measureBoundingBox(obs)
	local expectedBounds = { { -5, -5, -1 }, { 5, 5, 1 } }
	expect(comparePoints(bounds, expectedBounds)).toBe(true)
end)
test("torus (simple options)", function()
	local obs = torus({ innerRadius = 0.5, innerSegments = 4, outerRadius = 5, outerSegments = 8 })
	local pts = geom3.toPoints(obs)
	expect(function()
		return geom3.validate(obs)
	end)["not"].toThrow()
	expect(#pts).toBe(64) -- 4 * 8 * 2 (polys/segment) = 64
	local bounds = measureBoundingBox(obs)
	local expectedBounds = { { -5.5, -5.5, -0.5 }, { 5.5, 5.5, 0.5 } }
	expect(comparePoints(bounds, expectedBounds)).toBe(true)
end)
test("torus (complex options)", function()
	local obs = torus({
		innerRadius = 1,
		outerRadius = 5,
		innerSegments = 32,
		outerSegments = 72,
		startAngle = TAU / 4,
		outerRotation = TAU / 4,
	})
	local pts = geom3.toPoints(obs)
	expect(function()
		return geom3.validate(obs)
	end)["not"].toThrow()
	expect(#pts).toBe(1212)
	local bounds = measureBoundingBox(obs)
	local expectedBounds = { { -6, 0, -1 }, { 0, 6, 1 } }
	expect(comparePoints(bounds, expectedBounds)).toBe(true)
end)
test("torus (startAngle)", function()
	local obs = torus({ startAngle = 1, endAngle = 1 + TAU })
	local pts = geom3.toPoints(obs)
	expect(function()
		return geom3.validate(obs)
	end)["not"].toThrow()
	expect(#pts).toBe(2048)
end)
test("torus (square by square)", function()
	local obs = torus({ innerSegments = 4, outerSegments = 4, innerRotation = TAU / 4 })
	local bounds = measureBoundingBox(obs)
	local expectedBounds = { { -5, -5, -1 }, { 5, 5, 1 } }
	expect(function()
		return geom3.validate(obs)
	end)["not"].toThrow()
	expect(comparePoints(bounds, expectedBounds)).toBe(true)
end)
