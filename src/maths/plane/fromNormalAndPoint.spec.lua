-- ROBLOX NOTE: no upstream
local JestGlobals = require("@DevPackages/JestGlobals")
local test, expect = JestGlobals.test, JestGlobals.expect

local fromNormalAndPoint, create
do
	local ref = require("./init")
	fromNormalAndPoint, create = ref.fromNormalAndPoint, ref.create
end
local compareVectors = require("../../../test/helpers/init").compareVectors
test("plane. fromNormalAndPoint() should return a new plant with correct values", function()
	local obs1 = fromNormalAndPoint(create(), { 5, 0, 0 }, { 0, 0, 0 })
	expect(compareVectors(obs1, { 1, 0, 0, 0 })).toBe(true)
	local obs2 = fromNormalAndPoint(obs1, { 0, 0, 5 }, { 5, 5, 5 })
	expect(compareVectors(obs2, { 0, 0, 1, 5 })).toBe(true)
end)
