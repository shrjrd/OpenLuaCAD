-- ROBLOX NOTE: no upstream
local JestGlobals = require("@DevPackages/JestGlobals")
local test, expect = JestGlobals.test, JestGlobals.expect

local create = require("./init").create
local compareVectors = require("../../../test/helpers/init").compareVectors
test("mat4. create() should return a mat4 with initial values", function()
	local obs = create() -- identity matrix
	expect(compareVectors(obs, { 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1 })).toBe(true)
end)
