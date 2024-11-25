-- ROBLOX NOTE: no upstream
local JestGlobals = require("@DevPackages/JestGlobals")
local test, expect = JestGlobals.test, JestGlobals.expect

local geom2, geom3, path2
do
	local ref = require("../../geometries")
	geom2, geom3, path2 = ref.geom2, ref.geom3, ref.path2
end
local measureVolume = require("../../measurements").measureVolume
local sphere, cuboid, ellipsoid, torus
do
	local ref = require("../../primitives")
	sphere, cuboid, ellipsoid, torus = ref.sphere, ref.cuboid, ref.ellipsoid, ref.torus
end
local center = require("../transforms/center").center
local hull = require("./init").hull
local comparePolygonsAsPoints = require("../../../test/helpers/comparePolygonsAsPoints")
test("hull (single, geom2)", function()
	local geometry = geom2.create()
	local obs = hull(geometry)
	local pts = geom2.toPoints(obs)
	expect(function()
		return geom2.validate(geometry)
	end).never.toThrow()
	expect(#pts).toBe(0)
	geometry = geom2.fromPoints({ { 5, 5 }, { -5, 5 }, { -5, -5 }, { 5, -5 } })
	obs = hull(geometry)
	pts = geom2.toPoints(obs)
	expect(function()
		return geom2.validate(geometry)
	end).never.toThrow()
	expect(#pts).toBe(4) -- convex C shape
	geometry = geom2.fromPoints({
		{ 5.00000, 8.66025 },
		{ -5.00000, 8.66025 },
		{ -10.00000, 0.00000 },
		{ -5.00000, -8.66025 },
		{ 5.00000, -8.66025 },
		{ 6.00000, -6.92820 },
		{ -2.00000, -6.92820 },
		{ -6.00000, 0.00000 },
		{ -2.00000, 6.92820 },
		{ 6.00000, 6.92820 },
	})
	obs = hull(geometry)
	pts = geom2.toPoints(obs)
	expect(function()
		return geom2.validate(geometry)
	end).never.toThrow()
	expect(#pts).toBe(7)
end)
test("hull (multiple, overlapping, geom2)", function()
	local geometry1 = geom2.fromPoints({ { 5, 5 }, { -5, 5 }, { -5, -5 }, { 5, -5 } })
	local geometry2 = geom2.fromPoints({ { 3, 3 }, { -3, 3 }, { -3, -3 }, { 3, -3 } })
	local geometry3 = geom2.fromPoints({ { 6, 3 }, { -6, 3 }, { -6, -3 }, { 6, -3 } }) -- convex C shape
	local geometry4 = geom2.fromPoints({
		{ 5.00000, 8.66025 },
		{ -5.00000, 8.66025 },
		{ -10.00000, 0.00000 },
		{ -5.00000, -8.66025 },
		{ 5.00000, -8.66025 },
		{ 6.00000, -6.92820 },
		{ -2.00000, -6.92820 },
		{ -6.00000, 0.00000 },
		{ -2.00000, 6.92820 },
		{ 6.00000, 6.92820 },
	}) -- same
	local obs = hull(geometry1, geometry1)
	local pts = geom2.toPoints(obs)
	expect(function()
		return geom2.validate(obs)
	end).never.toThrow()
	expect(#pts).toBe(4) -- one inside another
	obs = hull(geometry1, geometry2)
	pts = geom2.toPoints(obs)
	expect(function()
		return geom2.validate(obs)
	end).never.toThrow()
	expect(#pts).toBe(4) -- one overlapping another
	obs = hull(geometry1, geometry3)
	pts = geom2.toPoints(obs)
	expect(function()
		return geom2.validate(obs)
	end).never.toThrow()
	expect(#pts).toBe(8)
	obs = hull(geometry2, geometry4)
	pts = geom2.toPoints(obs)
	expect(function()
		return geom2.validate(obs)
	end).never.toThrow()
	expect(#pts).toBe(7)
end)
test("hull (multiple, various, geom2)", function()
	local geometry1 = geom2.fromPoints({ { 6, 6 }, { 0, 6 }, { 0, 0 }, { 6, 0 } })
	local geometry2 = geom2.fromPoints({ { 6, 3 }, { -6, 3 }, { -6, -3 }, { 6, -3 } })
	local geometry3 = geom2.fromPoints({ { -10, -10 }, { 0, -20 }, { 10, -10 } }) -- convex C shape
	local geometry4 = geom2.fromPoints({
		{ 5.00000, 8.66025 },
		{ -5.00000, 8.66025 },
		{ -10.00000, 0.00000 },
		{ -5.00000, -8.66025 },
		{ 5.00000, -8.66025 },
		{ 6.00000, -6.92820 },
		{ -2.00000, -6.92820 },
		{ -6.00000, 0.00000 },
		{ -2.00000, 6.92820 },
		{ 6.00000, 6.92820 },
	})
	local geometry5 = geom2.fromPoints({ { -17, -17 }, { -23, -17 }, { -23, -23 }, { -17, -23 } })
	local obs = hull(geometry1, geometry2)
	local pts = geom2.toPoints(obs)
	expect(function()
		return geom2.validate(obs)
	end).never.toThrow()
	expect(#pts).toBe(5)
	obs = hull(geometry1, geometry3)
	pts = geom2.toPoints(obs)
	expect(function()
		return geom2.validate(obs)
	end).never.toThrow()
	expect(#pts).toBe(5)
	obs = hull(geometry2, geometry3)
	pts = geom2.toPoints(obs)
	expect(function()
		return geom2.validate(obs)
	end).never.toThrow()
	expect(#pts).toBe(5)
	obs = hull(geometry1, geometry2, geometry3)
	pts = geom2.toPoints(obs)
	expect(function()
		return geom2.validate(obs)
	end).never.toThrow()
	expect(#pts).toBe(6)
	obs = hull(geometry5, geometry4)
	pts = geom2.toPoints(obs)
	expect(function()
		return geom2.validate(obs)
	end).never.toThrow()
	expect(#pts).toBe(8)
end)
test("hull (single, path2)", function()
	local geometry = path2.create()
	local obs = hull(geometry)
	local pts = path2.toPoints(obs)
	expect(function()
		return path2.validate(obs)
	end).never.toThrow()
	expect(#pts).toBe(0)
	geometry = path2.fromPoints({}, { { 0, 0 }, { 5, 0 }, { 5, 10 }, { 4, 1 } })
	obs = hull(geometry)
	pts = path2.toPoints(obs)
	expect(function()
		return path2.validate(obs)
	end).never.toThrow()
	expect(#pts).toBe(3)
end)
test("hull (multiple, various, path2)", function()
	local geometry1 = path2.fromPoints({ closed = true }, { { 6, 6 }, { 0, 6 }, { 0, 0 }, { 6, 0 } })
	local geometry2 = path2.fromPoints({}, { { 6, 3 }, { -6, 3 }, { -6, -3 }, { 6, -3 } })
	local geometry3 = path2.fromPoints({ closed = true }, { { -10, -10 }, { 0, -20 }, { 10, -10 } }) -- convex C shape
	local geometry4 = path2.fromPoints({}, {
		{ 5.00000, 8.66025 },
		{ -5.00000, 8.66025 },
		{ -10.00000, 0.00000 },
		{ -5.00000, -8.66025 },
		{ 5.00000, -8.66025 },
		{ 6.00000, -6.92820 },
		{ -2.00000, -6.92820 },
		{ -6.00000, 0.00000 },
		{ -2.00000, 6.92820 },
		{ 6.00000, 6.92820 },
	})
	local geometry5 = path2.fromPoints({ closed = true }, { { -17, -17 }, { -23, -17 }, { -23, -23 }, { -17, -23 } })
	local obs = hull(geometry1, geometry2)
	local pts = path2.toPoints(obs)
	expect(function()
		return path2.validate(obs)
	end).never.toThrow()
	expect(#pts).toBe(5)
	obs = hull(geometry1, geometry3)
	pts = path2.toPoints(obs)
	expect(function()
		return path2.validate(obs)
	end).never.toThrow()
	expect(#pts).toBe(5)
	obs = hull(geometry2, geometry3)
	pts = path2.toPoints(obs)
	expect(function()
		return path2.validate(obs)
	end).never.toThrow()
	expect(#pts).toBe(5)
	obs = hull(geometry1, geometry2, geometry3)
	pts = path2.toPoints(obs)
	expect(function()
		return path2.validate(obs)
	end).never.toThrow()
	expect(#pts).toBe(6)
	obs = hull(geometry5, geometry4)
	pts = path2.toPoints(obs)
	expect(function()
		return path2.validate(obs)
	end).never.toThrow()
	expect(#pts).toBe(8)
end)
test("hull (single, geom3)", function()
	local geometry = geom3.create()
	local obs = hull(geometry)
	local pts = geom3.toPoints(obs)
	expect(function()
		return geom3.validate(obs)
	end).never.toThrow()
	expect(#pts).toBe(0)
	geometry = sphere({ radius = 2, segments = 8 })
	obs = hull(geometry)
	pts = geom3.toPoints(obs)
	--[=[t.notThrows:skip(function()
		return geom3.validate(obs)
	end)]=]
	expect(#pts).toBe(32)
end)
test("hull (multiple, geom3)", function()
	local geometry1 = cuboid({ size = { 2, 2, 2 } })
	local obs = hull(geometry1, geometry1) -- same
	local pts = geom3.toPoints(obs)
	local exp = {
		{ { -1, 1, -1 }, { -1, 1, 1 }, { 1, 1, 1 }, { 1, 1, -1 } },
		{ { -1, 1, -1 }, { 1, 1, -1 }, { 1, -1, -1 }, { -1, -1, -1 } },
		{ { -1, 1, -1 }, { -1, -1, -1 }, { -1, -1, 1 }, { -1, 1, 1 } },
		{ { 1, -1, 1 }, { 1, -1, -1 }, { 1, 1, -1 }, { 1, 1, 1 } },
		{ { 1, -1, 1 }, { 1, 1, 1 }, { -1, 1, 1 }, { -1, -1, 1 } },
		{ { 1, -1, 1 }, { -1, -1, 1 }, { -1, -1, -1 }, { 1, -1, -1 } },
	}
	expect(function()
		return geom3.validate(obs)
	end).never.toThrow()
	expect(#pts).toBe(6)
	expect(comparePolygonsAsPoints(pts, exp)).toBe(true)
	local geometry2 = center({ relativeTo = { 5, 5, 5 } }, cuboid({ size = { 3, 3, 3 } }))
	obs = hull(geometry1, geometry2)
	pts = geom3.toPoints(obs)
	exp = {
		{ { 1, -1, -1 }, { 6.5, 3.5, 3.5 }, { 6.5, 3.5, 6.5 }, { 1, -1, 1 } },
		{ { -1, -1, 1 }, { -1, -1, -1 }, { 1, -1, -1 }, { 1, -1, 1 } },
		{ { -1, -1, 1 }, { 1, -1, 1 }, { 6.5, 3.5, 6.5 }, { 3.5, 3.5, 6.5 } },
		{ { -1, -1, 1 }, { 3.5, 3.5, 6.5 }, { 3.5, 6.5, 6.5 }, { -1, 1, 1 } },
		{ { -1, 1, -1 }, { -1, 1, 1 }, { 3.5, 6.5, 6.5 }, { 3.5, 6.5, 3.5 } },
		{ { -1, 1, -1 }, { -1, -1, -1 }, { -1, -1, 1 }, { -1, 1, 1 } },
		{ { 6.5, 6.5, 6.5 }, { 6.5, 3.5, 6.5 }, { 6.5, 3.5, 3.5 }, { 6.5, 6.5, 3.5 } },
		{ { 6.5, 6.5, 6.5 }, { 6.5, 6.5, 3.5 }, { 3.5, 6.5, 3.5 }, { 3.5, 6.5, 6.5 } },
		{ { 6.5, 6.5, 6.5 }, { 3.5, 6.5, 6.5 }, { 3.5, 3.5, 6.5 }, { 6.5, 3.5, 6.5 } },
		{ { 1, 1, -1 }, { 1, -1, -1 }, { -1, -1, -1 }, { -1, 1, -1 } },
		{ { 1, 1, -1 }, { -1, 1, -1 }, { 3.5, 6.5, 3.5 }, { 6.5, 6.5, 3.5 } },
		{ { 1, 1, -1 }, { 6.5, 6.5, 3.5 }, { 6.5, 3.5, 3.5 }, { 1, -1, -1 } },
	}
	expect(function()
		return geom3.validate(obs)
	end).never.toThrow()
	expect(#pts).toBe(12)
	expect(comparePolygonsAsPoints(pts, exp)).toBe(true)
end)
test("hull (multiple, overlapping, geom3)", function()
	local geometry1 = ellipsoid({ radius = { 2, 2, 2 }, segments = 12 })
	local geometry2 = center({ relativeTo = { 3, -3, 3 } }, ellipsoid({ radius = { 3, 3, 3 }, segments = 12 }))
	local geometry3 = center({ relativeTo = { -3, -3, -3 } }, ellipsoid({ radius = { 3, 3, 3 }, segments = 12 }))
	local obs = hull(geometry1, geometry2, geometry3)
	local pts = geom3.toPoints(obs)
	expect(function()
		return geom3.validate(obs)
	end).never.toThrow()
	expect(#pts).toBe(92)
end)
test("hull (single, unconvex, geom3)", function()
	local geometry = torus()
	local obs = hull(geometry)
	--[=[t:assert_(
		measureVolume(obs) > measureVolume(geometry) --[[ ROBLOX CHECK: operator '>' works only if either both arguments are strings or both are a number ]]
	)]=]
	expect(measureVolume(obs)).toBeGreaterThan(measureVolume(geometry))
end)
