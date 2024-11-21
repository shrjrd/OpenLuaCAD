-- ROBLOX NOTE: no upstream
local JestGlobals = require("@DevPackages/JestGlobals")
local test, expect = JestGlobals.test, JestGlobals.expect

local translate, create
do
	local ref = require("./init")
	translate, create = ref.translate, ref.create
end
local compareVectors = require("../../../test/helpers/init").compareVectors
test("mat4. translate() called with three parameters should update a mat4 with correct values", function()
	local identityMatrix = { 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1 }
	local obs1 = create()
	local ret1 = translate(obs1, identityMatrix, { 0, 0, 0 })
	expect(compareVectors(obs1, { 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1 })).toBe(true)
	expect(compareVectors(ret1, { 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1 })).toBe(true)
	expect(obs1).toBe(ret1)
	local obs2 = create()
	local ret2 = translate(obs2, identityMatrix, { 2, 3, 6 })
	expect(compareVectors(obs2, { 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 2, 3, 6, 1 })).toBe(true)
	expect(compareVectors(ret2, { 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 2, 3, 6, 1 })).toBe(true)
	local x = 1
	local y = 5
	local z = 7
	local translationMatrix = { 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, x, y, z, 1 }
	local obs3 = create()
	local ret3 = translate(obs3, translationMatrix, { -2, -3, -6 })
	expect(compareVectors(obs3, { 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, -1, 2, 1, 1 })).toBe(true)
	expect(compareVectors(ret3, { 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, -1, 2, 1, 1 })).toBe(true)
	local w = 1
	local h = 3
	local d = 5
	local scaleMatrix = { w, 0, 0, 0, 0, h, 0, 0, 0, 0, d, 0, 0, 0, 0, 1 }
	local obs4 = create()
	local ret4 = translate(obs4, scaleMatrix, { 2, 3, 6 })
	expect(compareVectors(obs4, { 1, 0, 0, 0, 0, 3, 0, 0, 0, 0, 5, 0, 2, 9, 30, 1 })).toBe(true)
	expect(compareVectors(ret4, { 1, 0, 0, 0, 0, 3, 0, 0, 0, 0, 5, 0, 2, 9, 30, 1 })).toBe(true)
	local rotateZMatrix = { 0, -1, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1 }
	local obs5 = create()
	local ret5 = translate(obs5, rotateZMatrix, { 6, 4, 2 })
	expect(compareVectors(obs5, { 0, -1, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 4, -6, 2, 1 })).toBe(true) -- close to zero
	expect(compareVectors(ret5, { 0, -1, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 4, -6, 2, 1 })).toBe(true) -- close to zero
	-- special case where in and out are the same
	-- const obs6 = clone(rotateZMatrix)
	-- const ret6 = translate(obs6, [6, 4, 2], obs6)
	-- t.true(compareVectors(obs6, [0, -1, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 4, -6, 2, 1])) // close to zero
	-- t.true(compareVectors(ret6, [0, -1, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 4, -6, 2, 1])) // close to zero
end)
