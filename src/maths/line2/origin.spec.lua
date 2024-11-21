-- ROBLOX NOTE: no upstream
local JestGlobals = require("@DevPackages/JestGlobals")
local test, expect = JestGlobals.test, JestGlobals.expect

local origin, create, fromPoints
do
	local ref = require("./init")
	origin, create, fromPoints = ref.origin, ref.create, ref.fromPoints
end
local compareVectors = require("../../../test/helpers/init").compareVectors
test("line2. origin() should return proper origins", function()
	local line1 = create()
	local org1 = origin(line1)
	expect(compareVectors(org1, { 0, 0 })).toBe(true)
	local line2 = fromPoints(create(), { 1, 0 }, { 0, 1 })
	local org2 = origin(line2)
	expect(compareVectors(org2, { 0.5000000000000001, 0.5 })).toBe(true)
	local line3 = fromPoints(create(), { 0, 1 }, { 1, 0 })
	local org3 = origin(line3)
	expect(compareVectors(org3, { 0.5, 0.4999999999999999 })).toBe(true)
	local line4 = fromPoints(create(), { 0, 6 }, { 6, 0 })
	local org4 = origin(line4)
	expect(compareVectors(org4, { 3.0000000000000004, 3.0000000000000004 })).toBe(true)
	local line5 = fromPoints(create(), { -5, 5 }, { 5, -5 })
	local org5 = origin(line5)
	expect(compareVectors(org5, { 0, 0 })).toBe(true)
	local line6 = fromPoints(create(), { 10, 0 }, { 0, 10 })
	local org6 = origin(line6)
	expect(compareVectors(org6, { 5, 5 })).toBe(true)
end)
