-- ROBLOX NOTE: no upstream
local JestGlobals = require("@DevPackages/JestGlobals")
local test, expect = JestGlobals.test, JestGlobals.expect

local normalize, fromValues
do
	local ref = require("./init")
	normalize, fromValues = ref.normalize, ref.fromValues
end
local compareVectors = require("../../../test/helpers/init").compareVectors
test("vec3. normalize() called with two parameters should update a vec3 with correct values", function()
	local obs1 = fromValues(0, 0, 0)
	local ret1 = normalize(obs1, { 0, 0, 0 })
	expect(compareVectors(obs1, { 0, 0, 0 })).toBe(true)
	expect(compareVectors(ret1, { 0, 0, 0 })).toBe(true)
	local obs2 = fromValues(0, 0, 0)
	local ret2 = normalize(obs2, { 1, 2, 3 })
	expect(compareVectors(obs2, { 0.2672612419124244, 0.5345224838248488, 0.8017837257372732 })).toBe(true)
	expect(compareVectors(ret2, { 0.2672612419124244, 0.5345224838248488, 0.8017837257372732 })).toBe(true)
	local obs3 = fromValues(0, 0, 0)
	local ret3 = normalize(obs3, { -1, -2, -3 })
	expect(compareVectors(obs3, { -0.2672612419124244, -0.5345224838248488, -0.8017837257372732 })).toBe(true)
	expect(compareVectors(ret3, { -0.2672612419124244, -0.5345224838248488, -0.8017837257372732 })).toBe(true)
	local obs4 = fromValues(0, 0, 0)
	local ret4 = normalize(obs4, { -1, 2, -3 })
	expect(compareVectors(obs4, { -0.2672612419124244, 0.5345224838248488, -0.8017837257372732 })).toBe(true)
	expect(compareVectors(ret4, { -0.2672612419124244, 0.5345224838248488, -0.8017837257372732 })).toBe(true)
	local obs5 = fromValues(0, 0, 0)
	local ret5 = normalize(obs5, { 0.5, 1.5, 0.5 })
	expect(compareVectors(obs5, { 0.30151134457776363, 0.9045340337332909, 0.30151134457776363 })).toBe(true)
	expect(compareVectors(ret5, { 0.30151134457776363, 0.9045340337332909, 0.30151134457776363 })).toBe(true)
	local obs6 = fromValues(0, 0, 0)
	local ret6 = normalize(obs6, { 0.5, 0.5, 0.5 })
	expect(compareVectors(obs6, { 0.5773502691896258, 0.5773502691896258, 0.5773502691896258 })).toBe(true)
	expect(compareVectors(ret6, { 0.5773502691896258, 0.5773502691896258, 0.5773502691896258 })).toBe(true)
end)