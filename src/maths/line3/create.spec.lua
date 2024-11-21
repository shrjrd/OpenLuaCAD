-- ROBLOX NOTE: no upstream
local JestGlobals = require("@DevPackages/JestGlobals")
local test, expect = JestGlobals.test, JestGlobals.expect

local create = require("./init").create
local compareVectors = require("../../../test/helpers/init").compareVectors
test("line3: create() should return a line3 with initial values", function()
	local obs = create()
	expect(compareVectors(
		obs[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		],
		{ 0, 0, 0 }
	)).toBe(true)
	expect(compareVectors(
		obs[
			2 --[[ ROBLOX adaptation: added 1 to array index ]]
		],
		{ 0, 0, 1 }
	)).toBe(true)
end)
