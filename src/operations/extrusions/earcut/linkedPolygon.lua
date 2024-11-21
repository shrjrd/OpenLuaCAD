-- ROBLOX NOTE: no upstream
local Packages = game.ReplicatedStorage.Packages
local LuauPolyfill = require(Packages.LuauPolyfill)
local Boolean = LuauPolyfill.Boolean
local Node, insertNode, removeNode
do
	local ref = require("./linkedList")
	Node, insertNode, removeNode = ref.Node, ref.insertNode, ref.removeNode
end
local area = require("./triangle").area
--[[
 * check if two points are equal
 ]]
local function equals(p1, p2)
	return p1.x == p2.x and p1.y == p2.y
end

local function signedArea(data, start, end_, dim)
	local sum = 0
	do
		local i, j = start, end_ - dim
		while
			i
			< end_ --[[ ROBLOX CHECK: operator '<' works only if either both arguments are strings or both are a number ]]
		do
			sum += (data[j] - data[i]) * (data[(i + 1)] + data[(j + 1)])
			j = i
			i += dim
		end
	end
	return sum
end
--[[
 * create a circular doubly linked list from polygon points in the specified winding order
 ]]
local function linkedPolygon(data, start, end_, dim, clockwise)
	local last
	if
		clockwise
		== (
			signedArea(data, start, end_, dim)
			> 0 --[[ ROBLOX CHECK: operator '>' works only if either both arguments are strings or both are a number ]]
		)
	then
		do
			local i = start
			while
				i
				< end_ --[[ ROBLOX CHECK: operator '<' works only if either both arguments are strings or both are a number ]]
			do
				last = insertNode(i, data[i], data[(i + 1)], last)
				i += dim
			end
		end
	else
		do
			local i = end_ - dim
			while
				i
				>= start --[[ ROBLOX CHECK: operator '>=' works only if either both arguments are strings or both are a number ]]
			do
				last = insertNode(i, data[i], data[(i + 1)], last)
				i -= dim
			end
		end
	end
	if Boolean.toJSBoolean(if Boolean.toJSBoolean(last) then equals(last, last.next) else last) then
		removeNode(last)
		last = last.next
	end
	return last
end
--[[
 * eliminate colinear or duplicate points
 ]]
local function filterPoints(start, end_)
	if not Boolean.toJSBoolean(start) then
		return start
	end
	if not Boolean.toJSBoolean(end_) then
		end_ = start
	end
	local p = start
	local again
	repeat
		again = false
		if
			Boolean.toJSBoolean(not Boolean.toJSBoolean(p.steiner) and (function()
				local ref = equals(p, p.next)
				return Boolean.toJSBoolean(ref) and ref or area(p.prev, p, p.next) == 0
			end)())
		then
			removeNode(p)
			end_ = p.prev
			p = end_
			if p == p.next then
				break
			end
			again = true
		else
			p = p.next
		end
	until not Boolean.toJSBoolean(Boolean.toJSBoolean(again) and again or p ~= end_)
	return end_
end
--[[
 * for colinear points p, q, r, check if point q lies on segment pr
 ]]
local function onSegment(p, q, r)
	return q.x <= math.max(p.x, r.x) --[[ ROBLOX CHECK: operator '<=' works only if either both arguments are strings or both are a number ]]
		and q.x >= math.min(p.x, r.x) --[[ ROBLOX CHECK: operator '>=' works only if either both arguments are strings or both are a number ]]
		and q.y <= math.max(p.y, r.y) --[[ ROBLOX CHECK: operator '<=' works only if either both arguments are strings or both are a number ]]
		and q.y >= math.min(p.y, r.y) --[[ ROBLOX CHECK: operator '>=' works only if either both arguments are strings or both are a number ]]
end
--[[
 * check if two segments intersect
 ]]
local function intersects(p1, q1, p2, q2)
	local o1 = math.sign(area(p1, q1, p2))
	local o2 = math.sign(area(p1, q1, q2))
	local o3 = math.sign(area(p2, q2, p1))
	local o4 = math.sign(area(p2, q2, q1))
	if o1 ~= o2 and o3 ~= o4 then
		return true
	end -- general case
	if Boolean.toJSBoolean(o1 == 0 and onSegment(p1, p2, q1)) then
		return true
	end -- p1, q1 and p2 are colinear and p2 lies on p1q1
	if Boolean.toJSBoolean(o2 == 0 and onSegment(p1, q2, q1)) then
		return true
	end -- p1, q1 and q2 are colinear and q2 lies on p1q1
	if Boolean.toJSBoolean(o3 == 0 and onSegment(p2, p1, q2)) then
		return true
	end -- p2, q2 and p1 are colinear and p1 lies on p2q2
	if Boolean.toJSBoolean(o4 == 0 and onSegment(p2, q1, q2)) then
		return true
	end -- p2, q2 and q1 are colinear and q1 lies on p2q2
	return false
end
--[[
 * check if a polygon diagonal is locally inside the polygon
 ]]
local function locallyInside(a, b)
	return if area(a.prev, a, a.next)
			< 0 --[[ ROBLOX CHECK: operator '<' works only if either both arguments are strings or both are a number ]]
		then area(a, b, a.next) >= 0 --[[ ROBLOX CHECK: operator '>=' works only if either both arguments are strings or both are a number ]]
			and area(a, a.prev, b) >= 0 --[[ ROBLOX CHECK: operator '>=' works only if either both arguments are strings or both are a number ]]
		else area(a, b, a.prev) < 0 --[[ ROBLOX CHECK: operator '<' works only if either both arguments are strings or both are a number ]]
			or area(a, a.next, b) < 0 --[[ ROBLOX CHECK: operator '<' works only if either both arguments are strings or both are a number ]]
end
--[[
 * go through all polygon nodes and cure small local self-intersections
 ]]
local function cureLocalIntersections(start, triangles, dim)
	local p = start
	repeat
		local a = p.prev
		local b = p.next.next
		if
			Boolean.toJSBoolean((function()
				local ref = not Boolean.toJSBoolean(equals(a, b)) and intersects(a, p, p.next, b)
				ref = if Boolean.toJSBoolean(ref) then locallyInside(a, b) else ref
				return if Boolean.toJSBoolean(ref) then locallyInside(b, a) else ref
			end)())
		then
			table.insert(triangles, a.i / dim) --[[ ROBLOX CHECK: check if 'triangles' is an Array ]]
			table.insert(triangles, p.i / dim) --[[ ROBLOX CHECK: check if 'triangles' is an Array ]]
			table.insert(triangles, b.i / dim) --[[ ROBLOX CHECK: check if 'triangles' is an Array ]] -- remove two nodes involved
			removeNode(p)
			removeNode(p.next)
			start = b
			p = start
		end
		p = p.next
	until not (p ~= start)
	return filterPoints(p)
end
--[[
 * check if a polygon diagonal intersects any polygon segments
 ]]
local function intersectsPolygon(a, b)
	local p = a
	repeat
		if
			Boolean.toJSBoolean(
				p.i ~= a.i and p.next.i ~= a.i and p.i ~= b.i and p.next.i ~= b.i and intersects(p, p.next, a, b)
			)
		then
			return true
		end
		p = p.next
	until not (p ~= a)
	return false
end
--[[
 * check if the middle point of a polygon diagonal is inside the polygon
 ]]
local function middleInside(a, b)
	local p = a
	local inside = false
	local px = (a.x + b.x) / 2
	local py = (a.y + b.y) / 2
	repeat
		if
			(p.y > py) --[[ ROBLOX CHECK: operator '>' works only if either both arguments are strings or both are a number ]]
				~= (
					p.next.y
					> py --[[ ROBLOX CHECK: operator '>' works only if either both arguments are strings or both are a number ]]
				)
			and p.next.y ~= p.y
			and px < (p.next.x - p.x) * (py - p.y) / (p.next.y - p.y) + p.x --[[ ROBLOX CHECK: operator '<' works only if either both arguments are strings or both are a number ]]
		then
			inside = not Boolean.toJSBoolean(inside)
		end
		p = p.next
	until not (p ~= a)
	return inside
end
--[[
 * link two polygon vertices with a bridge; if the vertices belong to the same ring, it splits polygon into two
 * if one belongs to the outer ring and another to a hole, it merges it into a single ring
 ]]
local function splitPolygon(a, b)
	local a2 = Node.new(a.i, a.x, a.y)
	local b2 = Node.new(b.i, b.x, b.y)
	local an = a.next
	local bp = b.prev
	a.next = b
	b.prev = a
	a2.next = an
	an.prev = a2
	b2.next = a2
	a2.prev = b2
	bp.next = b2
	b2.prev = bp
	return b2
end
--[[
 * check if a diagonal between two polygon nodes is valid (lies in polygon interior)
 ]]
local function isValidDiagonal(a, b)
	return a.next.i ~= b.i
		and a.prev.i ~= b.i
		and not Boolean.toJSBoolean(intersectsPolygon(a, b))
		and (function()
			local ref = locallyInside(a, b)
			ref = if Boolean.toJSBoolean(ref) then locallyInside(b, a) else ref
			ref = if Boolean.toJSBoolean(ref) then middleInside(a, b) else ref
			ref = if Boolean.toJSBoolean(ref)
				then (function()
					local ref = area(a.prev, a, b.prev)
					return Boolean.toJSBoolean(ref) and ref or area(a, b.prev, b)
				end)()
				else ref
			return Boolean.toJSBoolean(ref) and ref
				or (function()
					local ref = equals(a, b)
					ref = if Boolean.toJSBoolean(ref)
						then area(a.prev, a, a.next)
							> 0 --[[ ROBLOX CHECK: operator '>' works only if either both arguments are strings or both are a number ]]
						else ref
					return -- does not create opposite-facing sectors
						if Boolean.toJSBoolean(ref)
						then area(b.prev, b, b.next)
							> 0 --[[ ROBLOX CHECK: operator '>' works only if either both arguments are strings or both are a number ]]
						else ref
				end)()
		end)()
end
return {
	cureLocalIntersections = cureLocalIntersections,
	filterPoints = filterPoints,
	isValidDiagonal = isValidDiagonal,
	linkedPolygon = linkedPolygon,
	locallyInside = locallyInside,
	splitPolygon = splitPolygon,
}
