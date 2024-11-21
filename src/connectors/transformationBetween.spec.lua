-- ROBLOX NOTE: no upstream
local JestGlobals = require("@DevPackages/JestGlobals")
local test, expect = JestGlobals.test, JestGlobals.expect

local transformationBetween, create, fromPointAxisNormal
do
	local ref = require("./init")
	transformationBetween, create, fromPointAxisNormal = ref.transformationBetween, ref.create, ref.fromPointAxisNormal
end
local compareVectors = require("../../test/helpers").compareVectors
test("connector: transformationBetween() should return correct transform matrices", function()
	local connector1 = create()
	local connector2 = create()
	local connector3 = fromPointAxisNormal({ 0, 0, 0 }, { 0, 0, 1 }, { 0, 1, 0 }) -- Y axis as normal
	local obs = transformationBetween({}, connector1, connector2)
	local exp = { 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1 }
	expect(compareVectors(obs, exp)).toBe(true)
	obs = transformationBetween({}, connector1, connector3)
	exp = { 0, 1, 0, 0, -1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1 }
	expect(compareVectors(obs, exp)).toBe(true) -- connectors as taken from V1 cube
	local facecenter0 = fromPointAxisNormal({ 3, 0, 0 }, { 1, 0, 0 }, { 0, 0, 1 })
	local facecenter1 = fromPointAxisNormal({ -3, 0, 0 }, { -1, 0, 0 }, { 0, 0, 1 })
	local facecenter2 = fromPointAxisNormal({ 0, 3, 0 }, { 0, 1, 0 }, { 0, 0, 1 }) -- const facecenter3 = fromPointAxisNormal([0, -3, 0], [0, -1, 0], [0, 0, 1])
	-- const facecenter4 = fromPointAxisNormal([0, 0, 3], [0, 0, 1], [1, 0, 0])
	local facecenter5 = fromPointAxisNormal({ 0, 0, -3 }, { 0, 0, -1 }, { 1, 0, 0 })
	obs = transformationBetween({}, facecenter0, facecenter1) -- opposing faces
	exp = { -1, 0, 0, 0, 0, -1, 0, 0, 0, 0, 1, 0, 0, -3.6739405577555036e-16, 0, 1 }
	expect(compareVectors(obs, exp)).toBe(true)
	obs = transformationBetween({}, facecenter2, facecenter5) -- adjacent faces
	exp = { 0, 0, -1, 0, 0, -1, 0, 0, -1, 0, 0, 0, 3, -3, 0, 1 }
	expect(compareVectors(obs, exp)).toBe(true) -- test mirror option
	obs = transformationBetween({ mirror = true }, facecenter0, facecenter1) -- opposing faces
	exp = {
		1,
		-2.4492937051703357e-16,
		0,
		0,
		2.4492937051703357e-16,
		1,
		0,
		0,
		0,
		0,
		1,
		0,
		-6,
		7.347881115511007e-16,
		0,
		1,
	}
	expect(compareVectors(obs, exp)).toBe(true)
end)
