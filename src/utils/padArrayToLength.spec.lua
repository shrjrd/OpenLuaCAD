-- ROBLOX NOTE: no upstream
local JestGlobals = require("@DevPackages/JestGlobals")
local test, expect = JestGlobals.test, JestGlobals.expect

local padArrayToLength = require("./padArrayToLength")
test("padArrayToLength: test an array of the proper length is unchanged.", function()
	local srcArray = { 2, 3, 4 }
	local paddedArray = padArrayToLength(srcArray, nil, 3)
	expect(srcArray).toEqual(paddedArray)
end)
test("padArrayToLength: test an array that is too long is unchanged.", function()
	local srcArray = { 2, 3, 4, 5 }
	local paddedArray = padArrayToLength(srcArray, nil, 3)
	expect(srcArray).toEqual(paddedArray)
end)
test("padArrayToLength: test an array that is too short is padded.", function()
	local srcArray = { 2, 3 }
	local paddedArray = padArrayToLength(srcArray, 0, 3)
	expect(paddedArray).toEqual({ 2, 3, 0 })
end)
test("padArrayToLength: test a srcArray is unaffected by the padding.", function()
	local srcArray = { 2, 3 }
	padArrayToLength(srcArray, nil, 3)
	expect(srcArray).toEqual({ 2, 3 })
end)
