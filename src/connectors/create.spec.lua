-- ROBLOX NOTE: no upstream
local JestGlobals = require("@DevPackages/JestGlobals")
local test, expect = JestGlobals.test, JestGlobals.expect

local create = require("./init").create
local compareVectors = require("../../test/helpers").compareVectors
test("connector: create() should return a connector with initial values", function()
	local obs = create()
	local point = { 0, 0, 0 }
	local axis = { 0, 0, 1 }
	local normal = { 1, 0, 0 }
	expect(compareVectors(obs.point, point)).toBe(true)
	expect(compareVectors(obs.axis, axis)).toBe(true)
	expect(compareVectors(obs.normal, normal)).toBe(true)
end)
