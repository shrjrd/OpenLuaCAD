-- ROBLOX NOTE: no upstream
local JestGlobals = require("@DevPackages/JestGlobals")
local test, expect = JestGlobals.test, JestGlobals.expect

local geom3 = require("../../geometries").geom3
local cube, torus
do
	local ref = require("../../primitives")
	cube, torus = ref.cube, ref.torus
end
local scission, union
do
	local ref = require("./init")
	scission, union = ref.scission, ref.union
end
test("scission: scission of one or more geom3 objects produces expected geometry", function()
	local geometry1 = geom3.create()
	local geometry2 = cube({ size = 5 })
	local geometry3 = cube({ size = 5, center = { 5, 5, 5 } }) -- scission of one object
	local result1 = scission(geometry1)
	expect(#result1).toBe(0) -- empty geometry, no pieces
	-- scission of three objects
	local result2 = scission(geometry1, geometry2, geometry3)
	expect(#result2).toBe(3)
	expect(result2[
		1 --[[ ROBLOX adaptation: added 1 to array index ]]
	].length).toBe(0)
	expect(result2[
		2 --[[ ROBLOX adaptation: added 1 to array index ]]
	].length).toBe(1)
	expect(function()
		return geom3.validate(result2[
			2 --[[ ROBLOX adaptation: added 1 to array index ]]
		][
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		])
	end)["not"].toThrow()
	expect(result2[
		3 --[[ ROBLOX adaptation: added 1 to array index ]]
	].length).toBe(1)
	expect(function()
		return geom3.validate(result2[
			3 --[[ ROBLOX adaptation: added 1 to array index ]]
		][
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		])
	end)["not"].toThrow()
end)
test("scission: scission of complex geom3 produces expected geometry", function()
	local geometry1 = torus({ outerRadius = 40, innerRadius = 5, outerSegments = 16, innerSegments = 16 })
	local geometry2 = torus({ outerRadius = 20, innerRadius = 5, outerSegments = 16, innerSegments = 16 })
	local geometry3 = union(geometry1, geometry2)
	local pc1 = geom3.toPolygons(geometry1).length
	local pc2 = geom3.toPolygons(geometry2).length
	local pc3 = geom3.toPolygons(geometry3).length
	expect(pc1).toBe(512)
	expect(pc2).toBe(512)
	expect(pc3).toBe(512) -- due to retessellate
	local result1 = scission(geometry3)
	expect(#result1).toBe(2)
	t.notThrows:skip(function()
		return geom3.validate(result1[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		])
	end)
	t.notThrows:skip(function()
		return geom3.validate(result1[
			2 --[[ ROBLOX adaptation: added 1 to array index ]]
		])
	end)
	local rc1 = geom3.toPolygons(result1[
		1 --[[ ROBLOX adaptation: added 1 to array index ]]
	]).length
	local rc2 = geom3.toPolygons(result1[
		2 --[[ ROBLOX adaptation: added 1 to array index ]]
	]).length
	expect(rc1).toBe(256)
	expect(rc2).toBe(256)
end)
