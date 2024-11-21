-- ROBLOX NOTE: no upstream
local JestGlobals = require("@DevPackages/JestGlobals")
local test, expect = JestGlobals.test, JestGlobals.expect

local plane = require("../plane/")
local fromPlanes, create
do
	local ref = require("./init")
	fromPlanes, create = ref.fromPlanes, ref.create
end
local compareVectors = require("../../../test/helpers/init").compareVectors
test("line3: fromPlanes() should return a new line3 with correct values", function()
	local planeXY = plane.fromPoints(plane.create(), { 0, 0, 0 }, { 1, 0, 0 }, { 1, 1, 0 }) -- flat on XY
	local planeXZ = plane.fromPoints(plane.create(), { 0, 0, 0 }, { 1, 0, 0 }, { 0, 0, 1 }) -- flat on XZ
	local planeYZ = plane.fromPoints(plane.create(), { 0, 0, 0 }, { 0, 1, 0 }, { 0, 0, 1 }) -- flat on YZ
	local plane2 = plane.fromPoints(plane.create(), { 0, -3, 0 }, { 1, -3, 0 }, { 0, -3, 1 })
	local obs = fromPlanes(create(), planeXY, planeXZ)
	local pnt = obs[
		1 --[[ ROBLOX adaptation: added 1 to array index ]]
	]
	local dir = obs[
		2 --[[ ROBLOX adaptation: added 1 to array index ]]
	]
	expect(compareVectors(pnt, { 0, 0, 0 })).toBe(true)
	expect(compareVectors(dir, { 1, 0, 0 })).toBe(true)
	obs = fromPlanes(create(), planeYZ, planeXZ)
	pnt = obs[
		1 --[[ ROBLOX adaptation: added 1 to array index ]]
	]
	dir = obs[
		2 --[[ ROBLOX adaptation: added 1 to array index ]]
	]
	expect(compareVectors(pnt, { 0, 0, 0 })).toBe(true)
	expect(compareVectors(dir, { 0, 0, -1 })).toBe(true)
	obs = fromPlanes(create(), planeXY, planeYZ)
	pnt = obs[
		1 --[[ ROBLOX adaptation: added 1 to array index ]]
	]
	dir = obs[
		2 --[[ ROBLOX adaptation: added 1 to array index ]]
	]
	expect(compareVectors(pnt, { 0, 0, 0 })).toBe(true)
	expect(compareVectors(dir, { 0, 1, 0 })).toBe(true)
	obs = fromPlanes(obs, planeXY, plane2)
	pnt = obs[
		1 --[[ ROBLOX adaptation: added 1 to array index ]]
	]
	dir = obs[
		2 --[[ ROBLOX adaptation: added 1 to array index ]]
	]
	expect(compareVectors(pnt, { 0, -3, 0 })).toBe(true)
	expect(compareVectors(dir, { 1, 0, 0 })).toBe(true)
end)
