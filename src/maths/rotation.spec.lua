-- ROBLOX NOTE: no upstream
local JestGlobals = require("@DevPackages/JestGlobals")
local test, expect = JestGlobals.test, JestGlobals.expect

local compareVectors = require("../../test/helpers/init").compareVectors
local constants, mat4, vec2, vec3
do
	local ref = require("./init")
	constants, mat4, vec2, vec3 = ref.constants, ref.mat4, ref.vec2, ref.vec3
end -- ALL POSITIVE ROTATIONS ARE CLOCKWISE
-- see https://webglfundamentals.org/webgl/lessons/webgl-3d-orthographic.html
-- IN A LEFT-HANDED COORDINATE SYSTEM
-- JSCAD IS RIGHT-HANDED COORDINATE SYSTEM
-- WHERE POSITIVE ROTATIONS ARE COUNTER-CLOCKWISE
-- identity matrices for comparisons
local rad90 = constants.TAU / 4 -- +90 degree rotation about X
local cwX90Matrix = {
	1,
	0,
	0,
	0,
	0,
	math.cos(rad90),
	math.sin(rad90),
	0,
	0,
	-math.sin(rad90),
	math.cos(rad90),
	0,
	0,
	0,
	0,
	1,
} -- +90 degree rotation about Y
local cwY90Matrix = {
	math.cos(rad90),
	0,
	-math.sin(rad90),
	0,
	0,
	1,
	0,
	0,
	math.sin(rad90),
	0,
	math.cos(rad90),
	0,
	0,
	0,
	0,
	1,
} -- +90 degree rotation about Z
local cwZ90Matrix = {
	math.cos(rad90),
	math.sin(rad90),
	0,
	0,
	-math.sin(rad90),
	math.cos(rad90),
	0,
	0,
	0,
	0,
	1,
	0,
	0,
	0,
	0,
	1,
}
test("rotation: mat4 rotation functions should produce expected results", function()
	local idn = mat4.create()
	local obs -- test matrices for rotating about X axis
	obs = mat4.fromXRotation(mat4.create(), rad90)
	expect(compareVectors(obs, cwX90Matrix)).toBe(true)
	obs = mat4.fromRotation(mat4.create(), rad90, { 1, 0, 0 })
	expect(compareVectors(obs, cwX90Matrix)).toBe(true)
	obs = mat4.rotateX(obs, idn, rad90)
	expect(compareVectors(obs, cwX90Matrix)).toBe(true) -- test matrices for rotating about Y axis
	obs = mat4.fromYRotation(mat4.create(), rad90)
	expect(compareVectors(obs, cwY90Matrix)).toBe(true)
	obs = mat4.fromRotation(mat4.create(), rad90, { 0, 1, 0 })
	expect(compareVectors(obs, cwY90Matrix)).toBe(true)
	obs = mat4.rotateY(obs, idn, rad90)
	expect(compareVectors(obs, cwY90Matrix)).toBe(true) -- test matrices for rotating about Z axis
	obs = mat4.fromZRotation(mat4.create(), rad90)
	expect(compareVectors(obs, cwZ90Matrix)).toBe(true)
	obs = mat4.fromRotation(mat4.create(), rad90, { 0, 0, 1 })
	expect(compareVectors(obs, cwZ90Matrix)).toBe(true)
	obs = mat4.rotateZ(obs, idn, rad90)
	expect(compareVectors(obs, cwZ90Matrix)).toBe(true)
end)
test("rotation: vec2 rotation functions should produce expected results", function()
	local onX = vec2.fromValues(3, 0)
	local onY = vec2.fromValues(0, 3)
	local matZ = mat4.fromZRotation(mat4.create(), rad90) -- transform
	local t1 = vec2.transform(vec2.create(), onX, matZ)
	expect(compareVectors(t1, { 0, 3 })).toBe(true)
	local t2 = vec2.transform(vec2.create(), onY, matZ)
	expect(compareVectors(t2, { -3, 0 })).toBe(true) -- rotate
	local r1 = vec2.rotate(vec2.create(), onX, vec2.create(), rad90)
	expect(compareVectors(r1, { 0, 3 })).toBe(true)
	local r2 = vec2.rotate(vec2.create(), onY, vec2.create(), rad90)
	expect(compareVectors(r2, { -3, 0 })).toBe(true) -- verify
	expect(compareVectors(t1, r1)).toBe(true)
	expect(compareVectors(t2, r2)).toBe(true)
end)
test("rotation: vec3 rotation functions should produce expected results", function()
	local onX = vec3.fromValues(3, 0, 0)
	local onY = vec3.fromValues(0, 3, 0)
	local onZ = vec3.fromValues(0, 0, 3)
	local matX = mat4.fromXRotation(mat4.create(), rad90)
	local matY = mat4.fromYRotation(mat4.create(), rad90)
	local matZ = mat4.fromZRotation(mat4.create(), rad90) -- transform
	local t1 = vec3.transform(vec3.create(), onX, matZ)
	expect(compareVectors(t1, { 0, 3, 0 })).toBe(true)
	local t2 = vec3.transform(vec3.create(), onY, matX)
	expect(compareVectors(t2, { 0, 0, 3 })).toBe(true)
	local t3 = vec3.transform(vec3.create(), onZ, matY)
	expect(compareVectors(t3, { 3, 0, 0 })).toBe(true) -- rotate
	local r1 = vec3.rotateZ(vec3.create(), onX, { 0, 0, 0 }, rad90)
	expect(compareVectors(r1, { 0, 3, 0 })).toBe(true)
	local r2 = vec3.rotateX(vec3.create(), onY, { 0, 0, 0 }, rad90)
	expect(compareVectors(r2, { 0, 0, 3 })).toBe(true)
	local r3 = vec3.rotateY(vec3.create(), onZ, { 0, 0, 0 }, rad90)
	expect(compareVectors(r3, { 3, 0, 0 })).toBe(true) -- verify
	expect(compareVectors(t1, r1)).toBe(true)
	expect(compareVectors(t2, r2)).toBe(true)
	expect(compareVectors(t3, r3)).toBe(true)
end)
