-- ROBLOX NOTE: no upstream
local Packages = game.ReplicatedStorage.Packages
local LuauPolyfill = require(Packages.LuauPolyfill)
local Array = LuauPolyfill.Array
local JestGlobals = require("@DevPackages/JestGlobals")
local test, expect = JestGlobals.test, JestGlobals.expect

local geom3 = require("../../geometries").geom3
local retessellate = require("./retessellate")
local comparePolygonsAsPoints = require("../../../test/helpers").comparePolygonsAsPoints
test("geom3. retessellate() should create proper geometry from empty geometries", function()
	local obj1 = geom3.create() -- one empty geometry
	local ret1 = retessellate(obj1)
	local exp1 = {
		polygons = {},
		isRetesselated = true,
		transforms = { 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1 },
	}
	expect(ret1).toEqual(exp1)
end)
test("geom3. retessellate() should create proper geometry from solid geometries", function()
	local box1 = {
		{ { -5.0, -5.0, -5.0 }, { -5.0, -5.0, 5.0 }, { -5.0, 5.0, 5.0 }, { -5.0, 5.0, -5.0 } },
		{ { 5.0, -5.0, -5.0 }, { 5.0, 5.0, -5.0 }, { 5.0, 5.0, 5.0 }, { 5.0, -5.0, 5.0 } },
		{ { -5.0, -5.0, -5.0 }, { 5.0, -5.0, -5.0 }, { 5.0, -5.0, 5.0 }, { -5.0, -5.0, 5.0 } },
		{ { -5.0, 5.0, -5.0 }, { -5.0, 5.0, 5.0 }, { 5.0, 5.0, 5.0 }, { 5.0, 5.0, -5.0 } },
		{ { -5.0, -5.0, -5.0 }, { -5.0, 5.0, -5.0 }, { 5.0, 5.0, -5.0 }, { 5.0, -5.0, -5.0 } },
		{ { -5.0, -5.0, 5.0 }, { 5.0, -5.0, 5.0 }, { 5.0, 5.0, 5.0 }, { -5.0, 5.0, 5.0 } },
	}
	local box2 = {
		{ { 15.0, 15.0, 15.0 }, { 15.0, 15.0, 25.0 }, { 15.0, 25.0, 25.0 }, { 15.0, 25.0, 15.0 } },
		{ { 25.0, 15.0, 15.0 }, { 25.0, 25.0, 15.0 }, { 25.0, 25.0, 25.0 }, { 25.0, 15.0, 25.0 } },
		{ { 15.0, 15.0, 15.0 }, { 25.0, 15.0, 15.0 }, { 25.0, 15.0, 25.0 }, { 15.0, 15.0, 25.0 } },
		{ { 15.0, 25.0, 15.0 }, { 15.0, 25.0, 25.0 }, { 25.0, 25.0, 25.0 }, { 25.0, 25.0, 15.0 } },
		{ { 15.0, 15.0, 15.0 }, { 15.0, 25.0, 15.0 }, { 25.0, 25.0, 15.0 }, { 25.0, 15.0, 15.0 } },
		{ { 15.0, 15.0, 25.0 }, { 25.0, 15.0, 25.0 }, { 25.0, 25.0, 25.0 }, { 15.0, 25.0, 25.0 } },
	}
	local box3 = {
		{ { -5.0, -5.0, -5.0 }, { -5.0, -5.0, 5.0 }, { -5.0, 5.0, 5.0 }, { -5.0, 5.0, -5.0 } },
		{ { 5.0, -5.0, -5.0 }, { 5.0, 5.0, -5.0 }, { 5.0, 5.0, 5.0 }, { 5.0, -5.0, 5.0 } },
		{ { -5.0, -5.0, -5.0 }, { 5.0, -5.0, -5.0 }, { 5.0, -5.0, 5.0 }, { -5.0, -5.0, 5.0 } },
		{ { -5.0, 5.0, -5.0 }, { -5.0, 5.0, 5.0 }, { 5.0, 5.0, 5.0 }, { 5.0, 5.0, -5.0 } },
		{ { -5.0, -5.0, -5.0 }, { -5.0, 5.0, -5.0 }, { 5.0, 5.0, -5.0 }, { 5.0, -5.0, -5.0 } },
		{ { -5.0, -5.0, 5.0 }, { -5.0, -5.0, 15.0 }, { -5.0, 5.0, 15.0 }, { -5.0, 5.0, 5.0 } },
		{ { 5.0, -5.0, 5.0 }, { 5.0, 5.0, 5.0 }, { 5.0, 5.0, 15.0 }, { 5.0, -5.0, 15.0 } },
		{ { -5.0, -5.0, 5.0 }, { 5.0, -5.0, 5.0 }, { 5.0, -5.0, 15.0 }, { -5.0, -5.0, 15.0 } },
		{ { -5.0, 5.0, 5.0 }, { -5.0, 5.0, 15.0 }, { 5.0, 5.0, 15.0 }, { 5.0, 5.0, 5.0 } },
		{ { -5.0, -5.0, 15.0 }, { 5.0, -5.0, 15.0 }, { 5.0, 5.0, 15.0 }, { -5.0, 5.0, 15.0 } },
	}
	local box4 = {
		{ { -5.0, -5.0, -5.0 }, { -5.0, -5.0, 5.0 }, { -5.0, 5.0, 5.0 }, { -5.0, 5.0, -5.0 } },
		{ { -5.0, -5.0, -5.0 }, { 5.0, -5.0, -5.0 }, { 5.0, -5.0, 5.0 }, { -5.0, -5.0, 5.0 } },
		{ { -5.0, -5.0, -5.0 }, { -5.0, 5.0, -5.0 }, { 5.0, 5.0, -5.0 }, { 5.0, -5.0, -5.0 } },
		{ { 5.0, -5.0, -5.0 }, { 5.0, 0.0, -5.0 }, { 5.0, 0.0, 5.0 }, { 5.0, -5.0, 5.0 } },
		{ { -5.0, 5.0, -5.0 }, { -5.0, 5.0, 5.0 }, { 0.0, 5.0, 5.0 }, { 0.0, 5.0, -5.0 } },
		{ { -5.0, -5.0, 5.0 }, { 0.0, -5.0, 5.0 }, { 0.0, 5.0, 5.0 }, { -5.0, 5.0, 5.0 } },
		{ { 5.0, 0.0, -5.0 }, { 5.0, 5.0, -5.0 }, { 5.0, 5.0, 0.0 }, { 5.0, 0.0, 0.0 } },
		{ { 5.0, 5.0, 0.0 }, { 5.0, 5.0, -5.0 }, { 0.0, 5.0, -5.0 }, { 0.0, 5.0, 0.0 } },
		{ { 0.0, -5.0, 5.0 }, { 5.0, -5.0, 5.0 }, { 5.0, 0.0, 5.0 }, { 0.0, 0.0, 5.0 } },
		{ { 10.0, 0.0, 0.0 }, { 10.0, 10.0, 0.0 }, { 10.0, 10.0, 10.0 }, { 10.0, 0.0, 10.0 } },
		{ { 0.0, 10.0, 0.0 }, { 0.0, 10.0, 10.0 }, { 10.0, 10.0, 10.0 }, { 10.0, 10.0, 0.0 } },
		{ { 0.0, 0.0, 10.0 }, { 10.0, 0.0, 10.0 }, { 10.0, 10.0, 10.0 }, { 0.0, 10.0, 10.0 } },
		{ { 0.0, 5.0, 10.0 }, { 0.0, 10.0, 10.0 }, { 0.0, 10.0, 0.0 }, { 0.0, 5.0, 0.0 } },
		{ { 5.0, 0.0, 0.0 }, { 10.0, 0.0, 0.0 }, { 10.0, 0.0, 10.0 }, { 5.0, 0.0, 10.0 } },
		{ { 5.0, 10.0, 0.0 }, { 10.0, 10.0, 0.0 }, { 10.0, 0.0, 0.0 }, { 5.0, 0.0, 0.0 } },
		{ { 0.0, 0.0, 5.0 }, { 0.0, 0.0, 10.0 }, { 0.0, 5.0, 10.0 }, { 0.0, 5.0, 5.0 } },
		{ { 5.0, 0.0, 5.0 }, { 5.0, 0.0, 10.0 }, { 0.0, 0.0, 10.0 }, { 0.0, 0.0, 5.0 } },
		{ { 0.0, 5.0, 0.0 }, { 0.0, 10.0, 0.0 }, { 5.0, 10.0, 0.0 }, { 5.0, 5.0, 0.0 } },
	}
	local box5 = {
		-- with coplanar polygons
		-- with coplanar polygons
		{ { -5.0, -5.0, -5.0 }, { -5.0, -5.0, 5.0 }, { -5.0, 5.0, 5.0 }, { -5.0, 5.0, -5.0 } },
		-- end
		-- end
		{ { 10.0, -5.0, -5.0 }, { 10.0, -5.0, 5.0 }, { -5.0, -5.0, 5.0 }, { -5.0, -5.0, -5.0 } },
		-- side
		-- side
		{ { 10.0, 5.0, 5.0 }, { 10.0, 5.0, -5.0 }, { -5.0, 5.0, -5.0 }, { -5.0, 5.0, 5.0 } },
		-- side
		-- side
		{ { 10.0, 5.0, -5.0 }, { 10.0, -5.0, -5.0 }, { -5.0, -5.0, -5.0 }, { -5.0, 5.0, -5.0 } },
		-- bottom
		-- bottom
		{ { 10.0, -5.0, 5.0 }, { 10.0, 0.0, 5.0 }, { -5.0, 0.0, 5.0 }, { -5.0, -5.0, 5.0 } },
		-- top
		-- top
		{ { 10.0, 0.0, 5.0 }, { 10.0, 5.0, 5.0 }, { -5.0, 5.0, 5.0 }, { -5.0, 0.0, 5.0 } },
		-- top
		-- top
		{ { 10.0, -5.0, -5.0 }, { 10.0, 5.0, -5.0 }, { 10.0, 5.0, 5.0 }, { 10.0, -5.0, 5.0 } }, -- end -- end
	}
	local obj1 = geom3.fromPoints(box1)
	local obj2 = geom3.fromPoints(Array.concat(box1, box2) --[[ ROBLOX CHECK: check if 'box1' is an Array ]]) -- combined geometry
	local obj3 = geom3.fromPoints(box3)
	local obj4 = geom3.fromPoints(box4)
	local obj5 = geom3.fromPoints(box5) -- one solid geometry
	local ret1 = retessellate(obj1)
	local pts1 = geom3.toPoints(ret1)
	local exp1 = {
		{ { -5, -5, -5 }, { -5, -5, 5 }, { -5, 5, 5 }, { -5, 5, -5 } },
		{ { 5, -5, -5 }, { 5, 5, -5 }, { 5, 5, 5 }, { 5, -5, 5 } },
		{ { -5, -5, -5 }, { 5, -5, -5 }, { 5, -5, 5 }, { -5, -5, 5 } },
		{ { -5, 5, -5 }, { -5, 5, 5 }, { 5, 5, 5 }, { 5, 5, -5 } },
		{ { -5, -5, -5 }, { -5, 5, -5 }, { 5, 5, -5 }, { 5, -5, -5 } },
		{ { -5, -5, 5 }, { 5, -5, 5 }, { 5, 5, 5 }, { -5, 5, 5 } },
	}
	expect(comparePolygonsAsPoints(pts1, exp1)).toBe(true) -- two non-overlapping geometries
	local ret2 = retessellate(obj2)
	local pts2 = geom3.toPoints(ret2)
	local exp2 = {
		{ { -5, -5, -5 }, { -5, -5, 5 }, { -5, 5, 5 }, { -5, 5, -5 } },
		{ { 5, -5, -5 }, { 5, 5, -5 }, { 5, 5, 5 }, { 5, -5, 5 } },
		{ { -5, -5, -5 }, { 5, -5, -5 }, { 5, -5, 5 }, { -5, -5, 5 } },
		{ { -5, 5, -5 }, { -5, 5, 5 }, { 5, 5, 5 }, { 5, 5, -5 } },
		{ { -5, -5, -5 }, { -5, 5, -5 }, { 5, 5, -5 }, { 5, -5, -5 } },
		{ { -5, -5, 5 }, { 5, -5, 5 }, { 5, 5, 5 }, { -5, 5, 5 } },
		{ { 15, 15, 15 }, { 15, 15, 25 }, { 15, 25, 25 }, { 15, 25, 15 } },
		{ { 25, 15, 15 }, { 25, 25, 15 }, { 25, 25, 25 }, { 25, 15, 25 } },
		{ { 15, 15, 15 }, { 25, 15, 15 }, { 25, 15, 25 }, { 15, 15, 25 } },
		{ { 15, 25, 15 }, { 15, 25, 25 }, { 25, 25, 25 }, { 25, 25, 15 } },
		{ { 15, 15, 15 }, { 15, 25, 15 }, { 25, 25, 15 }, { 25, 15, 15 } },
		{ { 15, 15, 25 }, { 25, 15, 25 }, { 25, 25, 25 }, { 15, 25, 25 } },
	}
	expect(comparePolygonsAsPoints(pts2, exp2)).toBe(true) -- two touching geometries (faces)
	local ret3 = retessellate(obj3)
	local pts3 = geom3.toPoints(ret3)
	local exp3 = {
		{ { -5, 5, 15 }, { -5, 5, -5 }, { -5, -5, -5 }, { -5, -5, 15 } },
		{ { 5, -5, 15 }, { 5, -5, -5 }, { 5, 5, -5 }, { 5, 5, 15 } },
		{ { -5, -5, 15 }, { -5, -5, -5 }, { 5, -5, -5 }, { 5, -5, 15 } },
		{ { 5, 5, 15 }, { 5, 5, -5 }, { -5, 5, -5 }, { -5, 5, 15 } },
		{ { -5, -5, -5 }, { -5, 5, -5 }, { 5, 5, -5 }, { 5, -5, -5 } },
		{ { -5, -5, 15 }, { 5, -5, 15 }, { 5, 5, 15 }, { -5, 5, 15 } },
	}
	expect(comparePolygonsAsPoints(pts3, exp3)).toBe(true) -- two overlapping geometries
	local ret4 = retessellate(obj4)
	local pts4 = geom3.toPoints(ret4)
	local exp4 = {
		{ { -5, -5, -5 }, { -5, -5, 5 }, { -5, 5, 5 }, { -5, 5, -5 } },
		{ { -5, -5, -5 }, { 5, -5, -5 }, { 5, -5, 5 }, { -5, -5, 5 } },
		{ { -5, -5, -5 }, { -5, 5, -5 }, { 5, 5, -5 }, { 5, -5, -5 } },
		{ { 5, -5, 5 }, { 5, -5, 0 }, { 5, 0, 0 }, { 5, 0, 5 } },
		{ { 5, -5, 0 }, { 5, -5, -5 }, { 5, 5, -5 }, { 5, 5, 0 } },
		{ { 0, 5, 5 }, { 0, 5, 0 }, { -5, 5, 0 }, { -5, 5, 5 } },
		{ { 5, 5, 0 }, { 5, 5, -5 }, { -5, 5, -5 }, { -5, 5, 0 } },
		{ { -5, 5, 5 }, { -5, 0, 5 }, { 0, 0, 5 }, { 0, 5, 5 } },
		{ { -5, 0, 5 }, { -5, -5, 5 }, { 5, -5, 5 }, { 5, 0, 5 } },
		{ { 10, 0, 0 }, { 10, 10, 0 }, { 10, 10, 10 }, { 10, 0, 10 } },
		{ { 0, 10, 0 }, { 0, 10, 10 }, { 10, 10, 10 }, { 10, 10, 0 } },
		{ { 0, 0, 10 }, { 10, 0, 10 }, { 10, 10, 10 }, { 0, 10, 10 } },
		{ { 0, 10, 10 }, { 0, 10, 5 }, { 0, 0, 5 }, { 0, 0, 10 } },
		{ { 0, 10, 5 }, { 0, 10, 0 }, { 0, 5, 0 }, { 0, 5, 5 } },
		{ { 0, 0, 10 }, { 0, 0, 5 }, { 10, 0, 5 }, { 10, 0, 10 } },
		{ { 5, 0, 5 }, { 5, -0, 0 }, { 10, -0, 0 }, { 10, 0, 5 } },
		{ { 10, 10, 0 }, { 10, 5, 0 }, { 0, 5, 0 }, { 0, 10, 0 } },
		{ { 10, 5, 0 }, { 10, 0, 0 }, { 5, 0, 0 }, { 5, 5, 0 } },
	}
	expect(comparePolygonsAsPoints(pts4, exp4)).toBe(true) -- coplanar polygons
	local ret5 = retessellate(obj5)
	local pts5 = geom3.toPoints(ret5)
	local exp5 = {
		{ { -5, -5, -5 }, { -5, -5, 5 }, { -5, 5, 5 }, { -5, 5, -5 } },
		{ { 10, -5, -5 }, { 10, -5, 5 }, { -5, -5, 5 }, { -5, -5, -5 } },
		{ { 10, 5, 5 }, { 10, 5, -5 }, { -5, 5, -5 }, { -5, 5, 5 } },
		{ { 10, 5, -5 }, { 10, -5, -5 }, { -5, -5, -5 }, { -5, 5, -5 } },
		{ { -5, 5, 5 }, { -5, -5, 5 }, { 10, -5, 5 }, { 10, 5, 5 } },
		{ { 10, -5, -5 }, { 10, 5, -5 }, { 10, 5, 5 }, { 10, -5, 5 } },
	}
	expect(comparePolygonsAsPoints(pts5, exp5)).toBe(true)
end)