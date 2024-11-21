-- ROBLOX NOTE: no upstream
local JestGlobals = require("@DevPackages/JestGlobals")
local test, expect = JestGlobals.test, JestGlobals.expect

local TAU = require("../constants").TAU
local vec3 = require("../vec3/init")
local create, invert, fromTranslation, fromXRotation
do
	local ref = require("./init")
	create, invert, fromTranslation, fromXRotation = ref.create, ref.invert, ref.fromTranslation, ref.fromXRotation
end
local compareVectors = require("../../../test/helpers/init").compareVectors
test("mat4. invert() translate ", function()
	local matrix = fromTranslation(create(), { 10, 10, 0 })
	local matrixInv = invert(create(), matrix)
	local vec1 = { 0, 0, 0 }
	local vec2 = vec3.transform({ 0, 0, 0 }, vec1, matrix)
	expect(compareVectors(vec2, { 10, 10, 0 })).toBe(true)
	local vec2back = vec3.transform({ 0, 0, 0 }, vec2, matrixInv)
	expect(compareVectors(vec2back, vec1)).toBe(true)
end)
test("mat4. invert() rotate ", function()
	local matrix = fromXRotation(create(), TAU / 4)
	local matrixInv = invert(create(), matrix)
	local vec1 = { 10, 10, 10 }
	local vec2 = vec3.transform({ 0, 0, 0 }, vec1, matrix)
	expect(compareVectors(vec2, { 10, -10, 10 })).toBe(true)
	local vec2back = vec3.transform({ 0, 0, 0 }, vec2, matrixInv)
	expect(compareVectors(vec2back, vec1)).toBe(true)
end)
