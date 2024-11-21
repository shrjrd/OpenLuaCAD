-- ROBLOX NOTE: no upstream
local JestGlobals = require("@DevPackages/JestGlobals")
local test, expect = JestGlobals.test, JestGlobals.expect

local TAU = require("../constants").TAU
local isOnlyTransformScale, create, fromTranslation, fromTaitBryanRotation, fromScaling, invert, multiply
do
	local ref = require("./init")
	isOnlyTransformScale, create, fromTranslation, fromTaitBryanRotation, fromScaling, invert, multiply =
		ref.isOnlyTransformScale,
		ref.create,
		ref.fromTranslation,
		ref.fromTaitBryanRotation,
		ref.fromScaling,
		ref.invert,
		ref.multiply
end
test("mat4. isOnlyTransformScale() should return true for right angles", function()
	local someRotation = fromTaitBryanRotation(create(), TAU / 2, 0, 0)
	expect(isOnlyTransformScale(someRotation)).toBe(true)
	expect(isOnlyTransformScale(invert(create(), someRotation))).toBe(true)
	someRotation = fromTaitBryanRotation(create(), 0, 0, 0)
	expect(isOnlyTransformScale(someRotation)).toBe(true)
end)
test("mat4. isOnlyTransformScale() should return correct values", function()
	local identity = create() -- identity matrix
	expect(isOnlyTransformScale(identity)).toBe(true)
	local someTranslation = fromTranslation(create(), { 5, 5, 5 })
	expect(isOnlyTransformScale(someTranslation)).toBe(true)
	local someScaling = fromScaling(create(), { 5, 5, 5 })
	expect(isOnlyTransformScale(someScaling)).toBe(true)
	expect(isOnlyTransformScale(invert(create(), someScaling))).toBe(true)
	local combined = multiply(create(), someTranslation, someScaling)
	expect(isOnlyTransformScale(combined)).toBe(true)
end)
