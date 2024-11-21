-- ROBLOX NOTE: no upstream
local JestGlobals = require("@DevPackages/JestGlobals")
local test, expect = JestGlobals.test, JestGlobals.expect

local fromPoints, create
do
	local ref = require("./init")
	fromPoints, create = ref.fromPoints, ref.create
end
local compareVectors = require("../../../test/helpers/init").compareVectors
test("line3: fromPoints() should return a new line3 with correct values", function()
	local obs = fromPoints(create(), { 0, 0, 0 }, { 1, 0, 0 })
	local pnt = obs[
		1 --[[ ROBLOX adaptation: added 1 to array index ]]
	]
	local dir = obs[
		2 --[[ ROBLOX adaptation: added 1 to array index ]]
	]
	expect(compareVectors(pnt, { 0, 0, 0 })).toBe(true)
	expect(compareVectors(dir, { 1, 0, 0 })).toBe(true)
	obs = fromPoints(create(), { 1, 0, 0 }, { 0, 1, 0 })
	pnt = obs[
		1 --[[ ROBLOX adaptation: added 1 to array index ]]
	]
	dir = obs[
		2 --[[ ROBLOX adaptation: added 1 to array index ]]
	]
	expect(compareVectors(pnt, { 1, 0, 0 })).toBe(true)
	expect(compareVectors(dir, { -0.7071067811865475, 0.7071067811865475, 0 })).toBe(true)
	obs = fromPoints(create(), { 0, 1, 0 }, { 1, 0, 0 })
	pnt = obs[
		1 --[[ ROBLOX adaptation: added 1 to array index ]]
	]
	dir = obs[
		2 --[[ ROBLOX adaptation: added 1 to array index ]]
	]
	expect(compareVectors(pnt, { 0, 1, 0 })).toBe(true)
	expect(compareVectors(dir, { 0.7071067811865475, -0.7071067811865475, 0 })).toBe(true)
	obs = fromPoints(obs, { 0, 6, 0 }, { 0, 0, 6 })
	pnt = obs[
		1 --[[ ROBLOX adaptation: added 1 to array index ]]
	]
	dir = obs[
		2 --[[ ROBLOX adaptation: added 1 to array index ]]
	]
	expect(compareVectors(pnt, { 0, 6, 0 })).toBe(true)
	expect(compareVectors(dir, { 0, -0.7071067811865475, 0.7071067811865475 })).toBe(true) -- line3 created from the same points results in an invalid line3
	obs = fromPoints(obs, { 0, 5, 0 }, { 0, 5, 0 })
	pnt = obs[
		1 --[[ ROBLOX adaptation: added 1 to array index ]]
	]
	dir = obs[
		2 --[[ ROBLOX adaptation: added 1 to array index ]]
	]
	expect(compareVectors(pnt, { 0, 5, 0 })).toBe(true)
	expect(compareVectors(dir, { 0 / 0, 0 / 0, 0 / 0 })).toBe(true)
end)
