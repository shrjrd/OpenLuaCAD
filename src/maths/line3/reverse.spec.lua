-- ROBLOX NOTE: no upstream
local JestGlobals = require("@DevPackages/JestGlobals")
local test, expect = JestGlobals.test, JestGlobals.expect

local reverse, create, fromPoints
do
	local ref = require("./init")
	reverse, create, fromPoints = ref.reverse, ref.create, ref.fromPoints
end
local compareVectors = require("../../../test/helpers/init").compareVectors
test("line3: reverse() called with two parameters should update a line3 with proper values", function()
	local line1 = create()
	local out = create()
	local rev = reverse(out, line1)
	local pnt = rev[
		1 --[[ ROBLOX adaptation: added 1 to array index ]]
	]
	local dir = rev[
		2 --[[ ROBLOX adaptation: added 1 to array index ]]
	]
	expect(compareVectors(pnt, { 0, 0, 0 })).toBe(true)
	expect(compareVectors(dir, { 0, 0, -1 })).toBe(true)
	pnt = out[
		1 --[[ ROBLOX adaptation: added 1 to array index ]]
	]
	dir = out[
		2 --[[ ROBLOX adaptation: added 1 to array index ]]
	]
	expect(compareVectors(pnt, { 0, 0, 0 })).toBe(true)
	expect(compareVectors(dir, { 0, 0, -1 })).toBe(true)
	expect(line1).never.toBe(out)
	expect(rev).toBe(out) -- reverse in place
	local line2 = fromPoints(create(), { 1, 0, 0 }, { 0, 1, 0 })
	rev = reverse(line2, line2)
	pnt = rev[
		1 --[[ ROBLOX adaptation: added 1 to array index ]]
	]
	dir = rev[
		2 --[[ ROBLOX adaptation: added 1 to array index ]]
	]
	expect(compareVectors(pnt, { 1, 0, 0 })).toBe(true)
	expect(compareVectors(dir, { 0.7071067811865475, -0.7071067811865475, 0 })).toBe(true)
	pnt = line2[
		1 --[[ ROBLOX adaptation: added 1 to array index ]]
	]
	dir = line2[
		2 --[[ ROBLOX adaptation: added 1 to array index ]]
	]
	expect(compareVectors(pnt, { 1, 0, 0 })).toBe(true)
	expect(compareVectors(dir, { 0.7071067811865475, -0.7071067811865475, 0 })).toBe(true)
	expect(rev).toBe(line2)
end)
