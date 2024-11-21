-- ROBLOX NOTE: no upstream
local JestGlobals = require("@DevPackages/JestGlobals")
local test, expect = JestGlobals.test, JestGlobals.expect

local fromCompactBinary, toCompactBinary, create, fromPoints
do
	local ref = require("./init")
	fromCompactBinary, toCompactBinary, create, fromPoints =
		ref.fromCompactBinary, ref.toCompactBinary, ref.create, ref.fromPoints
end
test("toCompactBinary: converts geom3 (default)", function()
	local geometry = create()
	local compacted = toCompactBinary(geometry)
	local expected = {
		1,
		-- type
		1,
		0,
		0,
		0,
		-- transforms
		0,
		1,
		0,
		0,
		0,
		0,
		1,
		0,
		0,
		0,
		0,
		1,
		-1,
		-1,
		-1,
		-1,
		-- color
		0, -- number of vertices
	}
	expect(compacted).toEqual(expected)
end)
test("toCompactBinary: converts geom3 into a compact form", function()
	-- two polygons; 3 points, 4 points
	local points = {
		{ { 0, 0, 0 }, { 1, 0, 0 }, { 2, 0, 2 } },
		{ { 0, 0, 0 }, { 1, 0, 0 }, { 2, 0, 2 }, { -3, 0, 3 } },
	}
	local geometry = fromPoints(points)
	local compacted = toCompactBinary(geometry)
	local expected = {
		1,
		-- type
		1,
		0,
		0,
		0,
		-- transforms
		0,
		1,
		0,
		0,
		0,
		0,
		1,
		0,
		0,
		0,
		0,
		1,
		-1,
		-1,
		-1,
		-1,
		-- color
		7,
		-- number of vertices
		3,
		-- number of vertices per polygon (2)
		4,
		0,
		0,
		0,
		-- vertices (7)
		1,
		0,
		0,
		2,
		0,
		2,
		0,
		0,
		0,
		1,
		0,
		0,
		2,
		0,
		2,
		-3,
		0,
		3,
	}
	expect(compacted).toEqual(expected) -- test color as well
	geometry.color = { 1, 2, 3, 4 }
	local compacted2 = toCompactBinary(geometry)
	local expected2 = {
		1,
		-- type
		1,
		0,
		0,
		0,
		-- transforms
		0,
		1,
		0,
		0,
		0,
		0,
		1,
		0,
		0,
		0,
		0,
		1,
		1,
		2,
		3,
		4,
		-- color
		7,
		-- number of vertices
		3,
		-- number of vertices per polygon (2)
		4,
		0,
		0,
		0,
		-- vertices (7)
		1,
		0,
		0,
		2,
		0,
		2,
		0,
		0,
		0,
		1,
		0,
		0,
		2,
		0,
		2,
		-3,
		0,
		3,
	}
	expect(compacted2).toEqual(expected2)
end)
test("fromCompactBinary: convert a compact form into a geom3", function()
	local compactedDefault = {
		1,
		-- type
		1,
		0,
		0,
		0,
		-- transforms
		0,
		1,
		0,
		0,
		0,
		0,
		1,
		0,
		0,
		0,
		0,
		1,
		-1,
		-1,
		-1,
		-1,
		-- color
		0, -- number of vertices
	}
	local expected = create()
	local geometry = fromCompactBinary(compactedDefault)
	expect(geometry).toEqual(expected)
	local compacted1 = {
		1,
		-- type
		1,
		0,
		0,
		0,
		-- transforms
		0,
		1,
		0,
		0,
		0,
		0,
		1,
		0,
		0,
		0,
		0,
		1,
		-1,
		-1,
		-1,
		-1,
		-- color
		7,
		-- number of vertices
		3,
		-- number of vertices per polygon (2)
		4,
		0,
		0,
		0,
		-- vertices (7)
		1,
		0,
		0,
		2,
		0,
		2,
		0,
		0,
		0,
		1,
		0,
		0,
		2,
		0,
		2,
		-3,
		0,
		3,
	}
	local points = {
		{ { 0, 0, 0 }, { 1, 0, 0 }, { 2, 0, 2 } },
		{ { 0, 0, 0 }, { 1, 0, 0 }, { 2, 0, 2 }, { -3, 0, 3 } },
	}
	expected = fromPoints(points)
	geometry = fromCompactBinary(compacted1)
	expect(geometry).toEqual(expected) -- test color as well
	local compacted2 = {
		1,
		-- type
		1,
		0,
		0,
		0,
		-- transforms
		0,
		1,
		0,
		0,
		0,
		0,
		1,
		0,
		0,
		0,
		0,
		1,
		4,
		5,
		6,
		7,
		-- color
		7,
		-- number of vertices
		3,
		-- number of vertices per polygon (2)
		4,
		0,
		0,
		0,
		-- vertices (7)
		1,
		0,
		0,
		2,
		0,
		2,
		0,
		0,
		0,
		1,
		0,
		0,
		2,
		0,
		2,
		-3,
		0,
		3,
	}
	expected.color = { 4, 5, 6, 7 }
	geometry = fromCompactBinary(compacted2)
	expect(geometry).toEqual(expected)
end)
