-- ROBLOX NOTE: no upstream
local JestGlobals = require("@DevPackages/JestGlobals")
local test, expect = JestGlobals.test, JestGlobals.expect

local geom2, geom3, path2, poly3
do
	local ref = require("../geometries")
	geom2, geom3, path2, poly3 = ref.geom2, ref.geom3, ref.path2, ref.poly3
end
local colorize = require("./init").colorize
test("color (rgb on objects)", function()
	local obj1 = {}
	local obj2 = { { id = "a" }, { id = "b" } }
	local obs = colorize({ 1, 0, 0 }, obj1, obj2)
	local exp1 = { color = { 1, 0, 0, 1 } }
	local exp2 = { id = "a", color = { 1, 0, 0, 1 } }
	expect(#obs).toBe(3)
	expect(obs[
		1 --[[ ROBLOX adaptation: added 1 to array index ]]
	]).toEqual(exp1)
	expect(obs[
		2 --[[ ROBLOX adaptation: added 1 to array index ]]
	]).toEqual(exp2)
	local obs3 = colorize({ 1, 0, 0 }, obj1)
	local exp3 = { color = { 1, 0, 0, 1 } }
	expect(obs3).toEqual(exp3)
end)
test("color (rgba on objects)", function()
	local obj1 = {}
	local obj2 = { { id = "a" }, { id = "b" } }
	local obs = colorize({ 1, 1, 0.5, 0.8 }, obj1, obj2)
	local exp1 = { color = { 1, 1, 0.5, 0.8 } }
	local exp2 = { id = "a", color = { 1, 1, 0.5, 0.8 } }
	expect(#obs).toBe(3)
	expect(obs[
		1 --[[ ROBLOX adaptation: added 1 to array index ]]
	]).toEqual(exp1)
	expect(obs[
		2 --[[ ROBLOX adaptation: added 1 to array index ]]
	]).toEqual(exp2)
end)
test("color (rgba on geometry)", function()
	local obj0 = geom2.fromPoints({ { 0, 0 }, { 1, 0 }, { 0, 1 } })
	local obj1 = geom3.fromPoints({ { { 0, 0, 0 }, { 1, 0, 0 }, { 1, 0, 1 } } })
	local obj2 = path2.fromPoints({ closed = true }, { { 0, 0 }, { 1, 0 }, { 1, 1 } })
	local obj3 = poly3.create({ { 0, 0, 0 }, { 1, 0, 0 }, { 1, 1, 0 } })
	local obs = colorize({ 1, 1, 0.5, 0.8 }, obj0, obj1, obj2, obj3)
	expect(#obs).toBe(4)
	expect(obj0)["not"].toBe(obs[
		1 --[[ ROBLOX adaptation: added 1 to array index ]]
	])
	expect(obs[
		1 --[[ ROBLOX adaptation: added 1 to array index ]]
	].color).toEqual({ 1, 1, 0.5, 0.8 })
	expect(obj1)["not"].toBe(obs[
		2 --[[ ROBLOX adaptation: added 1 to array index ]]
	])
	expect(obs[
		2 --[[ ROBLOX adaptation: added 1 to array index ]]
	].color).toEqual({ 1, 1, 0.5, 0.8 })
	expect(obj2)["not"].toBe(obs[
		3 --[[ ROBLOX adaptation: added 1 to array index ]]
	])
	expect(obs[
		3 --[[ ROBLOX adaptation: added 1 to array index ]]
	].color).toEqual({ 1, 1, 0.5, 0.8 })
	expect(obj3)["not"].toBe(obs[
		4 --[[ ROBLOX adaptation: added 1 to array index ]]
	])
	expect(obs[
		4 --[[ ROBLOX adaptation: added 1 to array index ]]
	].color).toEqual({ 1, 1, 0.5, 0.8 })
end)
test("color (returns new object)", function()
	local obj0 = geom2.fromPoints({ { 0, 0 }, { 1, 0 }, { 0, 1 } }) -- const obj1 = geom2.fromPoints([[0, 0], [1, 0], [0, 1]])
	-- const obj2 = geom2.fromPoints([[0, 0], [1, 0], [0, 1]])
	local obj3 = geom2.fromPoints({ { 0, 0 }, { 1, 0 }, { 0, 1 } })
	local obs = colorize({ 1, 1, 1, 0.8 }, obj0, obj3)
	expect(obj0)["not"].toBe(obs[
		1 --[[ ROBLOX adaptation: added 1 to array index ]]
	])
	expect(obs[
		1 --[[ ROBLOX adaptation: added 1 to array index ]]
	].color).toEqual({ 1, 1, 1, 0.8 })
	expect(obj0.color).toBe(nil)
	expect(obj3)["not"].toBe(obs[
		2 --[[ ROBLOX adaptation: added 1 to array index ]]
	])
	expect(obs[
		2 --[[ ROBLOX adaptation: added 1 to array index ]]
	].color).toEqual({ 1, 1, 1, 0.8 })
	expect(obj3.color).toBe(nil)
end)
