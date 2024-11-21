-- ROBLOX NOTE: no upstream
local JestGlobals = require("@DevPackages/JestGlobals")
local test, expect = JestGlobals.test, JestGlobals.expect

local mat4 = require("../../maths").mat4
local slice = require("./slice")
local extrudeWalls = require("./extrudeWalls")
test("extrudeWalls (same shapes)", function()
	local matrix = mat4.fromTranslation(mat4.create(), { 0, 0, 10 })
	local shape0 = {}
	local shape1 = {
		{ { -10.0, 10.0 }, { -10.0, -10.0 } },
		{ { -10.0, -10.0 }, { 10.0, -10.0 } },
		{ { 10.0, -10.0 }, { 10.0, 10.0 } },
		{ { 10.0, 10.0 }, { -10.0, 10.0 } },
	}
	local shape2 = {
		-- hole
		-- hole
		{ { -10.0, 10.0 }, { -10.0, -10.0 } },
		{ { -10.0, -10.0 }, { 10.0, -10.0 } },
		{ { 10.0, -10.0 }, { 10.0, 10.0 } },
		{ { 10.0, 10.0 }, { -10.0, 10.0 } },
		{ { -5.0, -5.0 }, { -5.0, 5.0 } },
		{ { 5.0, -5.0 }, { -5.0, -5.0 } },
		{ { 5.0, 5.0 }, { 5.0, -5.0 } },
		{ { -5.0, 5.0 }, { 5.0, 5.0 } },
	}
	local slice0 = slice.fromSides(shape0)
	local slice1 = slice.fromSides(shape1)
	local slice2 = slice.fromSides(shape2) -- empty slices
	local walls = extrudeWalls(slice0, slice0)
	expect(#walls).toBe(0) -- outline slices
	walls = extrudeWalls(slice1, slice.transform(matrix, slice1))
	expect(#walls).toBe(8) -- slices with holes
	walls = extrudeWalls(slice2, slice.transform(matrix, slice2))
	expect(#walls).toBe(16)
end)
test("extrudeWalls (different shapes)", function()
	local matrix = mat4.fromTranslation(mat4.create(), { 0, 0, 10 })
	local shape1 = {
		{ { -10.0, 10.0 }, { -10.0, -10.0 } },
		{ { -10.0, -10.0 }, { 10.0, -10.0 } },
		{ { 10.0, -10.0 }, { 10.0, 10.0 } },
	}
	local shape2 = {
		{ { -10.0, 10.0 }, { -10.0, -10.0 } },
		{ { -10.0, -10.0 }, { 10.0, -10.0 } },
		{ { 10.0, -10.0 }, { 10.0, 10.0 } },
		{ { 10.0, 10.0 }, { -10.0, 10.0 } },
	}
	local shape3 = {
		{ { 2.50000, -4.33013 }, { 5.00000, 0.00000 } },
		{ { 5.00000, 0.00000 }, { 2.50000, 4.33013 } },
		{ { 2.50000, 4.33013 }, { -2.50000, 4.33013 } },
		{ { -2.50000, 4.33013 }, { -5.00000, 0.00000 } },
		{ { -5.00000, 0.00000 }, { -2.50000, -4.33013 } },
		{ { -2.50000, -4.33013 }, { 2.50000, -4.33013 } },
	}
	local slice1 = slice.fromSides(shape1)
	local slice2 = slice.fromSides(shape2)
	local slice3 = slice.fromSides(shape3)
	local walls = extrudeWalls(slice1, slice.transform(matrix, slice2))
	expect(#walls).toBe(24)
	walls = extrudeWalls(slice1, slice.transform(matrix, slice3))
	expect(#walls).toBe(12)
	walls = extrudeWalls(slice3, slice.transform(matrix, slice2))
	expect(#walls).toBe(24)
end)
