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
local scale, scaleX, scaleY, scaleZ
do
	local ref = require("./init")
	scale, scaleX, scaleY, scaleZ = ref.scale, ref.scaleX, ref.scaleY, ref.scaleZ
end
test("scale: scaling of a path2 produces expected changes to points", function()
	local geometry = path2.fromPoints({}, { { 0, 4 }, { 1, 0 } }) -- scale X
	local scaled = scale({ 3 }, geometry)
	local obs = path2.toPoints(scaled)
	local exp = { { 0, 4 }, { 3, 0 } }
	expect(function()
		return path2.validate(scaled)
	end)["not"].toThrow()
	expect(comparePoints(obs, exp)).toBe(true)
	scaled = scaleX(3, geometry)
	obs = path2.toPoints(scaled)
	expect(function()
		return path2.validate(scaled)
	end)["not"].toThrow()
	expect(comparePoints(obs, exp)).toBe(true) -- scale Y
	scaled = scale({ 1, 0.5 }, geometry)
	obs = path2.toPoints(scaled)
	exp = { { 0, 2 }, { 1, 0 } }
	expect(function()
		return path2.validate(scaled)
	end)["not"].toThrow()
	expect(comparePoints(obs, exp)).toBe(true)
	scaled = scaleY(0.5, geometry)
	obs = path2.toPoints(scaled)
	expect(function()
		return path2.validate(scaled)
	end)["not"].toThrow()
	expect(comparePoints(obs, exp)).toBe(true)
end)
test("scale: scaling of a geom2 produces expected changes to points", function()
	local geometry = geom2.fromPoints({ { -1, 0 }, { 1, 0 }, { 0, 1 } }) -- scale X
	local scaled = scale({ 3 }, geometry)
	local obs = geom2.toPoints(scaled)
	local exp = { { -3, 0 }, { 3, 0 }, { 0, 1 } }
	expect(function()
		return geom2.validate(scaled)
	end)["not"].toThrow()
	expect(comparePoints(obs, exp)).toBe(true)
	scaled = scaleX(3, geometry)
	obs = geom2.toPoints(scaled)
	expect(function()
		return geom2.validate(scaled)
	end)["not"].toThrow()
	expect(comparePoints(obs, exp)).toBe(true) -- scale Y
	scaled = scale({ 1, 3 }, geometry)
	obs = geom2.toPoints(scaled)
	exp = { { -1, 0 }, { 1, 0 }, { 0, 3 } }
	expect(function()
		return geom2.validate(scaled)
	end)["not"].toThrow()
	expect(comparePoints(obs, exp)).toBe(true)
	scaled = scaleY(3, geometry)
	obs = geom2.toPoints(scaled)
	expect(function()
		return geom2.validate(scaled)
	end)["not"].toThrow()
	expect(comparePoints(obs, exp)).toBe(true)
end)
test("scale: scaling of a geom3 produces expected changes to polygons", function()
	local points = {
		{ { -2, -7, -12 }, { -2, -7, 18 }, { -2, 13, 18 }, { -2, 13, -12 } },
		{ { 8, -7, -12 }, { 8, 13, -12 }, { 8, 13, 18 }, { 8, -7, 18 } },
		{ { -2, -7, -12 }, { 8, -7, -12 }, { 8, -7, 18 }, { -2, -7, 18 } },
		{ { -2, 13, -12 }, { -2, 13, 18 }, { 8, 13, 18 }, { 8, 13, -12 } },
		{ { -2, -7, -12 }, { -2, 13, -12 }, { 8, 13, -12 }, { 8, -7, -12 } },
		{ { -2, -7, 18 }, { 8, -7, 18 }, { 8, 13, 18 }, { -2, 13, 18 } },
	}
	local geometry = geom3.fromPoints(points) -- scale X
	local scaled = scale({ 3 }, geometry)
	local obs = geom3.toPoints(scaled)
	local exp = {
		{ { -6, -7, -12 }, { -6, -7, 18 }, { -6, 13, 18 }, { -6, 13, -12 } },
		{ { 24, -7, -12 }, { 24, 13, -12 }, { 24, 13, 18 }, { 24, -7, 18 } },
		{ { -6, -7, -12 }, { 24, -7, -12 }, { 24, -7, 18 }, { -6, -7, 18 } },
		{ { -6, 13, -12 }, { -6, 13, 18 }, { 24, 13, 18 }, { 24, 13, -12 } },
		{ { -6, -7, -12 }, { -6, 13, -12 }, { 24, 13, -12 }, { 24, -7, -12 } },
		{ { -6, -7, 18 }, { 24, -7, 18 }, { 24, 13, 18 }, { -6, 13, 18 } },
	}
	expect(function()
		return geom3.validate(scaled)
	end)["not"].toThrow()
	expect(comparePolygonsAsPoints(obs, exp)).toBe(true)
	scaled = scaleX(3, geometry)
	obs = geom3.toPoints(scaled)
	expect(function()
		return geom3.validate(scaled)
	end)["not"].toThrow()
	expect(comparePolygonsAsPoints(obs, exp)).toBe(true) -- scale Y
	scaled = scale({ 1, 0.5 }, geometry)
	obs = geom3.toPoints(scaled)
	exp = {
		{ { -2, -3.5, -12 }, { -2, -3.5, 18 }, { -2, 6.5, 18 }, { -2, 6.5, -12 } },
		{ { 8, -3.5, -12 }, { 8, 6.5, -12 }, { 8, 6.5, 18 }, { 8, -3.5, 18 } },
		{ { -2, -3.5, -12 }, { 8, -3.5, -12 }, { 8, -3.5, 18 }, { -2, -3.5, 18 } },
		{ { -2, 6.5, -12 }, { -2, 6.5, 18 }, { 8, 6.5, 18 }, { 8, 6.5, -12 } },
		{ { -2, -3.5, -12 }, { -2, 6.5, -12 }, { 8, 6.5, -12 }, { 8, -3.5, -12 } },
		{ { -2, -3.5, 18 }, { 8, -3.5, 18 }, { 8, 6.5, 18 }, { -2, 6.5, 18 } },
	}
	expect(comparePolygonsAsPoints(obs, exp)).toBe(true)
	scaled = scaleY(0.5, geometry)
	obs = geom3.toPoints(scaled)
	expect(function()
		return geom3.validate(scaled)
	end)["not"].toThrow()
	expect(comparePolygonsAsPoints(obs, exp)).toBe(true) -- scale Z
	scaled = scale({ 1, 1, 5 }, geometry)
	obs = geom3.toPoints(scaled)
	exp = {
		{ { -2, -7, -60 }, { -2, -7, 90 }, { -2, 13, 90 }, { -2, 13, -60 } },
		{ { 8, -7, -60 }, { 8, 13, -60 }, { 8, 13, 90 }, { 8, -7, 90 } },
		{ { -2, -7, -60 }, { 8, -7, -60 }, { 8, -7, 90 }, { -2, -7, 90 } },
		{ { -2, 13, -60 }, { -2, 13, 90 }, { 8, 13, 90 }, { 8, 13, -60 } },
		{ { -2, -7, -60 }, { -2, 13, -60 }, { 8, 13, -60 }, { 8, -7, -60 } },
		{ { -2, -7, 90 }, { 8, -7, 90 }, { 8, 13, 90 }, { -2, 13, 90 } },
	}
	expect(function()
		return geom3.validate(scaled)
	end)["not"].toThrow()
	expect(comparePolygonsAsPoints(obs, exp)).toBe(true)
	scaled = scaleZ(5, geometry)
	obs = geom3.toPoints(scaled)
	expect(function()
		return geom3.validate(scaled)
	end)["not"].toThrow()
	expect(comparePolygonsAsPoints(obs, exp)).toBe(true)
end)
test("scale: scaling of multiple objects produces expected changes", function()
	local junk = "hello"
	local geometry1 = path2.fromPoints({}, { { -5, 5 }, { 5, 5 }, { -5, -5 }, { 10, -5 } })
	local geometry2 = geom2.fromPoints({ { -5, -5 }, { 0, 5 }, { 10, -5 } })
	local scaled = scale({ 3, 1, 1 }, junk, geometry1, geometry2)
	expect(scaled[
		1 --[[ ROBLOX adaptation: added 1 to array index ]]
	]).toBe(junk)
	local obs1 = path2.toPoints(scaled[
		2 --[[ ROBLOX adaptation: added 1 to array index ]]
	])
	local exp1 = { { -15, 5 }, { 15, 5 }, { -15, -5 }, { 30, -5 } }
	expect(function()
		return path2.validate(scaled[
			2 --[[ ROBLOX adaptation: added 1 to array index ]]
		])
	end)["not"].toThrow()
	expect(comparePoints(obs1, exp1)).toBe(true)
	local obs2 = geom2.toPoints(scaled[
		3 --[[ ROBLOX adaptation: added 1 to array index ]]
	])
	local exp2 = { { -15, -5 }, { 0, 5 }, { 30, -5 } }
	expect(function()
		return geom2.validate(scaled[
			3 --[[ ROBLOX adaptation: added 1 to array index ]]
		])
	end)["not"].toThrow()
	expect(comparePoints(obs2, exp2)).toBe(true)
end)
