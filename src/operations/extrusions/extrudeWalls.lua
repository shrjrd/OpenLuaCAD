-- ROBLOX NOTE: no upstream

local LuauPolyfill = require("@Packages/LuauPolyfill")
local Array = LuauPolyfill.Array
local Boolean = LuauPolyfill.Boolean
local Number = LuauPolyfill.Number
local EPS = require("../../maths/constants").EPS
local vec3 = require("../../maths/vec3")
local poly3 = require("../../geometries/poly3")
local slice = require("./slice") -- https://en.wikipedia.org/wiki/Greatest_common_divisor#Using_Euclid's_algorithm
local function gcd(a, b)
	if a == b then
		return a
	end
	if
		a < b --[[ ROBLOX CHECK: operator '<' works only if either both arguments are strings or both are a number ]]
	then
		return gcd(b, a)
	end
	if b == 1 then
		return 1
	end
	if b == 0 then
		return a
	end
	return gcd(b, a % b)
end
local function lcm(a, b)
	return a * b / gcd(a, b)
end -- Return a set of edges that encloses the same area by splitting
-- the given edges to have newlength total edges.
local function repartitionEdges(newlength, edges)
	-- NOTE: This implementation splits each edge evenly.
	local multiple = newlength / #edges
	if multiple == 1 then
		return edges
	end
	local divisor = vec3.fromValues(multiple, multiple, multiple)
	local newEdges = {}
	Array.forEach(edges, function(edge)
		local increment = vec3.subtract(
			vec3.create(),
			edge[
				2 --[[ ROBLOX adaptation: added 1 to array index ]]
			],
			edge[
				1 --[[ ROBLOX adaptation: added 1 to array index ]]
			]
		)
		vec3.divide(increment, increment, divisor) -- repartition the edge
		local prev = edge[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		]
		do
			local i = 1
			while
				i
				<= multiple --[[ ROBLOX CHECK: operator '<=' works only if either both arguments are strings or both are a number ]]
			do
				local next_ = vec3.add(vec3.create(), prev, increment)
				table.insert(newEdges, { prev, next_ }) --[[ ROBLOX CHECK: check if 'newEdges' is an Array ]]
				prev = next_
				i += 1
			end
		end
	end) --[[ ROBLOX CHECK: check if 'edges' is an Array ]]
	return newEdges
end
local EPSAREA = EPS * EPS / 2 * math.sin(math.pi / 3)
--[[
 * Extrude (build) walls between the given slices.
 * Each wall consists of two triangles, which may be invalid if slices are overlapping.
 ]]
local function extrudeWalls(slice0, slice1)
	local edges0 = slice.toEdges(slice0)
	local edges1 = slice.toEdges(slice1)
	if #edges0 ~= #edges1 then
		-- different shapes, so adjust one or both to the same number of edges
		local newlength = lcm(#edges0, #edges1)
		if newlength ~= #edges0 then
			edges0 = repartitionEdges(newlength, edges0)
		end
		if newlength ~= #edges1 then
			edges1 = repartitionEdges(newlength, edges1)
		end
	end
	local walls = {}
	Array.forEach(edges0, function(edge0, i)
		local edge1 = edges1[i]
		local poly0 = poly3.create({
			edge0[
				1 --[[ ROBLOX adaptation: added 1 to array index ]]
			],
			edge0[
				2 --[[ ROBLOX adaptation: added 1 to array index ]]
			],
			edge1[
				2 --[[ ROBLOX adaptation: added 1 to array index ]]
			],
		})
		local poly0area = poly3.measureArea(poly0)
		if
			Boolean.toJSBoolean((function()
				local ref = Number.isFinite(poly0area)
				return if Boolean.toJSBoolean(ref)
					then poly0area
						> EPSAREA --[[ ROBLOX CHECK: operator '>' works only if either both arguments are strings or both are a number ]]
					else ref
			end)())
		then
			table.insert(walls, poly0) --[[ ROBLOX CHECK: check if 'walls' is an Array ]]
		end
		local poly1 = poly3.create({
			edge0[
				1 --[[ ROBLOX adaptation: added 1 to array index ]]
			],
			edge1[
				2 --[[ ROBLOX adaptation: added 1 to array index ]]
			],
			edge1[
				1 --[[ ROBLOX adaptation: added 1 to array index ]]
			],
		})
		local poly1area = poly3.measureArea(poly1)
		if
			Boolean.toJSBoolean((function()
				local ref = Number.isFinite(poly1area)
				return if Boolean.toJSBoolean(ref)
					then poly1area
						> EPSAREA --[[ ROBLOX CHECK: operator '>' works only if either both arguments are strings or both are a number ]]
					else ref
			end)())
		then
			table.insert(walls, poly1) --[[ ROBLOX CHECK: check if 'walls' is an Array ]]
		end
	end) --[[ ROBLOX CHECK: check if 'edges0' is an Array ]]
	return walls
end
return extrudeWalls
