-- ROBLOX NOTE: no upstream

local LuauPolyfill = require("@Packages/LuauPolyfill")
local Array = LuauPolyfill.Array
local JestGlobals = require("@DevPackages/JestGlobals")
local test, expect = JestGlobals.test, JestGlobals.expect

local fromPointsConvex, validate
do
	local ref = require("./init")
	fromPointsConvex, validate = ref.fromPointsConvex, ref.validate
end
test("fromPointsConvex (uniquePoints)", function()
	local out = {}
	local x = -9
	while
		x
		<= 9 --[[ ROBLOX CHECK: operator '<=' works only if either both arguments are strings or both are a number ]]
	do
		local y = -9
		while
			y
			<= 9 --[[ ROBLOX CHECK: operator '<=' works only if either both arguments are strings or both are a number ]]
		do
			local z = -9
			while
				z
				<= 9 --[[ ROBLOX CHECK: operator '<=' works only if either both arguments are strings or both are a number ]]
			do
				if
					x * x + y * y + z * z
					<= 96 --[[ ROBLOX CHECK: operator '<=' works only if either both arguments are strings or both are a number ]]
				then
					table.insert(out, { x, y, z }) --[[ ROBLOX CHECK: check if 'out' is an Array ]]
				end
				z += 1
			end
			y += 1
		end
		x += 1
	end
	local obs = fromPointsConvex(out)
	validate(obs)
	expect(#obs.polygons).toBe(170)
	expect(Array.every(obs.polygons, function(f)
		return Array.indexOf({ 3, 4, 8, 9 }, #f.vertices) ~= -1
	end) --[[ ROBLOX CHECK: check if 'obs.polygons' is an Array ]]).toBe(true)
	local c = { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 }
	Array.forEach(obs.polygons, function(f)
		local ref = c[#f.vertices]
		c[#f.vertices] += 1
		return ref
	end) --[[ ROBLOX CHECK: check if 'obs.polygons' is an Array ]]
	expect(c[
		4 --[[ ROBLOX adaptation: added 1 to array index ]]
	]).toBe(120)
	expect(c[
		5 --[[ ROBLOX adaptation: added 1 to array index ]]
	]).toBe(24)
	expect(c[
		9 --[[ ROBLOX adaptation: added 1 to array index ]]
	]).toBe(18)
	expect(c[
		10 --[[ ROBLOX adaptation: added 1 to array index ]]
	]).toBe(8)
	local edges2 = 336 * 2
	Array.forEach(obs.polygons, function(f)
		edges2 -= #f.vertices
		return edges2
	end) --[[ ROBLOX CHECK: check if 'obs.polygons' is an Array ]]
	expect(edges2).toBe(0)
end)
