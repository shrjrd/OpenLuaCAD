-- ROBLOX NOTE: no upstream

local LuauPolyfill = require("@Packages/LuauPolyfill")
local Boolean = LuauPolyfill.Boolean
local eliminateHoles = require("./eliminateHoles")
local removeNode, sortLinked
do
	local ref = require("./linkedList")
	removeNode, sortLinked = ref.removeNode, ref.sortLinked
end
local cureLocalIntersections, filterPoints, isValidDiagonal, linkedPolygon, splitPolygon
do
	local ref = require("./linkedPolygon")
	cureLocalIntersections, filterPoints, isValidDiagonal, linkedPolygon, splitPolygon =
		ref.cureLocalIntersections, ref.filterPoints, ref.isValidDiagonal, ref.linkedPolygon, ref.splitPolygon
end
local area, pointInTriangle
do
	local ref = require("./triangle")
	area, pointInTriangle = ref.area, ref.pointInTriangle
end
local earcutLinked = nil
--[[
 * check whether a polygon node forms a valid ear with adjacent nodes
 ]]
local function isEar(ear)
	local a = ear.prev
	local b = ear
	local c = ear.next
	if
		area(a, b, c)
		>= 0 --[[ ROBLOX CHECK: operator '>=' works only if either both arguments are strings or both are a number ]]
	then
		return false
	end -- reflex, can't be an ear
	-- now make sure we don't have other points inside the potential ear
	local p = ear.next.next
	while p ~= ear.prev do
		if
			Boolean.toJSBoolean((function()
				local ref = pointInTriangle(a.x, a.y, b.x, b.y, c.x, c.y, p.x, p.y)
				return if Boolean.toJSBoolean(ref)
					then area(p.prev, p, p.next)
						>= 0 --[[ ROBLOX CHECK: operator '>=' works only if either both arguments are strings or both are a number ]]
					else ref
			end)())
		then
			return false
		end
		p = p.next
	end
	return true
end
--[[
 * try splitting polygon into two and triangulate them independently
 ]]
local function splitEarcut(start, triangles, dim, minX, minY, invSize)
	-- look for a valid diagonal that divides the polygon into two
	local a = start
	repeat
		local b = a.next.next
		while b ~= a.prev do
			if Boolean.toJSBoolean(a.i ~= b.i and isValidDiagonal(a, b)) then
				-- split the polygon in two by the diagonal
				local c = splitPolygon(a, b) -- filter colinear points around the cuts
				a = filterPoints(a, a.next)
				c = filterPoints(c, c.next) -- run earcut on each half
				earcutLinked(a, triangles, dim, minX, minY, invSize)
				earcutLinked(c, triangles, dim, minX, minY, invSize)
				return
			end
			b = b.next
		end
		a = a.next
	until not (a ~= start)
end

--[[
 * z-order of a point given coords and inverse of the longer side of data bbox
 ]]
local function zOrder(x, y, minX, minY, invSize)
	-- coords are transformed into non-negative 15-bit integer range
	x = 32767 * (x - minX) * invSize
	y = 32767 * (y - minY) * invSize
	x = bit32.band(
		bit32.bor(
			x,
			bit32.lshift(x, 8) --[[ ROBLOX CHECK: `bit32.lshift` clamps arguments and result to [0,2^32 - 1] ]]
		), --[[ ROBLOX CHECK: `bit32.bor` clamps arguments and result to [0,2^32 - 1] ]]
		0x00FF00FF
	) --[[ ROBLOX CHECK: `bit32.band` clamps arguments and result to [0,2^32 - 1] ]]
	x = bit32.band(
		bit32.bor(
			x,
			bit32.lshift(x, 4) --[[ ROBLOX CHECK: `bit32.lshift` clamps arguments and result to [0,2^32 - 1] ]]
		), --[[ ROBLOX CHECK: `bit32.bor` clamps arguments and result to [0,2^32 - 1] ]]
		0x0F0F0F0F
	) --[[ ROBLOX CHECK: `bit32.band` clamps arguments and result to [0,2^32 - 1] ]]
	x = bit32.band(
		bit32.bor(
			x,
			bit32.lshift(x, 2) --[[ ROBLOX CHECK: `bit32.lshift` clamps arguments and result to [0,2^32 - 1] ]]
		), --[[ ROBLOX CHECK: `bit32.bor` clamps arguments and result to [0,2^32 - 1] ]]
		0x33333333
	) --[[ ROBLOX CHECK: `bit32.band` clamps arguments and result to [0,2^32 - 1] ]]
	x = bit32.band(
		bit32.bor(
			x,
			bit32.lshift(x, 1) --[[ ROBLOX CHECK: `bit32.lshift` clamps arguments and result to [0,2^32 - 1] ]]
		), --[[ ROBLOX CHECK: `bit32.bor` clamps arguments and result to [0,2^32 - 1] ]]
		0x55555555
	) --[[ ROBLOX CHECK: `bit32.band` clamps arguments and result to [0,2^32 - 1] ]]
	y = bit32.band(
		bit32.bor(
			y,
			bit32.lshift(y, 8) --[[ ROBLOX CHECK: `bit32.lshift` clamps arguments and result to [0,2^32 - 1] ]]
		), --[[ ROBLOX CHECK: `bit32.bor` clamps arguments and result to [0,2^32 - 1] ]]
		0x00FF00FF
	) --[[ ROBLOX CHECK: `bit32.band` clamps arguments and result to [0,2^32 - 1] ]]
	y = bit32.band(
		bit32.bor(
			y,
			bit32.lshift(y, 4) --[[ ROBLOX CHECK: `bit32.lshift` clamps arguments and result to [0,2^32 - 1] ]]
		), --[[ ROBLOX CHECK: `bit32.bor` clamps arguments and result to [0,2^32 - 1] ]]
		0x0F0F0F0F
	) --[[ ROBLOX CHECK: `bit32.band` clamps arguments and result to [0,2^32 - 1] ]]
	y = bit32.band(
		bit32.bor(
			y,
			bit32.lshift(y, 2) --[[ ROBLOX CHECK: `bit32.lshift` clamps arguments and result to [0,2^32 - 1] ]]
		), --[[ ROBLOX CHECK: `bit32.bor` clamps arguments and result to [0,2^32 - 1] ]]
		0x33333333
	) --[[ ROBLOX CHECK: `bit32.band` clamps arguments and result to [0,2^32 - 1] ]]
	y = bit32.band(
		bit32.bor(
			y,
			bit32.lshift(y, 1) --[[ ROBLOX CHECK: `bit32.lshift` clamps arguments and result to [0,2^32 - 1] ]]
		), --[[ ROBLOX CHECK: `bit32.bor` clamps arguments and result to [0,2^32 - 1] ]]
		0x55555555
	) --[[ ROBLOX CHECK: `bit32.band` clamps arguments and result to [0,2^32 - 1] ]]
	return bit32.bor(
		x,
		bit32.lshift(y, 1) --[[ ROBLOX CHECK: `bit32.lshift` clamps arguments and result to [0,2^32 - 1] ]]
	) --[[ ROBLOX CHECK: `bit32.bor` clamps arguments and result to [0,2^32 - 1] ]]
end
local function isEarHashed(ear, minX, minY, invSize)
	local a = ear.prev
	local b = ear
	local c = ear.next
	if
		area(a, b, c)
		>= 0 --[[ ROBLOX CHECK: operator '>=' works only if either both arguments are strings or both are a number ]]
	then
		return false
	end -- reflex, can't be an ear
	-- triangle bbox; min & max are calculated like this for speed
	local minTX = if a.x
			< b.x --[[ ROBLOX CHECK: operator '<' works only if either both arguments are strings or both are a number ]]
		then if a.x
				< c.x --[[ ROBLOX CHECK: operator '<' works only if either both arguments are strings or both are a number ]]
			then a.x
			else c.x
		else if b.x
				< c.x --[[ ROBLOX CHECK: operator '<' works only if either both arguments are strings or both are a number ]]
			then b.x
			else c.x
	local minTY = if a.y
			< b.y --[[ ROBLOX CHECK: operator '<' works only if either both arguments are strings or both are a number ]]
		then if a.y
				< c.y --[[ ROBLOX CHECK: operator '<' works only if either both arguments are strings or both are a number ]]
			then a.y
			else c.y
		else if b.y
				< c.y --[[ ROBLOX CHECK: operator '<' works only if either both arguments are strings or both are a number ]]
			then b.y
			else c.y
	local maxTX = if a.x
			> b.x --[[ ROBLOX CHECK: operator '>' works only if either both arguments are strings or both are a number ]]
		then if a.x
				> c.x --[[ ROBLOX CHECK: operator '>' works only if either both arguments are strings or both are a number ]]
			then a.x
			else c.x
		else if b.x
				> c.x --[[ ROBLOX CHECK: operator '>' works only if either both arguments are strings or both are a number ]]
			then b.x
			else c.x
	local maxTY = if a.y
			> b.y --[[ ROBLOX CHECK: operator '>' works only if either both arguments are strings or both are a number ]]
		then if a.y
				> c.y --[[ ROBLOX CHECK: operator '>' works only if either both arguments are strings or both are a number ]]
			then a.y
			else c.y
		else if b.y
				> c.y --[[ ROBLOX CHECK: operator '>' works only if either both arguments are strings or both are a number ]]
			then b.y
			else c.y -- z-order range for the current triangle bbox
	local minZ = zOrder(minTX, minTY, minX, minY, invSize)
	local maxZ = zOrder(maxTX, maxTY, minX, minY, invSize)
	local p = ear.prevZ
	local n = ear.nextZ -- look for points inside the triangle in both directions
	while
		Boolean.toJSBoolean((function()
			local ref = if Boolean.toJSBoolean(p)
				then p.z
					>= minZ --[[ ROBLOX CHECK: operator '>=' works only if either both arguments are strings or both are a number ]]
				else p
			ref = if Boolean.toJSBoolean(ref) then n else ref
			return if Boolean.toJSBoolean(ref)
				then n.z
					<= maxZ --[[ ROBLOX CHECK: operator '<=' works only if either both arguments are strings or both are a number ]]
				else ref
		end)())
	do
		if
			Boolean.toJSBoolean((function()
				local ref = p ~= ear.prev and p ~= ear.next and pointInTriangle(a.x, a.y, b.x, b.y, c.x, c.y, p.x, p.y)
				return if Boolean.toJSBoolean(ref)
					then area(p.prev, p, p.next)
						>= 0 --[[ ROBLOX CHECK: operator '>=' works only if either both arguments are strings or both are a number ]]
					else ref
			end)())
		then
			return false
		end
		p = p.prevZ
		if
			Boolean.toJSBoolean((function()
				local ref = n ~= ear.prev and n ~= ear.next and pointInTriangle(a.x, a.y, b.x, b.y, c.x, c.y, n.x, n.y)
				return if Boolean.toJSBoolean(ref)
					then area(n.prev, n, n.next)
						>= 0 --[[ ROBLOX CHECK: operator '>=' works only if either both arguments are strings or both are a number ]]
					else ref
			end)())
		then
			return false
		end
		n = n.nextZ
	end -- look for remaining points in decreasing z-order
	while
		Boolean.toJSBoolean(if Boolean.toJSBoolean(p)
			then p.z
				>= minZ --[[ ROBLOX CHECK: operator '>=' works only if either both arguments are strings or both are a number ]]
			else p)
	do
		if
			Boolean.toJSBoolean((function()
				local ref = p ~= ear.prev and p ~= ear.next and pointInTriangle(a.x, a.y, b.x, b.y, c.x, c.y, p.x, p.y)
				return if Boolean.toJSBoolean(ref)
					then area(p.prev, p, p.next)
						>= 0 --[[ ROBLOX CHECK: operator '>=' works only if either both arguments are strings or both are a number ]]
					else ref
			end)())
		then
			return false
		end
		p = p.prevZ
	end -- look for remaining points in increasing z-order
	while
		Boolean.toJSBoolean(if Boolean.toJSBoolean(n)
			then n.z
				<= maxZ --[[ ROBLOX CHECK: operator '<=' works only if either both arguments are strings or both are a number ]]
			else n)
	do
		if
			Boolean.toJSBoolean((function()
				local ref = n ~= ear.prev and n ~= ear.next and pointInTriangle(a.x, a.y, b.x, b.y, c.x, c.y, n.x, n.y)
				return if Boolean.toJSBoolean(ref)
					then area(n.prev, n, n.next)
						>= 0 --[[ ROBLOX CHECK: operator '>=' works only if either both arguments are strings or both are a number ]]
					else ref
			end)())
		then
			return false
		end
		n = n.nextZ
	end
	return true
end
--[[
 * interlink polygon nodes in z-order
 ]]
local function indexCurve(start, minX, minY, invSize)
	local p = start
	repeat
		if p.z == nil then
			p.z = zOrder(p.x, p.y, minX, minY, invSize)
		end
		p.prevZ = p.prev
		p.nextZ = p.next
		p = p.next
	until not (p ~= start)
	p.prevZ.nextZ = nil
	p.prevZ = nil
	sortLinked(p, function(p)
		return p.z
	end)
end
--[[
 * main ear slicing loop which triangulates a polygon (given as a linked list)
 ]]
earcutLinked = function(ear, triangles, dim, minX, minY, invSize, pass)
	if not Boolean.toJSBoolean(ear) then
		return
	end -- interlink polygon nodes in z-order
	if Boolean.toJSBoolean(not Boolean.toJSBoolean(pass) and invSize) then
		indexCurve(ear, minX, minY, invSize)
	end
	local stop = ear
	local prev
	local next_ -- iterate through ears, slicing them one by one
	while ear.prev ~= ear.next do
		prev = ear.prev
		next_ = ear.next
		if
			Boolean.toJSBoolean(
				if Boolean.toJSBoolean(invSize) then isEarHashed(ear, minX, minY, invSize) else isEar(ear)
			)
		then
			-- cut off the triangle
			table.insert(triangles, prev.i / dim) --[[ ROBLOX CHECK: check if 'triangles' is an Array ]]
			table.insert(triangles, ear.i / dim) --[[ ROBLOX CHECK: check if 'triangles' is an Array ]]
			table.insert(triangles, next_.i / dim) --[[ ROBLOX CHECK: check if 'triangles' is an Array ]]
			removeNode(ear) -- skipping the next vertex leads to less sliver triangles
			ear = next_.next
			stop = next_.next
			continue
		end
		ear = next_ -- if we looped through the whole remaining polygon and can't find any more ears
		if ear == stop then
			-- try filtering points and slicing again
			if not Boolean.toJSBoolean(pass) then
				earcutLinked(filterPoints(ear), triangles, dim, minX, minY, invSize, 1) -- if this didn't work, try curing all small self-intersections locally
			elseif pass == 1 then
				ear = cureLocalIntersections(filterPoints(ear), triangles, dim)
				earcutLinked(ear, triangles, dim, minX, minY, invSize, 2) -- as a last resort, try splitting the remaining polygon into two
			elseif pass == 2 then
				splitEarcut(ear, triangles, dim, minX, minY, invSize)
			end
			break
		end
	end
end
--[[
 * An implementation of the earcut polygon triangulation algorithm.
 *
 * Original source from https://github.com/mapbox/earcut
 * Copyright (c) 2016 Mapbox
 *
 * @param {data} A flat array of vertex coordinates.
 * @param {holeIndices} An array of hole indices if any.
 * @param {dim} The number of coordinates per vertex in the input array.
 ]]
local function triangulate(data, holeIndices, dim_: number?)
	local dim: number = if dim_ ~= nil then dim_ else 2
	local hasHoles = if Boolean.toJSBoolean(holeIndices) then #holeIndices else holeIndices
	local outerLen = if Boolean.toJSBoolean(hasHoles)
		then holeIndices[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		] * dim
		else #data
	local outerNode = linkedPolygon(data, 0, outerLen, dim, true)
	local triangles = {}
	if not Boolean.toJSBoolean(outerNode) or outerNode.next == outerNode.prev then
		return triangles
	end
	local minX, minY, maxX, maxY, invSize
	if Boolean.toJSBoolean(hasHoles) then
		outerNode = eliminateHoles(data, holeIndices, outerNode, dim)
	end -- if the shape is not too simple, we'll use z-order curve hash later; calculate polygon bbox
	if
		#data
		> 80 * dim --[[ ROBLOX CHECK: operator '>' works only if either both arguments are strings or both are a number ]]
	then
		maxX = data[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		]
		minX = maxX
		maxY = data[
			2 --[[ ROBLOX adaptation: added 1 to array index ]]
		]
		minY = maxY
		do
			local i = dim
			while
				i
				< outerLen --[[ ROBLOX CHECK: operator '<' works only if either both arguments are strings or both are a number ]]
			do
				local x = data[i]
				local y = data[(i + 1)]
				if
					x
					< minX --[[ ROBLOX CHECK: operator '<' works only if either both arguments are strings or both are a number ]]
				then
					minX = x
				end
				if
					y
					< minY --[[ ROBLOX CHECK: operator '<' works only if either both arguments are strings or both are a number ]]
				then
					minY = y
				end
				if
					x
					> maxX --[[ ROBLOX CHECK: operator '>' works only if either both arguments are strings or both are a number ]]
				then
					maxX = x
				end
				if
					y
					> maxY --[[ ROBLOX CHECK: operator '>' works only if either both arguments are strings or both are a number ]]
				then
					maxY = y
				end
				i += dim
			end
		end -- minX, minY and invSize are later used to transform coords into integers for z-order calculation
		invSize = math.max(maxX - minX, maxY - minY)
		invSize = if invSize ~= 0 then 1 / invSize else 0
	end
	earcutLinked(outerNode, triangles, dim, minX, minY, invSize)
	return triangles
end
return triangulate
