-- ROBLOX NOTE: no upstream
local JestGlobals = require("@DevPackages/JestGlobals")
local test, expect = JestGlobals.test, JestGlobals.expect

local comparePoints, comparePolygonsAsPoints
do
	local ref = require("../../../test/helpers")
	comparePoints, comparePolygonsAsPoints = ref.comparePoints, ref.comparePolygonsAsPoints
end
local geom2, geom3, path2
do
	local ref = require("../../geometries")
	geom2, geom3, path2 = ref.geom2, ref.geom3, ref.path2
end
local translate, translateX, translateY, translateZ
do
	local ref = require("./init")
	translate, translateX, translateY, translateZ = ref.translate, ref.translateX, ref.translateY, ref.translateZ
end
test("translate: translating of a path2 produces expected changes to points", function()
	local line = path2.fromPoints({}, { { 0, 0 }, { 1, 0 } }) -- translate X
	local translated = translate({ 1 }, line)
	local obs = path2.toPoints(translated)
	local exp = { { 1, 0 }, { 2, 0 } }
	expect(function()
		return path2.validate(translated)
	end)["not"].toThrow()
	expect(comparePoints(obs, exp)).toBe(true)
	translated = translateX(1, line)
	obs = path2.toPoints(translated)
	expect(function()
		return path2.validate(translated)
	end)["not"].toThrow()
	expect(comparePoints(obs, exp)).toBe(true) -- translate Y
	translated = translate({ 0, 1 }, line)
	obs = path2.toPoints(translated)
	exp = { { 0, 1 }, { 1, 1 } }
	expect(function()
		return path2.validate(translated)
	end)["not"].toThrow()
	expect(comparePoints(obs, exp)).toBe(true)
	translated = translateY(1, line)
	obs = path2.toPoints(translated)
	expect(function()
		return path2.validate(translated)
	end)["not"].toThrow()
	expect(comparePoints(obs, exp)).toBe(true)
end)
test("translate: translating of a geom2 produces expected changes to points", function()
	local geometry = geom2.fromPoints({ { 0, 0 }, { 1, 0 }, { 0, 1 } }) -- translate X
	local translated = translate({ 1 }, geometry)
	local obs = geom2.toPoints(translated)
	local exp = { { 1, 0 }, { 2, 0 }, { 1, 1 } }
	expect(function()
		return geom2.validate(translated)
	end)["not"].toThrow()
	expect(comparePoints(obs, exp)).toBe(true)
	translated = translateX(1, geometry)
	obs = geom2.toPoints(translated)
	expect(function()
		return geom2.validate(translated)
	end)["not"].toThrow()
	expect(comparePoints(obs, exp)).toBe(true) -- translate Y
	translated = translate({ 0, 1 }, geometry)
	obs = geom2.toPoints(translated)
	exp = { { 0, 1 }, { 1, 1 }, { 0, 2 } }
	expect(function()
		return geom2.validate(translated)
	end)["not"].toThrow()
	expect(comparePoints(obs, exp)).toBe(true)
	translated = translateY(1, geometry)
	obs = geom2.toPoints(translated)
	expect(function()
		return geom2.validate(translated)
	end)["not"].toThrow()
	expect(comparePoints(obs, exp)).toBe(true)
end)
test("translate: translating of a geom3 produces expected changes to polygons", function()
	local points = {
		{ { -2, -7, -12 }, { -2, -7, 18 }, { -2, 13, 18 }, { -2, 13, -12 } },
		{ { 8, -7, -12 }, { 8, 13, -12 }, { 8, 13, 18 }, { 8, -7, 18 } },
		{ { -2, -7, -12 }, { 8, -7, -12 }, { 8, -7, 18 }, { -2, -7, 18 } },
		{ { -2, 13, -12 }, { -2, 13, 18 }, { 8, 13, 18 }, { 8, 13, -12 } },
		{ { -2, -7, -12 }, { -2, 13, -12 }, { 8, 13, -12 }, { 8, -7, -12 } },
		{ { -2, -7, 18 }, { 8, -7, 18 }, { 8, 13, 18 }, { -2, 13, 18 } },
	}
	local geometry = geom3.fromPoints(points) -- translate X
	local translated = translate({ 3 }, geometry)
	local obs = geom3.toPoints(translated)
	local exp = {
		{ { 1, -7, -12 }, { 1, -7, 18 }, { 1, 13, 18 }, { 1, 13, -12 } },
		{ { 11, -7, -12 }, { 11, 13, -12 }, { 11, 13, 18 }, { 11, -7, 18 } },
		{ { 1, -7, -12 }, { 11, -7, -12 }, { 11, -7, 18 }, { 1, -7, 18 } },
		{ { 1, 13, -12 }, { 1, 13, 18 }, { 11, 13, 18 }, { 11, 13, -12 } },
		{ { 1, -7, -12 }, { 1, 13, -12 }, { 11, 13, -12 }, { 11, -7, -12 } },
		{ { 1, -7, 18 }, { 11, -7, 18 }, { 11, 13, 18 }, { 1, 13, 18 } },
	}
	expect(function()
		return geom3.validate(translated)
	end)["not"].toThrow()
	expect(comparePolygonsAsPoints(obs, exp)).toBe(true)
	translated = translateX(3, geometry)
	obs = geom3.toPoints(translated)
	expect(function()
		return geom3.validate(translated)
	end)["not"].toThrow()
	expect(comparePolygonsAsPoints(obs, exp)).toBe(true) -- translated Y
	translated = translate({ 0, 3 }, geometry)
	obs = geom3.toPoints(translated)
	exp = {
		{ { -2, -4, -12 }, { -2, -4, 18 }, { -2, 16, 18 }, { -2, 16, -12 } },
		{ { 8, -4, -12 }, { 8, 16, -12 }, { 8, 16, 18 }, { 8, -4, 18 } },
		{ { -2, -4, -12 }, { 8, -4, -12 }, { 8, -4, 18 }, { -2, -4, 18 } },
		{ { -2, 16, -12 }, { -2, 16, 18 }, { 8, 16, 18 }, { 8, 16, -12 } },
		{ { -2, -4, -12 }, { -2, 16, -12 }, { 8, 16, -12 }, { 8, -4, -12 } },
		{ { -2, -4, 18 }, { 8, -4, 18 }, { 8, 16, 18 }, { -2, 16, 18 } },
	}
	expect(function()
		return geom3.validate(translated)
	end)["not"].toThrow()
	expect(comparePolygonsAsPoints(obs, exp)).toBe(true)
	translated = translateY(3, geometry)
	obs = geom3.toPoints(translated)
	expect(function()
		return geom3.validate(translated)
	end)["not"].toThrow()
	expect(comparePolygonsAsPoints(obs, exp)).toBe(true) -- translate Z
	translated = translate({ 0, 0, 3 }, geometry)
	obs = geom3.toPoints(translated)
	exp = {
		{ { -2, -7, -9 }, { -2, -7, 21 }, { -2, 13, 21 }, { -2, 13, -9 } },
		{ { 8, -7, -9 }, { 8, 13, -9 }, { 8, 13, 21 }, { 8, -7, 21 } },
		{ { -2, -7, -9 }, { 8, -7, -9 }, { 8, -7, 21 }, { -2, -7, 21 } },
		{ { -2, 13, -9 }, { -2, 13, 21 }, { 8, 13, 21 }, { 8, 13, -9 } },
		{ { -2, -7, -9 }, { -2, 13, -9 }, { 8, 13, -9 }, { 8, -7, -9 } },
		{ { -2, -7, 21 }, { 8, -7, 21 }, { 8, 13, 21 }, { -2, 13, 21 } },
	}
	expect(function()
		return geom3.validate(translated)
	end)["not"].toThrow()
	expect(comparePolygonsAsPoints(obs, exp)).toBe(true)
	translated = translateZ(3, geometry)
	obs = geom3.toPoints(translated)
	expect(function()
		return geom3.validate(translated)
	end)["not"].toThrow()
	expect(comparePolygonsAsPoints(obs, exp)).toBe(true)
end)
test("translate: translating of multiple objects produces expected changes", function()
	local junk = "hello"
	local geometry1 = path2.fromPoints({}, { { -5, 5 }, { 5, 5 }, { -5, -5 }, { 10, -5 } })
	local geometry2 = geom2.fromPoints({ { -5, -5 }, { 0, 5 }, { 10, -5 } })
	local translated = translate({ 3, 3, 3 }, junk, geometry1, geometry2)
	expect(translated[
		1 --[[ ROBLOX adaptation: added 1 to array index ]]
	]).toBe(junk)
	local obs = path2.toPoints(translated[
		2 --[[ ROBLOX adaptation: added 1 to array index ]]
	])
	local exp = { { -2, 8 }, { 8, 8 }, { -2, -2 }, { 13, -2 } }
	expect(function()
		return path2.validate(translated[
			2 --[[ ROBLOX adaptation: added 1 to array index ]]
		])
	end)["not"].toThrow()
	expect(comparePoints(obs, exp)).toBe(true)
	obs = geom2.toPoints(translated[
		3 --[[ ROBLOX adaptation: added 1 to array index ]]
	])
	exp = { { -2, -2 }, { 3, 8 }, { 13, -2 } }
	expect(function()
		return geom2.validate(translated[
			3 --[[ ROBLOX adaptation: added 1 to array index ]]
		])
	end)["not"].toThrow()
	expect(comparePoints(obs, exp)).toBe(true)
end)
