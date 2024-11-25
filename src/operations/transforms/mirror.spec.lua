-- ROBLOX NOTE: no upstream
local JestGlobals = require("@DevPackages/JestGlobals")
local test, expect = JestGlobals.test, JestGlobals.expect

local comparePoints, comparePolygonsAsPoints
do
	local ref = require("../../../test/helpers")
	comparePoints, comparePolygonsAsPoints = ref.comparePoints, ref.comparePolygonsAsPoints
end
local measureArea = require("../../measurements").measureArea
local geom2, geom3, path2
do
	local ref = require("../../geometries")
	geom2, geom3, path2 = ref.geom2, ref.geom3, ref.path2
end
local mirror, mirrorX, mirrorY, mirrorZ
do
	local ref = require("./init")
	mirror, mirrorX, mirrorY, mirrorZ = ref.mirror, ref.mirrorX, ref.mirrorY, ref.mirrorZ
end
test("mirror: mirroring of path2 about X/Y produces expected changes to points", function()
	local geometry = path2.fromPoints({}, { { -5, 5 }, { 5, 5 }, { -5, -5 }, { 10, -5 } }) -- mirror about X
	local mirrored = mirror({ normal = { 1, 0, 0 } }, geometry)
	local obs = path2.toPoints(mirrored)
	local exp = { { 5, 5 }, { -5, 5 }, { 5, -5 }, { -10, -5 } }
	expect(function()
		return path2.validate(mirrored)
	end).never.toThrow()
	expect(comparePoints(obs, exp)).toBe(true)
	mirrored = mirrorX(geometry)
	obs = path2.toPoints(mirrored)
	expect(function()
		return path2.validate(mirrored)
	end).never.toThrow()
	expect(comparePoints(obs, exp)).toBe(true) -- mirror about Y
	mirrored = mirror({ normal = { 0, 1, 0 } }, geometry)
	obs = path2.toPoints(mirrored)
	exp = { { -5, -5 }, { 5, -5 }, { -5, 5 }, { 10, 5 } }
	expect(function()
		return path2.validate(mirrored)
	end).never.toThrow()
	expect(comparePoints(obs, exp)).toBe(true)
	mirrored = mirrorY(geometry)
	obs = path2.toPoints(mirrored)
	expect(function()
		return path2.validate(mirrored)
	end).never.toThrow()
	expect(comparePoints(obs, exp)).toBe(true)
end)
test("mirror: mirroring of geom2 about X/Y produces expected changes to points", function()
	local geometry = geom2.fromPoints({ { -5, -5 }, { 0, 5 }, { 10, -5 } }) -- mirror about X
	local mirrored = mirror({ normal = { 1, 0, 0 } }, geometry)
	local obs = geom2.toPoints(mirrored)
	local exp = { { 0, 5 }, { 5, -5 }, { -10, -5 } }
	expect(function()
		return geom2.validate(mirrored)
	end).never.toThrow()
	expect(measureArea(mirrored)).toBe(measureArea(geometry))
	expect(comparePoints(obs, exp)).toBe(true)
	mirrored = mirrorX(geometry)
	obs = geom2.toPoints(mirrored)
	expect(function()
		return geom2.validate(mirrored)
	end).never.toThrow()
	expect(measureArea(mirrored)).toBe(measureArea(geometry))
	expect(comparePoints(obs, exp)).toBe(true) -- mirror about Y
	mirrored = mirror({ normal = { 0, 1, 0 } }, geometry)
	obs = geom2.toPoints(mirrored)
	exp = { { 0, -5 }, { -5, 5 }, { 10, 5 } }
	expect(function()
		return geom2.validate(mirrored)
	end).never.toThrow()
	expect(measureArea(mirrored)).toBe(measureArea(geometry))
	expect(comparePoints(obs, exp)).toBe(true)
	mirrored = mirrorY(geometry)
	obs = geom2.toPoints(mirrored)
	expect(function()
		return geom2.validate(mirrored)
	end).never.toThrow()
	expect(measureArea(mirrored)).toBe(measureArea(geometry))
	expect(comparePoints(obs, exp)).toBe(true)
end)
test("mirror: mirroring of geom3 about X/Y/Z produces expected changes to polygons", function()
	local points = {
		{ { -2, -7, -12 }, { -2, -7, 18 }, { -2, 13, 18 }, { -2, 13, -12 } },
		{ { 8, -7, -12 }, { 8, 13, -12 }, { 8, 13, 18 }, { 8, -7, 18 } },
		{ { -2, -7, -12 }, { 8, -7, -12 }, { 8, -7, 18 }, { -2, -7, 18 } },
		{ { -2, 13, -12 }, { -2, 13, 18 }, { 8, 13, 18 }, { 8, 13, -12 } },
		{ { -2, -7, -12 }, { -2, 13, -12 }, { 8, 13, -12 }, { 8, -7, -12 } },
		{ { -2, -7, 18 }, { 8, -7, 18 }, { 8, 13, 18 }, { -2, 13, 18 } },
	}
	local geometry = geom3.fromPoints(points) -- mirror about X
	local mirrored = mirror({ normal = { 1, 0, 0 } }, geometry)
	local obs = geom3.toPoints(mirrored)
	local exp = {
		{ { 2, 13, -12 }, { 2, 13, 18 }, { 2, -7, 18 }, { 2, -7, -12 } },
		{ { -8, -7, 18 }, { -8, 13, 18 }, { -8, 13, -12 }, { -8, -7, -12 } },
		{ { 2, -7, 18 }, { -8, -7, 18 }, { -8, -7, -12 }, { 2, -7, -12 } },
		{ { -8, 13, -12 }, { -8, 13, 18 }, { 2, 13, 18 }, { 2, 13, -12 } },
		{ { -8, -7, -12 }, { -8, 13, -12 }, { 2, 13, -12 }, { 2, -7, -12 } },
		{ { 2, 13, 18 }, { -8, 13, 18 }, { -8, -7, 18 }, { 2, -7, 18 } },
	}
	expect(function()
		return geom3.validate(mirrored)
	end).never.toThrow()
	expect(comparePolygonsAsPoints(obs, exp)).toBe(true)
	expect(obs).toEqual(exp)
	mirrored = mirrorX(geometry)
	obs = geom3.toPoints(mirrored)
	expect(function()
		return geom3.validate(mirrored)
	end).never.toThrow()
	expect(comparePolygonsAsPoints(obs, exp)).toBe(true) -- mirror about Y
	mirrored = mirror({ normal = { 0, 1, 0 } }, geometry)
	obs = geom3.toPoints(mirrored)
	exp = {
		{ { -2, -13, -12 }, { -2, -13, 18 }, { -2, 7, 18 }, { -2, 7, -12 } },
		{ { 8, 7, 18 }, { 8, -13, 18 }, { 8, -13, -12 }, { 8, 7, -12 } },
		{ { -2, 7, 18 }, { 8, 7, 18 }, { 8, 7, -12 }, { -2, 7, -12 } },
		{ { 8, -13, -12 }, { 8, -13, 18 }, { -2, -13, 18 }, { -2, -13, -12 } },
		{ { 8, 7, -12 }, { 8, -13, -12 }, { -2, -13, -12 }, { -2, 7, -12 } },
		{ { -2, -13, 18 }, { 8, -13, 18 }, { 8, 7, 18 }, { -2, 7, 18 } },
	}
	expect(function()
		return geom3.validate(mirrored)
	end).never.toThrow()
	expect(comparePolygonsAsPoints(obs, exp)).toBe(true)
	mirrored = mirrorY(geometry)
	obs = geom3.toPoints(mirrored)
	expect(function()
		return geom3.validate(mirrored)
	end).never.toThrow()
	expect(comparePolygonsAsPoints(obs, exp)).toBe(true) -- mirror about Z
	mirrored = mirror({ normal = { 0, 0, 1 } }, geometry)
	obs = geom3.toPoints(mirrored)
	exp = {
		{ { -2, 13, 12 }, { -2, 13, -18 }, { -2, -7, -18 }, { -2, -7, 12 } },
		{ { 8, -7, -18 }, { 8, 13, -18 }, { 8, 13, 12 }, { 8, -7, 12 } },
		{ { -2, -7, -18 }, { 8, -7, -18 }, { 8, -7, 12 }, { -2, -7, 12 } },
		{ { 8, 13, 12 }, { 8, 13, -18 }, { -2, 13, -18 }, { -2, 13, 12 } },
		{ { 8, -7, 12 }, { 8, 13, 12 }, { -2, 13, 12 }, { -2, -7, 12 } },
		{ { -2, 13, -18 }, { 8, 13, -18 }, { 8, -7, -18 }, { -2, -7, -18 } },
	}
	expect(function()
		return geom3.validate(mirrored)
	end).never.toThrow()
	expect(comparePolygonsAsPoints(obs, exp)).toBe(true)
	mirrored = mirrorZ(geometry)
	obs = geom3.toPoints(mirrored)
	expect(function()
		return geom3.validate(mirrored)
	end).never.toThrow()
	expect(comparePolygonsAsPoints(obs, exp)).toBe(true)
end)
test("mirror: mirroring of multiple objects produces an array of mirrored objects", function()
	local junk = "hello"
	local geometry1 = path2.fromPoints({}, { { -5, 5 }, { 5, 5 }, { -5, -5 }, { 10, -5 } })
	local geometry2 = geom2.fromPoints({ { -5, -5 }, { 0, 5 }, { 10, -5 } })
	local mirrored = mirror({ normal = { 0, 1, 0 } }, junk, geometry1, geometry2)
	expect(mirrored[
		1 --[[ ROBLOX adaptation: added 1 to array index ]]
	]).toBe(junk)
	local obs = path2.toPoints(mirrored[
		2 --[[ ROBLOX adaptation: added 1 to array index ]]
	])
	local exp = { { -5, -5 }, { 5, -5 }, { -5, 5 }, { 10, 5 } }
	expect(function()
		return path2.validate(mirrored[
			2 --[[ ROBLOX adaptation: added 1 to array index ]]
		])
	end).never.toThrow()
	expect(comparePoints(obs, exp)).toBe(true)
	obs = geom2.toPoints(mirrored[
		3 --[[ ROBLOX adaptation: added 1 to array index ]]
	])
	exp = { { 0, -5 }, { -5, 5 }, { 10, 5 } }
	expect(function()
		return geom2.validate(mirrored[
			3 --[[ ROBLOX adaptation: added 1 to array index ]]
		])
	end).never.toThrow()
	expect(comparePoints(obs, exp)).toBe(true)
end)
