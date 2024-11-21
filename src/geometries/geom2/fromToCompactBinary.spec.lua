-- ROBLOX NOTE: no upstream
local JestGlobals = require("@DevPackages/JestGlobals")
local test, expect = JestGlobals.test, JestGlobals.expect

local fromCompactBinary, toCompactBinary, create
do
	local ref = require("./init")
	fromCompactBinary, toCompactBinary, create = ref.fromCompactBinary, ref.toCompactBinary, ref.create
end
test("toCompactBinary: converts geom2 into a compact form", function()
	local geometry1 = create()
	local compacted1 = toCompactBinary(geometry1)
	local expected1 = {
		0,
		-- type flag
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
		-1, -- color
	}
	expect(compacted1).toEqual(expected1) -- geometry with a hole
	local geometry2 = create({
		{ { 10, 10 }, { -10, -10 } },
		{ { -10, -10 }, { 10, -10 } },
		{ { 10, -10 }, { 10, 10 } },
		{ { 5, -5 }, { 6, -4 } },
		{ { 6, -5 }, { 5, -5 } },
		{ { 6, -4 }, { 6, -5 } },
	})
	local compacted2 = toCompactBinary(geometry2)
	local expected2 = {
		0,
		-- type flag
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
		10,
		10,
		-10,
		-10,
		-- sides
		-10,
		-10,
		10,
		-10,
		10,
		-10,
		10,
		10,
		5,
		-5,
		6,
		-4,
		6,
		-5,
		5,
		-5,
		6,
		-4,
		6,
		-5,
	}
	expect(compacted2).toEqual(expected2) -- test color as well
	geometry2.color = { 1, 2, 3, 4 }
	local compacted3 = toCompactBinary(geometry2)
	local expected3 = {
		0,
		-- type flag
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
		10,
		10,
		-10,
		-10,
		-- sides
		-10,
		-10,
		10,
		-10,
		10,
		-10,
		10,
		10,
		5,
		-5,
		6,
		-4,
		6,
		-5,
		5,
		-5,
		6,
		-4,
		6,
		-5,
	}
	expect(compacted3).toEqual(expected3)
end)
test("fromCompactBinary: convert a compact form into a geom2", function()
	local compacted1 = {
		0,
		-- type flag
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
		-1, -- color
	}
	local expected1 = create()
	local geometry1 = fromCompactBinary(compacted1)
	expect(geometry1).toEqual(expected1) -- geometry with a hole
	local compacted2 = {
		0,
		-- type flag
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
		10,
		10,
		-10,
		-10,
		-- sides
		-10,
		-10,
		10,
		-10,
		10,
		-10,
		10,
		10,
		5,
		-5,
		6,
		-4,
		6,
		-5,
		5,
		-5,
		6,
		-4,
		6,
		-5,
	}
	local expected2 = create({
		{ { 10, 10 }, { -10, -10 } },
		{ { -10, -10 }, { 10, -10 } },
		{ { 10, -10 }, { 10, 10 } },
		{ { 5, -5 }, { 6, -4 } },
		{ { 6, -5 }, { 5, -5 } },
		{ { 6, -4 }, { 6, -5 } },
	})
	local geometry2 = fromCompactBinary(compacted2)
	expect(geometry2).toEqual(expected2) -- test color as well
	local compacted3 = {
		0,
		-- type flag
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
		10,
		10,
		-10,
		-10,
		-- sides
		-10,
		-10,
		10,
		-10,
		10,
		-10,
		10,
		10,
		5,
		-5,
		6,
		-4,
		6,
		-5,
		5,
		-5,
		6,
		-4,
		6,
		-5,
	}
	expected2.color = { 4, 5, 6, 7 }
	local geometry3 = fromCompactBinary(compacted3)
	expect(geometry3).toEqual(expected2)
end)
