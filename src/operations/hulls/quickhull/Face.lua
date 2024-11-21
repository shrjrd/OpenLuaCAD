-- ROBLOX NOTE: no upstream
local Packages = game.ReplicatedStorage.Packages
local LuauPolyfill = require(Packages.LuauPolyfill)
local Error = LuauPolyfill.Error
local Boolean = LuauPolyfill.Boolean
local add = require("../../../maths/vec3/add")
local copy = require("../../../maths/vec3/copy")
local cross = require("../../../maths/vec3/cross")
local dot = require("../../../maths/vec3/dot")
local length = require("../../../maths/vec3/length")
local normalize = require("../../../maths/vec3/normalize")
local scale = require("../../../maths/vec3/scale")
local subtract = require("../../../maths/vec3/subtract")
--[[
 * Original source from quickhull3d (https://github.com/mauriciopoppe/quickhull3d)
 * Copyright (c) 2015 Mauricio Poppe
 *
 * Adapted to JSCAD by Jeff Gay
 ]]
local HalfEdge = require("./HalfEdge")
local VISIBLE = 0
local NON_CONVEX = 1
local DELETED = 2
type Face = {
	getEdge: (self: Face, i: any) -> any,
	computeNormal: (self: Face) -> any,
	computeNormalMinArea: (self: Face, minArea: any) -> any,
	computeCentroid: (self: Face) -> any,
	computeNormalAndCentroid: (self: Face, minArea: any) -> any,
	distanceToPlane: (self: Face, point: any) -> any,
	--[[*
   * @private
   *
   * Connects two edges assuming that prev.head().point === next.tail().point
   *
   * @param {HalfEdge} prev
   * @param {HalfEdge} next
   ]]
	connectHalfEdges: (self: Face, prev: any, next_: any) -> any,
	mergeAdjacentFaces: (self: Face, adjacentEdge: any, discardedFaces: any) -> any,
	collectIndices: (self: Face) -> any,
}
type Face_statics = { new: () -> Face }
local Face = {} :: Face & Face_statics;
(Face :: any).__index = Face
function Face.new(): Face
	local self = setmetatable({}, Face)
	self.normal = {}
	self.centroid = {} -- signed distance from face to the origin
	self.offset = 0 -- pointer to the a vertex in a double linked list this face can see
	self.outside = nil
	self.mark = VISIBLE
	self.edge = nil
	self.nVertices = 0
	return (self :: any) :: Face
end
function Face:getEdge(i)
	if typeof(i) ~= "number" then
		error(Error.new("requires a number"))
	end
	local it = self.edge
	while
		i > 0 --[[ ROBLOX CHECK: operator '>' works only if either both arguments are strings or both are a number ]]
	do
		it = it.next
		i -= 1
	end
	while
		i < 0 --[[ ROBLOX CHECK: operator '<' works only if either both arguments are strings or both are a number ]]
	do
		it = it.prev
		i += 1
	end
	return it
end
function Face:computeNormal()
	local e0 = self.edge
	local e1 = e0.next
	local e2 = e1.next
	local v2 = subtract({}, e1:head().point, e0:head().point)
	local t = {}
	local v1 = {}
	self.nVertices = 2
	self.normal = { 0, 0, 0 }
	while e2 ~= e0 do
		copy(v1, v2)
		subtract(v2, e2:head().point, e0:head().point)
		add(self.normal, self.normal, cross(t, v1, v2))
		e2 = e2.next
		self.nVertices += 1
	end
	self.area = length(self.normal) -- normalize the vector, since we've already calculated the area
	-- it's cheaper to scale the vector using this quantity instead of
	-- doing the same operation again
	self.normal = scale(self.normal, self.normal, 1 / self.area)
end
function Face:computeNormalMinArea(minArea)
	self:computeNormal()
	if
		self.area
		< minArea --[[ ROBLOX CHECK: operator '<' works only if either both arguments are strings or both are a number ]]
	then
		-- compute the normal without the longest edge
		local maxEdge
		local maxSquaredLength = 0
		local edge = self.edge -- find the longest edge (in length) in the chain of edges
		repeat
			local lengthSquared = edge:lengthSquared()
			if
				lengthSquared
				> maxSquaredLength --[[ ROBLOX CHECK: operator '>' works only if either both arguments are strings or both are a number ]]
			then
				maxEdge = edge
				maxSquaredLength = lengthSquared
			end
			edge = edge.next
		until not (edge ~= self.edge)
		local p1 = maxEdge:tail().point
		local p2 = maxEdge:head().point
		local maxVector = subtract({}, p2, p1)
		local maxLength = math.sqrt(maxSquaredLength) -- maxVector is normalized after this operation
		scale(maxVector, maxVector, 1 / maxLength) -- compute the projection of maxVector over this face normal
		local maxProjection = dot(self.normal, maxVector) -- subtract the quantity maxEdge adds on the normal
		scale(maxVector, maxVector, -maxProjection)
		add(self.normal, self.normal, maxVector) -- renormalize `this.normal`
		normalize(self.normal, self.normal)
	end
end
function Face:computeCentroid()
	self.centroid = { 0, 0, 0 }
	local edge = self.edge
	repeat
		add(self.centroid, self.centroid, edge:head().point)
		edge = edge.next
	until not (edge ~= self.edge)
	scale(self.centroid, self.centroid, 1 / self.nVertices)
end
function Face:computeNormalAndCentroid(minArea)
	if
		typeof(minArea) ~= nil --[["undefined"]]
	then
		self:computeNormalMinArea(minArea)
	else
		self:computeNormal()
	end
	self:computeCentroid()
	self.offset = dot(self.normal, self.centroid)
end
function Face:distanceToPlane(point)
	return dot(self.normal, point) - self.offset
end
function Face:connectHalfEdges(prev, next_)
	local discardedFace
	if prev.opposite.face == next_.opposite.face then
		-- `prev` is remove a redundant edge
		local oppositeFace = next_.opposite.face
		local oppositeEdge
		if prev == self.edge then
			self.edge = next_
		end
		if oppositeFace.nVertices == 3 then
			-- case:
			-- remove the face on the right
			--
			--       /|\
			--      / | \ the face on the right
			--     /  |  \ --> opposite edge
			--    / a |   \
			--   *----*----*
			--  /     b  |  \
			--           ▾
			--      redundant edge
			--
			-- Note: the opposite edge is actually in the face to the right
			-- of the face to be destroyed
			oppositeEdge = next_.opposite.prev.opposite
			oppositeFace.mark = DELETED
			discardedFace = oppositeFace
		else
			-- case:
			--          t
			--        *----
			--       /| <- right face's redundant edge
			--      / | opposite edge
			--     /  |  ▴   /
			--    / a |  |  /
			--   *----*----*
			--  /     b  |  \
			--           ▾
			--      redundant edge
			oppositeEdge = next_.opposite.next -- make sure that the link `oppositeFace.edge` points correctly even
			-- after the right face redundant edge is removed
			if oppositeFace.edge == oppositeEdge.prev then
				oppositeFace.edge = oppositeEdge
			end --       /|   /
			--      / | t/opposite edge
			--     /  | / ▴  /
			--    / a |/  | /
			--   *----*----*
			--  /     b     \
			oppositeEdge.prev = oppositeEdge.prev.prev
			oppositeEdge.prev.next = oppositeEdge
		end --       /|
		--      / |
		--     /  |
		--    / a |
		--   *----*----*
		--  /     b  ▴  \
		--           |
		--     redundant edge
		next_.prev = prev.prev
		next_.prev.next = next_ --       / \  \
		--      /   \->\
		--     /     \<-\ opposite edge
		--    / a     \  \
		--   *----*----*
		--  /     b  ^  \
		next_:setOpposite(oppositeEdge)
		oppositeFace:computeNormalAndCentroid()
	else
		-- trivial case
		--        *
		--       /|\
		--      / | \
		--     /  |--> next
		--    / a |   \
		--   *----*----*
		--    \ b |   /
		--     \  |--> prev
		--      \ | /
		--       \|/
		--        *
		prev.next = next_
		next_.prev = prev
	end
	return discardedFace
end
function Face:mergeAdjacentFaces(adjacentEdge, discardedFaces)
	local oppositeEdge = adjacentEdge.opposite
	local oppositeFace = oppositeEdge.face
	table.insert(discardedFaces, oppositeFace) --[[ ROBLOX CHECK: check if 'discardedFaces' is an Array ]]
	oppositeFace.mark = DELETED -- find the chain of edges whose opposite face is `oppositeFace`
	--
	--                ===>
	--      \         face         /
	--       * ---- * ---- * ---- *
	--      /     opposite face    \
	--                <===
	--
	local adjacentEdgePrev = adjacentEdge.prev
	local adjacentEdgeNext = adjacentEdge.next
	local oppositeEdgePrev = oppositeEdge.prev
	local oppositeEdgeNext = oppositeEdge.next -- left edge
	while adjacentEdgePrev.opposite.face == oppositeFace do
		adjacentEdgePrev = adjacentEdgePrev.prev
		oppositeEdgeNext = oppositeEdgeNext.next
	end -- right edge
	while adjacentEdgeNext.opposite.face == oppositeFace do
		adjacentEdgeNext = adjacentEdgeNext.next
		oppositeEdgePrev = oppositeEdgePrev.prev
	end -- adjacentEdgePrev  \         face         / adjacentEdgeNext
	--                    * ---- * ---- * ---- *
	-- oppositeEdgeNext  /     opposite face    \ oppositeEdgePrev
	-- fix the face reference of all the opposite edges that are not part of
	-- the edges whose opposite face is not `face` i.e. all the edges that
	-- `face` and `oppositeFace` do not have in common
	local edge
	edge = oppositeEdgeNext
	while edge ~= oppositeEdgePrev.next do
		edge.face = self
		edge = edge.next
	end -- make sure that `face.edge` is not one of the edges to be destroyed
	-- Note: it's important for it to be a `next` edge since `prev` edges
	-- might be destroyed on `connectHalfEdges`
	self.edge = adjacentEdgeNext -- connect the extremes
	-- Note: it might be possible that after connecting the edges a triangular
	-- face might be redundant
	local discardedFace
	discardedFace = self:connectHalfEdges(oppositeEdgePrev, adjacentEdgeNext)
	if Boolean.toJSBoolean(discardedFace) then
		table.insert(discardedFaces, discardedFace) --[[ ROBLOX CHECK: check if 'discardedFaces' is an Array ]]
	end
	discardedFace = self:connectHalfEdges(adjacentEdgePrev, oppositeEdgeNext)
	if Boolean.toJSBoolean(discardedFace) then
		table.insert(discardedFaces, discardedFace) --[[ ROBLOX CHECK: check if 'discardedFaces' is an Array ]]
	end
	self:computeNormalAndCentroid() -- TODO: additional consistency checks
	return discardedFaces
end
function Face:collectIndices()
	local indices = {}
	local edge = self.edge
	repeat
		table.insert(indices, edge:head().index) --[[ ROBLOX CHECK: check if 'indices' is an Array ]]
		edge = edge.next
	until not (edge ~= self.edge)
	return indices
end
function Face.createTriangle(v0, v1, v2, minArea_: number?)
	local minArea: number = if minArea_ ~= nil then minArea_ else 0
	local face = Face.new()
	local e0 = HalfEdge.new(v0, face)
	local e1 = HalfEdge.new(v1, face)
	local e2 = HalfEdge.new(v2, face) -- join edges
	e2.prev = e1
	e0.next = e2.prev
	e0.prev = e2
	e1.next = e0.prev
	e1.prev = e0
	e2.next = e1.prev -- main half edge reference
	face.edge = e0
	face:computeNormalAndCentroid(minArea)
	return face
end
return { VISIBLE = VISIBLE, NON_CONVEX = NON_CONVEX, DELETED = DELETED, Face = Face }
