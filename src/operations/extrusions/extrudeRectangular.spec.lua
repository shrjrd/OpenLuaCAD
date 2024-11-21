-- ROBLOX NOTE: no upstream
local JestGlobals = require("@DevPackages/JestGlobals")
local test, expect = JestGlobals.test, JestGlobals.expect

local TAU = require("../../maths/constants").TAU
local geom2, geom3
do
	local ref = require("../../geometries")
	geom2, geom3 = ref.geom2, ref.geom3
end
local arc, rectangle
do
	local ref = require("../../primitives")
	arc, rectangle = ref.arc, ref.rectangle
end
local extrudeRectangular = require("./init").extrudeRectangular
test("extrudeRectangular (defaults)", function()
	local geometry1 = arc({ radius = 5, endAngle = TAU / 4, segments = 16 })
	local geometry2 = rectangle({ size = { 5, 5 } })
	local obs = extrudeRectangular({}, geometry1)
	local pts = geom3.toPoints(obs)
	expect(function()
		return geom3.validate(obs)
	end)["not"].toThrow()
	expect(#pts).toBe(44)
	obs = extrudeRectangular({}, geometry2)
	pts = geom3.toPoints(obs)
	expect(function()
		return geom3.validate(obs)
	end)["not"].toThrow()
	expect(#pts).toBe(32)
end)
test("extrudeRectangular (chamfer)", function()
	local geometry1 = arc({ radius = 5, endAngle = TAU / 4, segments = 16 })
	local geometry2 = rectangle({ size = { 5, 5 } })
	local obs = extrudeRectangular({ corners = "chamfer" }, geometry1)
	local pts = geom3.toPoints(obs)
	expect(function()
		return geom3.validate(obs)
	end)["not"].toThrow()
	expect(#pts).toBe(60)
	obs = extrudeRectangular({ corners = "chamfer" }, geometry2)
	pts = geom3.toPoints(obs)
	expect(function()
		return geom3.validate(obs)
	end)["not"].toThrow()
	expect(#pts).toBe(48)
end)
test("extrudeRectangular (segments = 8, round)", function()
	local geometry1 = arc({ radius = 5, endAngle = TAU / 4, segments = 16 })
	local geometry2 = rectangle({ size = { 5, 5 } })
	local obs = extrudeRectangular({ segments = 8, corners = "round" }, geometry1)
	local pts = geom3.toPoints(obs)
	expect(function()
		return geom3.validate(obs)
	end)["not"].toThrow()
	expect(#pts).toBe(84)
	obs = extrudeRectangular({ segments = 8, corners = "round" }, geometry2)
	pts = geom3.toPoints(obs)
	expect(function()
		return geom3.validate(obs)
	end)["not"].toThrow()
	expect(#pts).toBe(64)
end)
test("extrudeRectangular (holes)", function()
	local geometry2 = geom2.create({
		{ { 15, 15 }, { -15, 15 } },
		{ { -15, 15 }, { -15, -15 } },
		{ { -15, -15 }, { 15, -15 } },
		{ { 15, -15 }, { 15, 15 } },
		{ { -5, 5 }, { 5, 5 } },
		{ { 5, 5 }, { 5, -5 } },
		{ { 5, -5 }, { -5, -5 } },
		{ { -5, -5 }, { -5, 5 } },
	})
	local obs = extrudeRectangular({ size = 2, height = 15, segments = 16, corners = "round" }, geometry2)
	local pts = geom3.toPoints(obs)
	expect(function()
		return geom3.validate(obs)
	end)["not"].toThrow()
	expect(#pts).toBe(192)
end)
