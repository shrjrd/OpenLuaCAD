-- ROBLOX NOTE: no upstream
local JestGlobals = require("@DevPackages/JestGlobals")
local test, expect = JestGlobals.test, JestGlobals.expect

local plane = require("../plane")
local isMirroring, fromScaling, create, mirrorByPlane, rotate, scale, translate
do
	local ref = require("./init")
	isMirroring, fromScaling, create, mirrorByPlane, rotate, scale, translate =
		ref.isMirroring, ref.fromScaling, ref.create, ref.mirrorByPlane, ref.rotate, ref.scale, ref.translate
end
test("mat4. isMirroring() should determine correctly", function()
	local matrix = create()
	expect(isMirroring(matrix)).toBe(false)
	matrix = fromScaling(create(), { 2, 4, 6 })
	expect(isMirroring(matrix)).toBe(false)
	local planeX = plane.fromPoints(plane.create(), { 0, 0, 0 }, { 0, 1, 1 }, { 0, 1, 0 })
	local planeY = plane.fromPoints(plane.create(), { 0, 0, 0 }, { 1, 0, 0 }, { 1, 0, 1 })
	local planeZ = plane.fromPoints(plane.create(), { 0, 0, 0 }, { 1, 0, 0 }, { 1, 1, 0 })
	matrix = mirrorByPlane(create(), planeX)
	expect(isMirroring(matrix)).toBe(true)
	matrix = mirrorByPlane(create(), planeY)
	expect(isMirroring(matrix)).toBe(true)
	matrix = mirrorByPlane(create(), planeZ)
	expect(isMirroring(matrix)).toBe(true) -- additional transforms
	local rotation = 90 * 0.017453292519943295
	matrix = rotate(matrix, matrix, rotation, { 0, 0, 1 })
	expect(isMirroring(matrix)).toBe(true)
	matrix = scale(matrix, matrix, { 0.5, 2, 5 })
	expect(isMirroring(matrix)).toBe(true)
	matrix = translate(matrix, matrix, { 2, -3, 600 })
	expect(isMirroring(matrix)).toBe(true)
end)
