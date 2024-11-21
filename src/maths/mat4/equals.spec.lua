-- ROBLOX NOTE: no upstream
local JestGlobals = require("@DevPackages/JestGlobals")
local test, expect = JestGlobals.test, JestGlobals.expect

local equals = require("./equals")
test("vec3. equals() should return correct booleans", function()
	local veca = { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 }
	local vecb = { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 }
	expect(equals(veca, vecb)).toBe(true)
	local vecb0 = { 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 }
	expect(equals(veca, vecb0)).toBe(false)
	local vecb1 = { 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 }
	expect(equals(veca, vecb1)).toBe(false)
	local vecb2 = { 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 }
	expect(equals(veca, vecb2)).toBe(false)
	local vecb3 = { 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 }
	expect(equals(veca, vecb3)).toBe(false)
	local vecb4 = { 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 }
	expect(equals(veca, vecb4)).toBe(false)
	local vecb5 = { 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 }
	expect(equals(veca, vecb5)).toBe(false)
	local vecb6 = { 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0 }
	expect(equals(veca, vecb6)).toBe(false)
	local vecb7 = { 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0 }
	expect(equals(veca, vecb7)).toBe(false)
	local vecb8 = { 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0 }
	expect(equals(veca, vecb8)).toBe(false)
	local vecb9 = { 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0 }
	expect(equals(veca, vecb9)).toBe(false)
	local vecb10 = { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0 }
	expect(equals(veca, vecb10)).toBe(false)
	local vecb11 = { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0 }
	expect(equals(veca, vecb11)).toBe(false)
	local vecb12 = { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0 }
	expect(equals(veca, vecb12)).toBe(false)
	local vecb13 = { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0 }
	expect(equals(veca, vecb13)).toBe(false)
	local vecb14 = { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0 }
	expect(equals(veca, vecb14)).toBe(false)
	local vecb15 = { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1 }
	expect(equals(veca, vecb15)).toBe(false)
end)
