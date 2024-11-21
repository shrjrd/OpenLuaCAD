-- ROBLOX NOTE: no upstream
local JestGlobals = require("@DevPackages/JestGlobals")
local test, expect = JestGlobals.test, JestGlobals.expect

local identity = require("./init").identity
local compareVectors = require("../../../test/helpers/init").compareVectors
test("mat4. identity() called with one parameters should update a mat4 with correct values", function()
	local obs1 = { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 }
	local ret1 = identity(obs1)
	expect(compareVectors(obs1, { 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1 })).toBe(true)
	expect(compareVectors(ret1, { 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1 })).toBe(true)
	expect(obs1).toBe(ret1)
end)
