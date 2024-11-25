-- ROBLOX NOTE: no upstream
local Packages = game.ReplicatedStorage.Packages
local Number_EPSILON = 2.220446049250313e-16
local Number_MAX_VALUE = 1.7976931348623157e+308
local LuauPolyfill = require(Packages.LuauPolyfill)
local Array = LuauPolyfill.Array
local Boolean = LuauPolyfill.Boolean
local Number = LuauPolyfill.Number
local console = LuauPolyfill.console
local toPolygons = require("../../src/geometries/geom3/toPolygons") --require("../../src/core/CSGToOther").toPolygons
-- Compare two polygons together.
-- They are identical if they are composed with the same vertices in the same
-- relative order
-- todo: could be part of csg.js
-- todo: should simplify colinear vertices
-- @return true if both polygons are identical
local function comparePolygons(a, b)
	-- First find one matching vertice
	-- We try to find the first vertice of a inside b
	-- If there is no such vertice, then a != b
	if #a.vertices ~= #b.vertices or #a.vertices == 0 then
		return false
	end
	local start = a.vertices[
		1 --[[ ROBLOX adaptation: added 1 to array index ]]
	]
	local index = Array.findIndex(b.vertices, function(v)
		if not Boolean.toJSBoolean(v) then
			return false
		end
		return v._x == start._x and v._y == start._y and v._z == start._z
	end) --[[ ROBLOX CHECK: check if 'b.vertices' is an Array ]]
	if index == -1 then
		return false
	end -- Rearrange b vertices so that they start with the same vertex as a
	local vs = b.vertices
	if index ~= 0 then
		vs = Array.concat(
			Array.slice(b.vertices, index), --[[ ROBLOX CHECK: check if 'b.vertices' is an Array ]]
			Array.slice(b.vertices, 0, index) --[[ ROBLOX CHECK: check if 'b.vertices' is an Array ]]
		)
	end -- Compare now vertices one by one
	do
		local i = 0
		while
			i
			< #a.vertices --[[ ROBLOX CHECK: operator '<' works only if either both arguments are strings or both are a number ]]
		do
			if a.vertices[i]._x ~= vs[i]._x or a.vertices[i]._y ~= vs[i]._y or a.vertices[i]._z ~= vs[i]._z then
				return false
			end
			i += 1
		end
	end
	return true
end
-- a contains b if b polygons are also found in a
local function containsCSG(observed, expected)
	console.log("Observed: ", observed)
	console.log("Expected: ", expected)
	return Array.reduce(
		Array.map(toPolygons(observed), function(p)
			local found = false
			local bp = toPolygons(expected)
			do
				local i = 0
				while
					i
					< #bp --[[ ROBLOX CHECK: operator '<' works only if either both arguments are strings or both are a number ]]
				do
					if Boolean.toJSBoolean(comparePolygons(p, bp[i])) then
						found = true
						break
					end
					i += 1
				end
			end
			return found
		end), --[[ ROBLOX CHECK: check if 'toPolygons(observed)' is an Array ]]
		function(observed, expected)
			return if Boolean.toJSBoolean(observed) then expected else observed
		end
	)
end
local function assertSameGeometry(t, observed, expected, failMessage)
	if
		not Boolean.toJSBoolean(containsCSG(observed, expected))
		--or not Boolean.toJSBoolean(containsCSG(observed, expected))
	then
		failMessage = if failMessage == nil then "CSG do not have the same geometry" else failMessage
		t:fail(failMessage)
	else
		t:pass()
	end
end
local function simplifiedPolygon(polygon)
	local vertices = Array.map(polygon.vertices, function(vertex)
		return { vertex.pos._x, vertex.pos._y, vertex.pos._z }
	end) --[[ ROBLOX CHECK: check if 'polygon.vertices' is an Array ]]
	local plane = {
		normal = { polygon.plane.normal._x, polygon.plane.normal._y, polygon.plane.normal._z },
		w = polygon.plane.w,
	}
	return { positions = vertices, plane = plane, shared = polygon.shared }
end
local function simplifieSides(cag)
	local sides = Array.map(cag.sides, function(side)
		return { side.vertex0.pos._x, side.vertex0.pos._y, side.vertex1.pos._x, side.vertex1.pos._y }
	end) --[[ ROBLOX CHECK: check if 'cag.sides' is an Array ]]
	return Array.sort(sides) --[[ ROBLOX CHECK: check if 'sides' is an Array ]]
end
local function nearlyEquals(a, b, epsilon_: number?)
	local epsilon: number = if epsilon_ ~= nil then epsilon_ else 1
	if a == b then
		-- shortcut, also handles infinities and NaNs
		return true
	end
	local absA = math.abs(a)
	local absB = math.abs(b)
	local diff = math.abs(a - b)
	if Boolean.toJSBoolean(Number.isNaN(diff)) then
		return false
	end
	if
		a == 0
		or b == 0
		or diff < Number_EPSILON --[[ ROBLOX CHECK: operator '<' works only if either both arguments are strings or both are a number ]]
	then
		-- a or b is zero or both are extremely close to it
		-- relative error is less meaningful here
		if
			diff
			> epsilon * Number_EPSILON --[[ ROBLOX CHECK: operator '>' works only if either both arguments are strings or both are a number ]]
		then
			return false
		end
	end -- use relative error
	if
		diff / math.min(absA + absB, Number_MAX_VALUE)
		> epsilon --[[ ROBLOX CHECK: operator '>' works only if either both arguments are strings or both are a number ]]
	then
		return false
	end
	return true
end
local function CAGNearlyEquals(observed, expected, precision)
	if #observed.sides ~= #expected.sides then
		return false
	end
	if observed.isCanonicalized ~= expected.isCanonicalized then
		return false
	end
	local obsSides = simplifieSides(observed)
	local expSides = simplifieSides(expected)
	do
		local i = 0
		while
			i
			< #obsSides --[[ ROBLOX CHECK: operator '<' works only if either both arguments are strings or both are a number ]]
		do
			do
				local j = 0
				while
					j
					< obsSides[i].length --[[ ROBLOX CHECK: operator '<' works only if either both arguments are strings or both are a number ]]
				do
					if not Boolean.toJSBoolean(nearlyEquals(obsSides[i][j], expSides[i][j], precision)) then
						return false
					end
					j += 1
				end
			end
			i += 1
		end
	end
	return true
end
return {
	assertSameGeometry = assertSameGeometry,
	comparePolygons = comparePolygons,
	simplifiedPolygon = simplifiedPolygon,
	simplifieSides = simplifieSides,
	CAGNearlyEquals = CAGNearlyEquals,
}
