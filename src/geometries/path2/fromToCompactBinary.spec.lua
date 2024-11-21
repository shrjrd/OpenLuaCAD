-- ROBLOX NOTE: no upstream
local JestGlobals = require("@DevPackages/JestGlobals")
local test, expect = JestGlobals.test, JestGlobals.expect

local fromCompactBinary, toCompactBinary, create, fromPoints
do
	local ref = require("./init")
	fromCompactBinary, toCompactBinary, create, fromPoints =
		ref.fromCompactBinary, ref.toCompactBinary, ref.create, ref.fromPoints
end
test("toCompactBinary: converts path2 into a compact form", function()
	local geometry1 = create()
	local compacted1 = toCompactBinary(geometry1)
	local expected1 = {
		2,
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
		0,
		-- isClosed
		-1,
		-1,
		-1,
		-1, -- color
	}
	expect(compacted1).toEqual(expected1)
	local points = { { 0, 0 }, { 1, 0 }, { 0, 1 } }
	local geometry2 = fromPoints({ closed = true }, points)
	local compacted2 = toCompactBinary(geometry2)
	local expected2 = {
		2,
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
		-- closed/open flag
		-1,
		-1,
		-1,
		-1,
		-- color
		0,
		0,
		-- points
		1,
		0,
		0,
		1,
	}
	expect(compacted2).toEqual(expected2) -- test color as well
	geometry2.color = { 1, 2, 3, 4 }
	local compacted3 = toCompactBinary(geometry2)
	local expected3 = {
		2,
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
		-- closed/open flag
		1,
		2,
		3,
		4,
		-- color
		0,
		0,
		-- points
		1,
		0,
		0,
		1,
	}
	expect(compacted3).toEqual(expected3)
end)
test("fromCompactBinary: convert a compact form into a path2", function()
	local compacted1 = {
		2,
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
		0,
		-- isClosed
		-1,
		-1,
		-1,
		-1, -- color
	}
	local expected1 = create()
	local geometry1 = fromCompactBinary(compacted1)
	expect(geometry1).toEqual(expected1)
	local compacted2 = {
		2,
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
		-- closed/open flag
		-1,
		-1,
		-1,
		-1,
		-- color
		0,
		0,
		-- points
		1,
		0,
		0,
		1,
	}
	local points = { { 0, 0 }, { 1, 0 }, { 0, 1 } }
	local expected2 = fromPoints({ closed = true }, points)
	local geometry2 = fromCompactBinary(compacted2)
	expect(geometry2).toEqual(expected2) -- test color as well
	local compacted3 = {
		2,
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
		-- closed/open flag
		5,
		6,
		7,
		8,
		-- color
		0,
		0,
		-- points
		1,
		0,
		0,
		1,
	}
	local expected3 = fromPoints({ closed = true }, points)
	expected3.color = { 5, 6, 7, 8 }
	local geometry3 = fromCompactBinary(compacted3)
	expect(geometry3).toEqual(expected3)
end)
