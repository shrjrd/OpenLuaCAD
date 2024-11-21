-- ROBLOX NOTE: no upstream
local JestGlobals = require("@DevPackages/JestGlobals")
local test, expect = JestGlobals.test, JestGlobals.expect

local isIdentity, create, fromTranslation
do
	local ref = require("./init")
	isIdentity, create, fromTranslation = ref.isIdentity, ref.create, ref.fromTranslation
end
test("mat4. isIdentity() should return correct values", function()
	local identity = create() -- identity matrix
	expect(isIdentity(identity)).toBe(true)
	local notidentity = fromTranslation(create(), { 5, 5, 5 })
	expect(isIdentity(notidentity)).toBe(false)
end)
