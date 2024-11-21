-- ROBLOX NOTE: no upstream
local JestGlobals = require("@DevPackages/JestGlobals")
local test, expect = JestGlobals.test, JestGlobals.expect

local comparePolygonsAsPoints = require("../../../test/helpers/comparePolygonsAsPoints")
local TAU = require("../../maths/constants").TAU
local mat4 = require("../../maths/mat4")
local geom2, geom3, poly3
do
	local ref = require("../../geometries")
	geom2, geom3, poly3 = ref.geom2, ref.geom3, ref.poly3
end
local circle = require("../../primitives").circle
local extrudeFromSlices, slice
do
	local ref = require("./init")
	extrudeFromSlices, slice = ref.extrudeFromSlices, ref.slice
end
test("extrudeFromSlices (defaults)", function()
	local geometry2 = geom2.fromPoints({ { 10, 10 }, { -10, 10 }, { -10, -10 }, { 10, -10 } })
	local geometry3 = extrudeFromSlices({}, geometry2)
	local pts = geom3.toPoints(geometry3)
	local exp = {
		{ { 10, -10, 0 }, { 10, 10, 0 }, { 10, 10, 1 } },
		{ { 10, -10, 0 }, { 10, 10, 1 }, { 10, -10, 1 } },
		{ { 10, 10, 0 }, { -10, 10, 0 }, { -10, 10, 1 } },
		{ { 10, 10, 0 }, { -10, 10, 1 }, { 10, 10, 1 } },
		{ { -10, 10, 0 }, { -10, -10, 0 }, { -10, -10, 1 } },
		{ { -10, 10, 0 }, { -10, -10, 1 }, { -10, 10, 1 } },
		{ { -10, -10, 0 }, { 10, -10, 0 }, { 10, -10, 1 } },
		{ { -10, -10, 0 }, { 10, -10, 1 }, { -10, -10, 1 } },
		{ { -10, -10, 1 }, { 10, -10, 1 }, { 10, 10, 1 } },
		{ { 10, 10, 1 }, { -10, 10, 1 }, { -10, -10, 1 } },
		{ { 10, 10, 0 }, { 10, -10, 0 }, { -10, -10, 0 } },
		{ { -10, -10, 0 }, { -10, 10, 0 }, { 10, 10, 0 } },
	}
	expect(#pts).toBe(12)
	expect(comparePolygonsAsPoints(pts, exp)).toBe(true)
	local poly2 = poly3.create({ { 10, 10, 0 }, { -10, 10, 0 }, { -10, -10, 0 }, { 10, -10, 0 } })
	geometry3 = extrudeFromSlices({}, poly2)
	pts = geom3.toPoints(geometry3)
	expect(function()
		return geom3.validate(geometry3)
	end)["not"].toThrow()
	expect(#pts).toBe(12)
	expect(comparePolygonsAsPoints(pts, exp)).toBe(true)
end)
test("extrudeFromSlices (torus)", function()
	local sqrt3 = math.sqrt(3) / 2
	local radius = 10
	local hex = poly3.create({
		{ radius, 0, 0 },
		{ radius / 2, radius * sqrt3, 0 },
		{ -radius / 2, radius * sqrt3, 0 },
		{ -radius, 0, 0 },
		{ -radius / 2, -radius * sqrt3, 0 },
		{ radius / 2, -radius * sqrt3, 0 },
	})
	hex = poly3.transform(mat4.fromTranslation(mat4.create(), { 0, 20, 0 }), hex)
	hex = slice.fromPoints(poly3.toPoints(hex))
	local angle = TAU / 8
	local geometry3 = extrudeFromSlices({
		numberOfSlices = TAU / angle,
		capStart = false,
		capEnd = false,
		close = true,
		callback = function(self, progress, index, base)
			return slice.transform(mat4.fromXRotation(mat4.create(), angle * index), base)
		end,
	}, hex)
	local pts = geom3.toPoints(geometry3)
	expect(function()
		return geom3.validate(geometry3)
	end)["not"].toThrow()
	expect(#pts).toBe(96)
end)
test("extrudeFromSlices (same shape, changing dimensions)", function()
	local base = slice.fromPoints({ { 0, 0, 0 }, { 1, 0, 0 }, { 1, 1, 0 }, { 0, 1, 0 } })
	local geometry3 = extrudeFromSlices({
		numberOfSlices = 4,
		capStart = true,
		capEnd = false,
		callback = function(self, progress, count, base)
			local newslice = slice.transform(mat4.fromTranslation(mat4.create(), { 0, 0, count * 2 }), base)
			newslice = slice.transform(mat4.fromScaling(mat4.create(), { 1 + count, 1 + count / 2, 1 }), newslice)
			return newslice
		end,
	}, base)
	local pts = geom3.toPoints(geometry3) -- expected to throw because capEnd is false (non-closed geometry)
	expect(function()
		return geom3.validate(geometry3)
	end).toThrow()
	expect(#pts).toBe(26)
end)
test("extrudeFromSlices (changing shape, changing dimensions)", function()
	local base = circle({ radius = 4, segments = 4 })
	local geometry3 = extrudeFromSlices({
		numberOfSlices = 5,
		callback = function(progress, count, base)
			local newshape = circle({ radius = 5 + count, segments = 4 + count })
			local newslice = slice.fromSides(geom2.toSides(newshape))
			newslice = slice.transform(mat4.fromTranslation(mat4.create(), { 0, 0, count * 10 }), newslice)
			return newslice
		end,
	}, base)
	local pts = geom3.toPoints(geometry3)
	t.notThrows:skip(function()
		return geom3.validate(geometry3)
	end)
	expect(#pts).toBe(304)
end)
test("extrudeFromSlices (holes)", function()
	local geometry2 = geom2.create({
		{ { -10, 10 }, { -10, -10 } },
		{ { -10, -10 }, { 10, -10 } },
		{ { 10, -10 }, { 10, 10 } },
		{ { 10, 10 }, { -10, 10 } },
		{ { -5, -5 }, { -5, 5 } },
		{ { 5, -5 }, { -5, -5 } },
		{ { 5, 5 }, { 5, -5 } },
		{ { -5, 5 }, { 5, 5 } },
	})
	local geometry3 = extrudeFromSlices({}, geometry2)
	local pts = geom3.toPoints(geometry3)
	local exp = {
		{ { -10, 10, 0 }, { -10, -10, 0 }, { -10, -10, 1 } },
		{ { -10, 10, 0 }, { -10, -10, 1 }, { -10, 10, 1 } },
		{ { -10, -10, 0 }, { 10, -10, 0 }, { 10, -10, 1 } },
		{ { -10, -10, 0 }, { 10, -10, 1 }, { -10, -10, 1 } },
		{ { 10, -10, 0 }, { 10, 10, 0 }, { 10, 10, 1 } },
		{ { 10, -10, 0 }, { 10, 10, 1 }, { 10, -10, 1 } },
		{ { 10, 10, 0 }, { -10, 10, 0 }, { -10, 10, 1 } },
		{ { 10, 10, 0 }, { -10, 10, 1 }, { 10, 10, 1 } },
		{ { -5, -5, 0 }, { -5, 5, 0 }, { -5, 5, 1 } },
		{ { -5, -5, 0 }, { -5, 5, 1 }, { -5, -5, 1 } },
		{ { 5, -5, 0 }, { -5, -5, 0 }, { -5, -5, 1 } },
		{ { 5, -5, 0 }, { -5, -5, 1 }, { 5, -5, 1 } },
		{ { 5, 5, 0 }, { 5, -5, 0 }, { 5, -5, 1 } },
		{ { 5, 5, 0 }, { 5, -5, 1 }, { 5, 5, 1 } },
		{ { -5, 5, 0 }, { 5, 5, 0 }, { 5, 5, 1 } },
		{ { -5, 5, 0 }, { 5, 5, 1 }, { -5, 5, 1 } },
		{ { 10, -10, 1 }, { 10, 10, 1 }, { 5, 5, 1 } },
		{ { -5, 5, 1 }, { 5, 5, 1 }, { 10, 10, 1 } },
		{ { 10, -10, 1 }, { 5, 5, 1 }, { 5, -5, 1 } },
		{ { -5, 5, 1 }, { 10, 10, 1 }, { -10, 10, 1 } },
		{ { -10, -10, 1 }, { 10, -10, 1 }, { 5, -5, 1 } },
		{ { -5, -5, 1 }, { -5, 5, 1 }, { -10, 10, 1 } },
		{ { -10, -10, 1 }, { 5, -5, 1 }, { -5, -5, 1 } },
		{ { -5, -5, 1 }, { -10, 10, 1 }, { -10, -10, 1 } },
		{ { 5, 5, 0 }, { 10, 10, 0 }, { 10, -10, 0 } },
		{ { 10, 10, 0 }, { 5, 5, 0 }, { -5, 5, 0 } },
		{ { 5, -5, 0 }, { 5, 5, 0 }, { 10, -10, 0 } },
		{ { -10, 10, 0 }, { 10, 10, 0 }, { -5, 5, 0 } },
		{ { 5, -5, 0 }, { 10, -10, 0 }, { -10, -10, 0 } },
		{ { -10, 10, 0 }, { -5, 5, 0 }, { -5, -5, 0 } },
		{ { -5, -5, 0 }, { 5, -5, 0 }, { -10, -10, 0 } },
		{ { -10, -10, 0 }, { -10, 10, 0 }, { -5, -5, 0 } },
	}
	expect(function()
		return geom3.validate(geometry3)
	end)["not"].toThrow()
	expect(#pts).toBe(32)
	expect(comparePolygonsAsPoints(pts, exp)).toBe(true)
end)
