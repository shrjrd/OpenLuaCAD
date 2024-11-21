-- ROBLOX NOTE: no upstream
local JestGlobals = require("@DevPackages/JestGlobals")
local test, expect = JestGlobals.test, JestGlobals.expect

local fromPointAndDirection, create
do
	local ref = require("./init")
	fromPointAndDirection, create = ref.fromPointAndDirection, ref.create
end
local compareVectors = require("../../../test/helpers/init").compareVectors
test("line3: fromPointAndDirection() should return a new line3 with correct values", function()
	local obs = fromPointAndDirection(create(), { 0, 0, 0 }, { 1, 0, 0 })
	local pnt = obs[
		1 --[[ ROBLOX adaptation: added 1 to array index ]]
	]
	local dir = obs[
		2 --[[ ROBLOX adaptation: added 1 to array index ]]
	]
	expect(compareVectors(pnt, { 0, 0, 0 })).toBe(true)
	expect(compareVectors(dir, { 1, 0, 0 })).toBe(true)
	obs = fromPointAndDirection(create(), { 1, 0, 0 }, { 0, 2, 0 })
	pnt = obs[
		1 --[[ ROBLOX adaptation: added 1 to array index ]]
	]
	dir = obs[
		2 --[[ ROBLOX adaptation: added 1 to array index ]]
	]
	expect(compareVectors(pnt, { 1, 0, 0 })).toBe(true)
	expect(compareVectors(dir, { 0, 1, 0 })).toBe(true)
	obs = fromPointAndDirection(create(), { 0, 1, 0 }, { 3, 0, 0 })
	pnt = obs[
		1 --[[ ROBLOX adaptation: added 1 to array index ]]
	]
	dir = obs[
		2 --[[ ROBLOX adaptation: added 1 to array index ]]
	]
	expect(compareVectors(pnt, { 0, 1, 0 })).toBe(true)
	expect(compareVectors(dir, { 1, 0, 0 })).toBe(true)
	obs = fromPointAndDirection(create(), { 0, 0, 1 }, { 0, 0, 4 })
	pnt = obs[
		1 --[[ ROBLOX adaptation: added 1 to array index ]]
	]
	dir = obs[
		2 --[[ ROBLOX adaptation: added 1 to array index ]]
	]
	expect(compareVectors(pnt, { 0, 0, 1 })).toBe(true)
	expect(compareVectors(dir, { 0, 0, 1 })).toBe(true) -- line3 created from a bad direction results in an invalid line3
	obs = fromPointAndDirection(create(), { 0, 5, 0 }, { 0, 0, 0 })
	pnt = obs[
		1 --[[ ROBLOX adaptation: added 1 to array index ]]
	]
	dir = obs[
		2 --[[ ROBLOX adaptation: added 1 to array index ]]
	]
	expect(compareVectors(pnt, { 0, 5, 0 })).toBe(true)
	expect(compareVectors(dir, { 0 / 0, 0 / 0, 0 / 0 })).toBe(true)
end)
