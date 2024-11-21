-- ROBLOX NOTE: no upstream
local JestGlobals = require("@DevPackages/JestGlobals")
local test, expect = JestGlobals.test, JestGlobals.expect

local geom2, geom3
do
	local ref = require("../../geometries")
	geom2, geom3 = ref.geom2, ref.geom3
end
local hullChain = require("./init").hullChain
test("hullChain (two, geom2)", function()
	local geometry1 = geom2.fromPoints({ { 6, 6 }, { 3, 6 }, { 3, 3 }, { 6, 3 } })
	local geometry2 = geom2.fromPoints({ { -6, -6 }, { -9, -6 }, { -9, -9 }, { -6, -9 } }) -- same
	local obs = hullChain(geometry1, geometry1)
	local pts = geom2.toPoints(obs)
	expect(function()
		return geom2.validate(obs)
	end)["not"].toThrow()
	expect(#pts).toBe(4) -- different
	obs = hullChain(geometry1, geometry2)
	pts = geom2.toPoints(obs)
	expect(function()
		return geom2.validate(obs)
	end)["not"].toThrow()
	expect(#pts).toBe(6)
end)
test("hullChain (three, geom2)", function()
	local geometry1 = geom2.fromPoints({ { 6, 6 }, { 3, 6 }, { 3, 3 }, { 6, 3 } })
	local geometry2 = geom2.fromPoints({ { -6, -6 }, { -9, -6 }, { -9, -9 }, { -6, -9 } })
	local geometry3 = geom2.fromPoints({ { -6, 6 }, { -3, 6 }, { -3, 9 }, { -6, 9 } }) -- open
	local obs = hullChain(geometry1, geometry2, geometry3)
	local pts = geom2.toPoints(obs) -- the sides change based on the bestplane chosen in trees/Node.js
	expect(function()
		return geom2.validate(obs)
	end)["not"].toThrow()
	expect(#pts).toBe(10) -- closed
	obs = hullChain(geometry1, geometry2, geometry3, geometry1)
	pts = geom2.toPoints(obs) -- the sides change based on the bestplane chosen in trees/Node.js
	expect(function()
		return geom2.validate(obs)
	end)["not"].toThrow()
	expect(#pts).toBe(10)
end)
test("hullChain (three, geom3)", function()
	local geometry1 = geom3.fromPoints({
		{ { -1, -1, -1 }, { -1, -1, 1 }, { -1, 1, 1 }, { -1, 1, -1 } },
		{ { 1, -1, -1 }, { 1, 1, -1 }, { 1, 1, 1 }, { 1, -1, 1 } },
		{ { -1, -1, -1 }, { 1, -1, -1 }, { 1, -1, 1 }, { -1, -1, 1 } },
		{ { -1, 1, -1 }, { -1, 1, 1 }, { 1, 1, 1 }, { 1, 1, -1 } },
		{ { -1, -1, -1 }, { -1, 1, -1 }, { 1, 1, -1 }, { 1, -1, -1 } },
		{ { -1, -1, 1 }, { 1, -1, 1 }, { 1, 1, 1 }, { -1, 1, 1 } },
	})
	local geometry2 = geom3.fromPoints({
		{ { 3.5, 3.5, 3.5 }, { 3.5, 3.5, 6.5 }, { 3.5, 6.5, 6.5 }, { 3.5, 6.5, 3.5 } },
		{ { 6.5, 3.5, 3.5 }, { 6.5, 6.5, 3.5 }, { 6.5, 6.5, 6.5 }, { 6.5, 3.5, 6.5 } },
		{ { 3.5, 3.5, 3.5 }, { 6.5, 3.5, 3.5 }, { 6.5, 3.5, 6.5 }, { 3.5, 3.5, 6.5 } },
		{ { 3.5, 6.5, 3.5 }, { 3.5, 6.5, 6.5 }, { 6.5, 6.5, 6.5 }, { 6.5, 6.5, 3.5 } },
		{ { 3.5, 3.5, 3.5 }, { 3.5, 6.5, 3.5 }, { 6.5, 6.5, 3.5 }, { 6.5, 3.5, 3.5 } },
		{ { 3.5, 3.5, 6.5 }, { 6.5, 3.5, 6.5 }, { 6.5, 6.5, 6.5 }, { 3.5, 6.5, 6.5 } },
	})
	local geometry3 = geom3.fromPoints({
		{ { -4.5, 1.5, -4.5 }, { -4.5, 1.5, -1.5 }, { -4.5, 4.5, -1.5 }, { -4.5, 4.5, -4.5 } },
		{ { -1.5, 1.5, -4.5 }, { -1.5, 4.5, -4.5 }, { -1.5, 4.5, -1.5 }, { -1.5, 1.5, -1.5 } },
		{ { -4.5, 1.5, -4.5 }, { -1.5, 1.5, -4.5 }, { -1.5, 1.5, -1.5 }, { -4.5, 1.5, -1.5 } },
		{ { -4.5, 4.5, -4.5 }, { -4.5, 4.5, -1.5 }, { -1.5, 4.5, -1.5 }, { -1.5, 4.5, -4.5 } },
		{ { -4.5, 1.5, -4.5 }, { -4.5, 4.5, -4.5 }, { -1.5, 4.5, -4.5 }, { -1.5, 1.5, -4.5 } },
		{ { -4.5, 1.5, -1.5 }, { -1.5, 1.5, -1.5 }, { -1.5, 4.5, -1.5 }, { -4.5, 4.5, -1.5 } },
	}) -- open
	local obs = hullChain(geometry1, geometry2, geometry3)
	local pts = geom3.toPoints(obs)
	t.notThrows:skip(function()
		return geom3.validate(obs)
	end)
	expect(#pts).toBe(23) -- closed
	obs = hullChain(geometry1, geometry2, geometry3, geometry1)
	pts = geom3.toPoints(obs)
	t.notThrows:skip(function()
		return geom3.validate(obs)
	end)
	expect(#pts).toBe(28)
end)
