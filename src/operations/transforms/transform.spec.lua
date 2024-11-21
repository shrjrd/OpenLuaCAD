-- ROBLOX NOTE: no upstream
local JestGlobals = require("@DevPackages/JestGlobals")
local test, expect = JestGlobals.test, JestGlobals.expect

local comparePoints, comparePolygonsAsPoints
do
	local ref = require("../../../test/helpers")
	comparePoints, comparePolygonsAsPoints = ref.comparePoints, ref.comparePolygonsAsPoints
end
local mat4 = require("../../maths/mat4")
local geom2, geom3, path2
do
	local ref = require("../../geometries")
	geom2, geom3, path2 = ref.geom2, ref.geom3, ref.path2
end
local transform = require("./init").transform
test("transform: transforming of a path2 produces expected changes to points", function()
	local matrix = mat4.fromTranslation(mat4.create(), { 2, 2, 0 })
	local geometry = path2.fromPoints({}, { { 0, 0 }, { 1, 0 } })
	geometry = transform(matrix, geometry)
	local obs = path2.toPoints(geometry)
	local exp = { { 2, 2 }, { 3, 2 } }
	expect(function()
		return path2.validate(geometry)
	end)["not"].toThrow()
	expect(comparePoints(obs, exp)).toBe(true)
end)
test("transform: transforming of a geom2 produces expected changes to sides", function()
	local matrix = mat4.fromScaling(mat4.create(), { 5, 5, 5 })
	local geometry = geom2.fromPoints({ { 0, 0 }, { 1, 0 }, { 0, 1 } })
	geometry = transform(matrix, geometry)
	local obs = geom2.toPoints(geometry)
	local exp = { { 0, 0 }, { 5, 0 }, { 0, 5 } }
	expect(function()
		return geom2.validate(geometry)
	end)["not"].toThrow()
	expect(comparePoints(obs, exp)).toBe(true)
end)
test("transform: transforming of a geom3 produces expected changes to polygons", function()
	local matrix = mat4.fromTranslation(mat4.create(), { -3, -3, -3 })
	local points = {
		{ { -2, -7, -12 }, { -2, -7, 18 }, { -2, 13, 18 }, { -2, 13, -12 } },
		{ { 8, -7, -12 }, { 8, 13, -12 }, { 8, 13, 18 }, { 8, -7, 18 } },
		{ { -2, -7, -12 }, { 8, -7, -12 }, { 8, -7, 18 }, { -2, -7, 18 } },
		{ { -2, 13, -12 }, { -2, 13, 18 }, { 8, 13, 18 }, { 8, 13, -12 } },
		{ { -2, -7, -12 }, { -2, 13, -12 }, { 8, 13, -12 }, { 8, -7, -12 } },
		{ { -2, -7, 18 }, { 8, -7, 18 }, { 8, 13, 18 }, { -2, 13, 18 } },
	}
	local geometry = geom3.fromPoints(points)
	geometry = transform(matrix, geometry)
	local obs = geom3.toPoints(geometry)
	local exp = {
		{ { -5, -10, -15 }, { -5, -10, 15 }, { -5, 10, 15 }, { -5, 10, -15 } },
		{ { 5, -10, -15 }, { 5, 10, -15 }, { 5, 10, 15 }, { 5, -10, 15 } },
		{ { -5, -10, -15 }, { 5, -10, -15 }, { 5, -10, 15 }, { -5, -10, 15 } },
		{ { -5, 10, -15 }, { -5, 10, 15 }, { 5, 10, 15 }, { 5, 10, -15 } },
		{ { -5, -10, -15 }, { -5, 10, -15 }, { 5, 10, -15 }, { 5, -10, -15 } },
		{ { -5, -10, 15 }, { 5, -10, 15 }, { 5, 10, 15 }, { -5, 10, 15 } },
	}
	expect(function()
		return geom3.validate(geometry)
	end)["not"].toThrow()
	expect(comparePolygonsAsPoints(obs, exp)).toBe(true)
end)
test("transform: transforming of multiple objects produces expected changes", function()
	local junk = "hello"
	local geometry1 = path2.fromPoints({}, { { -5, 5 }, { 5, 5 }, { -5, -5 }, { 10, -5 } })
	local geometry2 = geom2.fromPoints({ { -5, -5 }, { 0, 5 }, { 10, -5 } })
	local matrix = mat4.fromTranslation(mat4.create(), { 2, 2, 0 })
	local transformed = transform(matrix, junk, geometry1, geometry2)
	expect(transformed[
		1 --[[ ROBLOX adaptation: added 1 to array index ]]
	]).toBe(junk)
	local obs = path2.toPoints(transformed[
		2 --[[ ROBLOX adaptation: added 1 to array index ]]
	])
	local exp = { { -3, 7 }, { 7, 7 }, { -3, -3 }, { 12, -3 } }
	expect(function()
		return path2.validate(transformed[
			2 --[[ ROBLOX adaptation: added 1 to array index ]]
		])
	end)["not"].toThrow()
	expect(comparePoints(obs, exp)).toBe(true)
	obs = geom2.toPoints(transformed[
		3 --[[ ROBLOX adaptation: added 1 to array index ]]
	])
	exp = { { -3, -3 }, { 2, 7 }, { 12, -3 } }
	expect(function()
		return geom2.validate(transformed[
			3 --[[ ROBLOX adaptation: added 1 to array index ]]
		])
	end)["not"].toThrow()
	expect(comparePoints(obs, exp)).toBe(true)
end)
