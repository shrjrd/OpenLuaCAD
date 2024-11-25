-- ROBLOX NOTE: no upstream
local JestGlobals = require("@DevPackages/JestGlobals")
local test, expect = JestGlobals.test, JestGlobals.expect

local triangle = require("./init").triangle
local degToRad = require("../utils/degToRad")
local geom2 = require("../geometries/geom2")
local TAU = require("../maths/constants").TAU
local comparePoints = require("../../test/helpers/comparePoints")
test("triangle (defaults)", function()
	local geometry = triangle()
	local obs = geom2.toPoints(geometry)
	local exp = { { 0, 0 }, { 1, 0 }, { 0.5000000000000002, 0.8660254037844387 } }
	expect(function()
		return geom2.validate(geometry)
	end).never.toThrow()
	expect(#obs).toEqual(3)
	expect(comparePoints(obs, exp)).toBe(true)
end)
test("triangle (options)", function()
	-- test SSS
	local geometry = triangle({ type = "SSS", values = { 7, 8, 6 } })
	local obs = geom2.toPoints(geometry)
	local exp = { { 0, 0 }, { 7, 0 }, { 1.5, 5.809475019311125 } }
	expect(function()
		return geom2.validate(geometry)
	end).never.toThrow()
	expect(#obs).toEqual(3)
	expect(comparePoints(obs, exp)).toBe(true) -- test AAA
	geometry = triangle({ type = "AAA", values = { TAU / 4, TAU / 8, TAU / 8 } })
	obs = geom2.toPoints(geometry)
	exp = { { 0, 0 }, { 1, 0 }, { 0, 1.0000000000000002 } }
	expect(function()
		return geom2.validate(geometry)
	end).never.toThrow()
	expect(#obs).toEqual(3)
	expect(comparePoints(obs, exp)).toBe(true) -- test AAS
	geometry = triangle({ type = "AAS", values = { degToRad(62), degToRad(35), 7 } })
	obs = geom2.toPoints(geometry)
	exp = { { 0, 0 }, { 7.86889631692936, 0 }, { 2.1348320069064197, 4.015035054457325 } }
	expect(function()
		return geom2.validate(geometry)
	end).never.toThrow()
	expect(#obs).toEqual(3)
	expect(comparePoints(obs, exp)).toBe(true) -- test ASA
	geometry = triangle({ type = "ASA", values = { degToRad(76), 9, degToRad(34) } })
	obs = geom2.toPoints(geometry)
	exp = { { 0, 0 }, { 9, 0 }, { 1.295667368233083, 5.196637976713814 } }
	expect(function()
		return geom2.validate(geometry)
	end).never.toThrow()
	expect(#obs).toEqual(3)
	expect(comparePoints(obs, exp)).toBe(true) -- test SAS
	geometry = triangle({ type = "SAS", values = { 5, degToRad(49), 7 } })
	obs = geom2.toPoints(geometry)
	exp = { { 0, 0 }, { 5, 0 }, { 0.4075867970664495, 5.282967061559405 } }
	expect(function()
		return geom2.validate(geometry)
	end).never.toThrow()
	expect(#obs).toEqual(3)
	expect(comparePoints(obs, exp)).toBe(true) -- test SSA
	geometry = triangle({ type = "SSA", values = { 8, 13, degToRad(31) } })
	obs = geom2.toPoints(geometry)
	exp = { { 0, 0 }, { 8, 0 }, { 8.494946725906148, 12.990574573070846 } }
	expect(function()
		return geom2.validate(geometry)
	end).never.toThrow()
	expect(#obs).toEqual(3)
	expect(comparePoints(obs, exp)).toBe(true)
end)
