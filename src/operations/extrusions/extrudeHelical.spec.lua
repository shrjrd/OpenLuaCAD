-- ROBLOX NOTE: no upstream
local Packages = game.ReplicatedStorage.Packages
local LuauPolyfill = require(Packages.LuauPolyfill)
local Array = LuauPolyfill.Array
local JestGlobals = require("@DevPackages/JestGlobals")
local test, expect = JestGlobals.test, JestGlobals.expect

local TAU = require("../../maths/constants").TAU
local geom2, geom3
do
	local ref = require("../../geometries")
	geom2, geom3 = ref.geom2, ref.geom3
end
local circle = require("../../primitives").circle
local extrudeHelical = require("./init").extrudeHelical
test("extrudeHelical: (defaults) extruding of a geom2 produces an expected geom3", function()
	local geometry2 = geom2.fromPoints({ { 10, 8 }, { 10, -8 }, { 26, -8 }, { 26, 8 } })
	local geometry3 = extrudeHelical({}, geometry2)
	expect(function()
		return geom3.validate(geometry3)
	end)["not"].toThrow()
end)
test("extrudeHelical: (defaults) extruding of a circle produces an expected geom3", function()
	local geometry2 = circle({ size = 3, center = { 10, 0 } })
	local geometry3 = extrudeHelical({}, geometry2)
	expect(function()
		return geom3.validate(geometry3)
	end)["not"].toThrow()
end)
test("extrudeHelical: (angle) extruding of a circle produces an expected geom3", function()
	local maxRevolutions = 10
	local geometry2 = circle({ size = 3, center = { 10, 0 } })
	for _, index in Array.concat({}, Array.spread(Array(maxRevolutions):keys())) do
		-- also test negative angles
		local geometry3 = extrudeHelical({ angle = TAU * (index - maxRevolutions / 2) }, geometry2)
		expect(function()
			return geom3.validate(geometry3)
		end)["not"].toThrow()
	end
end)
test("extrudeHelical: (pitch) extruding of a circle produces an expected geom3", function()
	local startPitch = -10
	local geometry2 = circle({ size = 3, center = { 10, 0 } })
	for _, index in Array.concat({}, Array.spread(Array(20):keys())) do
		-- also test negative pitches
		local geometry3 = extrudeHelical({ pitch = startPitch + index }, geometry2)
		expect(function()
			return geom3.validate(geometry3)
		end)["not"].toThrow()
	end
end)
test("extrudeHelical: (endRadiusOffset) extruding of a circle produces an expected geom3", function()
	local startOffset = -5
	local geometry2 = circle({ size = 3, center = { 10, 0 } })
	for _, index in Array.concat({}, Array.spread(Array(10):keys())) do
		-- also test negative pitches
		local geometry3 = extrudeHelical({ endRadiusOffset = startOffset + index }, geometry2)
		expect(function()
			return geom3.validate(geometry3)
		end)["not"].toThrow()
	end
end)
test("extrudeHelical: (segments) extruding of a circle produces an expected geom3", function()
	local startSegments = 3
	local geometry2 = circle({ size = 3, center = { 10, 0 } })
	for _, index in Array.concat({}, Array.spread(Array(30):keys())) do
		-- also test negative pitches
		local geometry3 = extrudeHelical({ segments = startSegments + index }, geometry2)
		expect(function()
			return geom3.validate(geometry3)
		end)["not"].toThrow()
	end
end)
