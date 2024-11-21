-- ROBLOX NOTE: no upstream
local JestGlobals = require("@DevPackages/JestGlobals")
local test, expect = JestGlobals.test, JestGlobals.expect

local cross = require("./init").cross
local compareVectors = require("../../../test/helpers/init").compareVectors
test("vec2. cross() called with three parameters should update a vec2 with correct values", function()
	local obs1 = { 0, 0, 0 }
	local ret1 = cross(obs1, { 0, 0 }, { 0, 0 })
	expect(compareVectors(obs1, { 0, 0, 0 })).toBe(true)
	expect(compareVectors(ret1, { 0, 0, 0 })).toBe(true)
	local obs2 = { 0, 0, 0 }
	local ret2 = cross(obs2, { 5, 5 }, { 10, 20 })
	expect(compareVectors(obs2, { 0, 0, 50 })).toBe(true)
	expect(compareVectors(ret2, { 0, 0, 50 })).toBe(true)
	local obs3 = { 0, 0, 0 }
	local ret3 = cross(obs3, { 5, 5 }, { 10, -20 })
	expect(compareVectors(obs3, { 0, 0, -150 })).toBe(true)
	expect(compareVectors(ret3, { 0, 0, -150 })).toBe(true)
	local obs4 = { 0, 0, 0 }
	local ret4 = cross(obs4, { 5, 5 }, { -10, -20 })
	expect(compareVectors(obs4, { 0, 0, -50 })).toBe(true)
	expect(compareVectors(ret4, { 0, 0, -50 })).toBe(true)
	local obs5 = { 0, 0, 0 }
	local ret5 = cross(obs5, { 5, 5 }, { -10, 20 })
	expect(compareVectors(obs5, { 0, 0, 150 })).toBe(true)
	expect(compareVectors(ret5, { 0, 0, 150 })).toBe(true)
	local obs6 = { 0, 0, 0 }
	local ret6 = cross(obs6, { 5, 5 }, { 10, 20 })
	expect(compareVectors(obs6, { 0, 0, 50 })).toBe(true)
	expect(compareVectors(ret6, { 0, 0, 50 })).toBe(true)
	local obs7 = { 0, 0, 0 }
	local ret7 = cross(obs7, { 5, 5 }, { 10, -20 })
	expect(compareVectors(obs7, { 0, 0, -150 })).toBe(true)
	expect(compareVectors(ret7, { 0, 0, -150 })).toBe(true)
	local obs8 = { 0, 0, 0 }
	local ret8 = cross(obs8, { 5, 5 }, { -10, -20 })
	expect(compareVectors(obs8, { 0, 0, -50 })).toBe(true)
	expect(compareVectors(ret8, { 0, 0, -50 })).toBe(true)
	local obs9 = { 0, 0, 0 }
	local ret9 = cross(obs9, { 5, 5 }, { -10, 20 })
	expect(compareVectors(obs9, { 0, 0, 150 })).toBe(true)
	expect(compareVectors(ret9, { 0, 0, 150 })).toBe(true)
end)
