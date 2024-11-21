-- ROBLOX NOTE: no upstream
local Packages = game.ReplicatedStorage.Packages
local Number_EPSILON = 2.220446049250313e-16
local LuauPolyfill = require(Packages.LuauPolyfill)
local Error = LuauPolyfill.Error
local Array = LuauPolyfill.Array
local Boolean = LuauPolyfill.Boolean
local dot = require("../../../maths/vec3/dot")
local pointLineDistance = require("./point-line-distance")
local getPlaneNormal = require("./get-plane-normal")
local VertexList = require("./VertexList")
local Vertex = require("./Vertex")
local Face, VISIBLE, NON_CONVEX, DELETED
do
	local ref = require("./Face")
	Face, VISIBLE, NON_CONVEX, DELETED = ref.Face, ref.VISIBLE, ref.NON_CONVEX, ref.DELETED
end
--[[
 * Original source from quickhull3d (https://github.com/mauriciopoppe/quickhull3d)
 * Copyright (c) 2015 Mauricio Poppe
 *
 * Adapted to JSCAD by Jeff Gay
 ]]
-- merge types
-- non convex with respect to the large face
local MERGE_NON_CONVEX_WRT_LARGER_FACE = 1
local MERGE_NON_CONVEX = 2
type QuickHull = {
	addVertexToFace: (self: QuickHull, vertex: any, face: any) -> any,
	--[[*
   * Removes `vertex` for the `claimed` list of vertices, it also makes sure
   * that the link from `face` to the first vertex it sees in `claimed` is
   * linked correctly after the removal
   *
   * @param {Vertex} vertex
   * @param {Face} face
   ]]
	removeVertexFromFace: (self: QuickHull, vertex: any, face: any) -> any,
	--[[*
   * Removes all the visible vertices that `face` is able to see which are
   * stored in the `claimed` vertext list
   *
   * @param {Face} face
   * @return {Vertex|undefined} If face had visible vertices returns
   * `face.outside`, otherwise undefined
   ]]
	removeAllVerticesFromFace: (self: QuickHull, face: any) -> any,
	--[[*
   * Removes all the visible vertices that `face` is able to see, additionally
   * checking the following:
   *
   * If `absorbingFace` doesn't exist then all the removed vertices will be
   * added to the `unclaimed` vertex list
   *
   * If `absorbingFace` exists then this method will assign all the vertices of
   * `face` that can see `absorbingFace`, if a vertex cannot see `absorbingFace`
   * it's added to the `unclaimed` vertex list
   *
   * @param {Face} face
   * @param {Face} [absorbingFace]
   ]]
	deleteFaceVertices: (self: QuickHull, face: any, absorbingFace: any) -> any,
	--[[*
   * Reassigns as many vertices as possible from the unclaimed list to the new
   * faces
   *
   * @param {Faces[]} newFaces
   ]]
	resolveUnclaimedPoints: (self: QuickHull, newFaces: any) -> any,
	--[[*
   * Computes the extremes of a tetrahedron which will be the initial hull
   *
   * @return {number[]} The min/max vertices in the x,y,z directions
   ]]
	computeExtremes: (self: QuickHull) -> any,
	--[[*
   * Compues the initial tetrahedron assigning to its faces all the points that
   * are candidates to form part of the hull
   ]]
	createInitialSimplex: (self: QuickHull) -> any,
	reindexFaceAndVertices: (self: QuickHull) -> any,
	collectFaces: (self: QuickHull, skipTriangulation: any) -> any,
	--[[*
   * Finds the next vertex to make faces with the current hull
   *
   * - let `face` be the first face existing in the `claimed` vertex list
   *  - if `face` doesn't exist then return since there're no vertices left
   *  - otherwise for each `vertex` that face sees find the one furthest away
   *  from `face`
   *
   * @return {Vertex|undefined} Returns undefined when there're no more
   * visible vertices
   ]]
	nextVertexToAdd: (self: QuickHull) -> any,
	--[[*
   * Computes a chain of half edges in ccw order called the `horizon`, for an
   * edge to be part of the horizon it must join a face that can see
   * `eyePoint` and a face that cannot see `eyePoint`
   *
   * @param {number[]} eyePoint - The coordinates of a point
   * @param {HalfEdge} crossEdge - The edge used to jump to the current `face`
   * @param {Face} face - The current face being tested
   * @param {HalfEdge[]} horizon - The edges that form part of the horizon in
   * ccw order
   ]]
	computeHorizon: (self: QuickHull, eyePoint: any, crossEdge: any, face: any, horizon: any) -> any,
	--[[*
   * Creates a face with the points `eyeVertex.point`, `horizonEdge.tail` and
   * `horizonEdge.tail` in ccw order
   *
   * @param {Vertex} eyeVertex
   * @param {HalfEdge} horizonEdge
   * @return {HalfEdge} The half edge whose vertex is the eyeVertex
   ]]
	addAdjoiningFace: (self: QuickHull, eyeVertex: any, horizonEdge: any) -> any,
	--[[*
   * Adds #horizon faces to the hull, each face will be 'linked' with the
   * horizon opposite face and the face on the left/right
   *
   * @param {Vertex} eyeVertex
   * @param {HalfEdge[]} horizon - A chain of half edges in ccw order
   ]]
	addNewFaces: (self: QuickHull, eyeVertex: any, horizon: any) -> any,
	--[[*
   * Computes the distance from `edge` opposite face's centroid to
   * `edge.face`
   *
   * @param {HalfEdge} edge
   * @return {number}
   * - A positive number when the centroid of the opposite face is above the
   *   face i.e. when the faces are concave
   * - A negative number when the centroid of the opposite face is below the
   *   face i.e. when the faces are convex
   ]]
	oppositeFaceDistance: (self: QuickHull, edge: any) -> any,
	--[[*
   * Merges a face with none/any/all its neighbors according to the strategy
   * used
   *
   * if `mergeType` is MERGE_NON_CONVEX_WRT_LARGER_FACE then the merge will be
   * decided based on the face with the larger area, the centroid of the face
   * with the smaller area will be checked against the one with the larger area
   * to see if it's in the merge range [tolerance, -tolerance] i.e.
   *
   *    dot(centroid smaller face, larger face normal) - larger face offset > -tolerance
   *
   * Note that the first check (with +tolerance) was done on `computeHorizon`
   *
   * If the above is not true then the check is done with respect to the smaller
   * face i.e.
   *
   *    dot(centroid larger face, smaller face normal) - smaller face offset > -tolerance
   *
   * If true then it means that two faces are non convex (concave), even if the
   * dot(...) - offset value is > 0 (that's the point of doing the merge in the
   * first place)
   *
   * If two faces are concave then the check must also be done on the other face
   * but this is done in another merge pass, for this to happen the face is
   * marked in a temporal NON_CONVEX state
   *
   * if `mergeType` is MERGE_NON_CONVEX then two faces will be merged only if
   * they pass the following conditions
   *
   *    dot(centroid smaller face, larger face normal) - larger face offset > -tolerance
   *    dot(centroid larger face, smaller face normal) - smaller face offset > -tolerance
   *
   * @param {Face} face
   * @param {number} mergeType - Either MERGE_NON_CONVEX_WRT_LARGER_FACE or
   * MERGE_NON_CONVEX
   ]]
	doAdjacentMerge: (self: QuickHull, face: any, mergeType: any) -> any,
	--[[*
   * Adds a vertex to the hull with the following algorithm
   *
   * - Compute the `horizon` which is a chain of half edges, for an edge to
   *   belong to this group it must be the edge connecting a face that can
   *   see `eyeVertex` and a face which cannot see `eyeVertex`
   * - All the faces that can see `eyeVertex` have its visible vertices removed
   *   from the claimed VertexList
   * - A new set of faces is created with each edge of the `horizon` and
   *   `eyeVertex`, each face is connected with the opposite horizon face and
   *   the face on the left/right
   * - The new faces are merged if possible with the opposite horizon face first
   *   and then the faces on the right/left
   * - The vertices removed from all the visible faces are assigned to the new
   *   faces if possible
   *
   * @param {Vertex} eyeVertex
   ]]
	addVertexToHull: (self: QuickHull, eyeVertex: any) -> any,
	build: (self: QuickHull) -> any,
}
type QuickHull_statics = { new: (points: any) -> QuickHull }
local QuickHull = {} :: QuickHull & QuickHull_statics;
(QuickHull :: any).__index = QuickHull
function QuickHull.new(points): QuickHull
	local self = setmetatable({}, QuickHull)
	if not Boolean.toJSBoolean(Array.isArray(points)) then
		error(Error.new("input is not a valid array")) --error(TypeError("input is not a valid array"))
	end
	if
		#points
		< 4 --[[ ROBLOX CHECK: operator '<' works only if either both arguments are strings or both are a number ]]
	then
		error(Error.new("cannot build a simplex out of <4 points"))
	end
	self.tolerance = -1 -- buffers
	self.nFaces = 0
	self.nPoints = #points
	self.faces = {}
	self.newFaces = {} -- helpers
	--
	-- let `a`, `b` be `Face` instances
	-- let `v` be points wrapped as instance of `Vertex`
	--
	--     [v, v, ..., v, v, v, ...]
	--      ^             ^
	--      |             |
	--  a.outside     b.outside
	--
	self.claimed = VertexList.new()
	self.unclaimed = VertexList.new() -- vertices of the hull(internal representation of points)
	self.vertices = {}
	do
		local i = 0
		while
			i
			< #points --[[ ROBLOX CHECK: operator '<' works only if either both arguments are strings or both are a number ]]
		do
			table.insert(self.vertices, Vertex.new(points[i], i)) --[[ ROBLOX CHECK: check if 'this.vertices' is an Array ]]
			i += 1
		end
	end
	self.discardedFaces = {}
	self.vertexPointIndices = {}
	return (self :: any) :: QuickHull
end
function QuickHull:addVertexToFace(vertex, face)
	vertex.face = face
	if not Boolean.toJSBoolean(face.outside) then
		self.claimed:add(vertex)
	else
		self.claimed:insertBefore(face.outside, vertex)
	end
	face.outside = vertex
end
function QuickHull:removeVertexFromFace(vertex, face)
	if vertex == face.outside then
		-- fix face.outside link
		if Boolean.toJSBoolean(if Boolean.toJSBoolean(vertex.next) then vertex.next.face == face else vertex.next) then
			-- face has at least 2 outside vertices, move the `outside` reference
			face.outside = vertex.next
		else
			-- vertex was the only outside vertex that face had
			face.outside = nil
		end
	end
	self.claimed:remove(vertex)
end
function QuickHull:removeAllVerticesFromFace(face)
	if Boolean.toJSBoolean(face.outside) then
		-- pointer to the last vertex of this face
		-- [..., outside, ..., end, outside, ...]
		--          |           |      |
		--          a           a      b
		local end_ = face.outside
		while Boolean.toJSBoolean(if Boolean.toJSBoolean(end_.next) then end_.next.face == face else end_.next) do
			end_ = end_.next
		end
		self.claimed:removeChain(face.outside, end_) --                            b
		--                       [ outside, ...]
		--                            |  removes this link
		--     [ outside, ..., end ] -┘
		--          |           |
		--          a           a
		end_.next = nil
		return face.outside
	end
	return
end
function QuickHull:deleteFaceVertices(face, absorbingFace)
	local faceVertices = self:removeAllVerticesFromFace(face)
	if Boolean.toJSBoolean(faceVertices) then
		if not Boolean.toJSBoolean(absorbingFace) then
			-- mark the vertices to be reassigned to some other face
			self.unclaimed:addAll(faceVertices)
		else
			-- if there's an absorbing face try to assign as many vertices
			-- as possible to it
			-- the reference `vertex.next` might be destroyed on
			-- `this.addVertexToFace` (see VertexList#add), nextVertex is a
			-- reference to it
			local nextVertex
			do
				local vertex = faceVertices
				while vertex do
					nextVertex = vertex.next
					local distance = absorbingFace:distanceToPlane(vertex.point) -- check if `vertex` is able to see `absorbingFace`
					if
						distance
						> self.tolerance --[[ ROBLOX CHECK: operator '>' works only if either both arguments are strings or both are a number ]]
					then
						self:addVertexToFace(vertex, absorbingFace)
					else
						self.unclaimed:add(vertex)
					end
					vertex = nextVertex
				end
			end
		end
	end
end
function QuickHull:resolveUnclaimedPoints(newFaces)
	-- cache next vertex so that if `vertex.next` is destroyed it's still
	-- recoverable
	local vertexNext = self.unclaimed:first()
	do
		local vertex = vertexNext
		while vertex do
			vertexNext = vertex.next
			local maxDistance = self.tolerance
			local maxFace
			do
				local i = 0
				while
					i
					< #newFaces --[[ ROBLOX CHECK: operator '<' works only if either both arguments are strings or both are a number ]]
				do
					local face = newFaces[i]
					if face.mark == VISIBLE then
						local dist = face:distanceToPlane(vertex.point)
						if
							dist
							> maxDistance --[[ ROBLOX CHECK: operator '>' works only if either both arguments are strings or both are a number ]]
						then
							maxDistance = dist
							maxFace = face
						end
						if
							maxDistance
							> 1000 * self.tolerance --[[ ROBLOX CHECK: operator '>' works only if either both arguments are strings or both are a number ]]
						then
							break
						end
					end
					i += 1
				end
			end
			if Boolean.toJSBoolean(maxFace) then
				self:addVertexToFace(vertex, maxFace)
			end
			vertex = vertexNext
		end
	end
end
function QuickHull:computeExtremes()
	local min = {}
	local max = {} -- min vertex on the x,y,z directions
	local minVertices = {} -- max vertex on the x,y,z directions
	local maxVertices = {}
	local i, j -- initially assume that the first vertex is the min/max
	i = 0
	while
		i < 3 --[[ ROBLOX CHECK: operator '<' works only if either both arguments are strings or both are a number ]]
	do
		maxVertices[i] = self.vertices[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		]
		minVertices[i] = maxVertices[i]
		i += 1
	end -- copy the coordinates of the first vertex to min/max
	i = 0
	while
		i < 3 --[[ ROBLOX CHECK: operator '<' works only if either both arguments are strings or both are a number ]]
	do
		max[i] = self.vertices[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		].point[i]
		min[i] = max[i]
		i += 1
	end -- compute the min/max vertex on all 6 directions
	i = 1
	while
		i
		< #self.vertices --[[ ROBLOX CHECK: operator '<' works only if either both arguments are strings or both are a number ]]
	do
		local vertex = self.vertices[i]
		local point = vertex.point -- update the min coordinates
		j = 0
		while
			j
			< 3 --[[ ROBLOX CHECK: operator '<' works only if either both arguments are strings or both are a number ]]
		do
			if
				point[j]
				< min[j] --[[ ROBLOX CHECK: operator '<' works only if either both arguments are strings or both are a number ]]
			then
				min[j] = point[j]
				minVertices[j] = vertex
			end
			j += 1
		end -- update the max coordinates
		j = 0
		while
			j
			< 3 --[[ ROBLOX CHECK: operator '<' works only if either both arguments are strings or both are a number ]]
		do
			if
				point[j]
				> max[j] --[[ ROBLOX CHECK: operator '>' works only if either both arguments are strings or both are a number ]]
			then
				max[j] = point[j]
				maxVertices[j] = vertex
			end
			j += 1
		end
		i += 1
	end -- compute epsilon
	self.tolerance = 3
		* Number_EPSILON
		* (
			math.max(
				math.abs(min[
					1 --[[ ROBLOX adaptation: added 1 to array index ]]
				]),
				math.abs(max[
					1 --[[ ROBLOX adaptation: added 1 to array index ]]
				])
			)
			+ math.max(
				math.abs(min[
					2 --[[ ROBLOX adaptation: added 1 to array index ]]
				]),
				math.abs(max[
					2 --[[ ROBLOX adaptation: added 1 to array index ]]
				])
			)
			+ math.max(
				math.abs(min[
					3 --[[ ROBLOX adaptation: added 1 to array index ]]
				]),
				math.abs(max[
					3 --[[ ROBLOX adaptation: added 1 to array index ]]
				])
			)
		)
	return { minVertices, maxVertices }
end
function QuickHull:createInitialSimplex()
	local vertices = self.vertices
	local min, max = table.unpack(self:computeExtremes(), 1, 2)
	local v2, v3
	local i, j -- Find the two vertices with the greatest 1d separation
	-- (max.x - min.x)
	-- (max.y - min.y)
	-- (max.z - min.z)
	local maxDistance = 0
	local indexMax = 0
	i = 0
	while
		i < 3 --[[ ROBLOX CHECK: operator '<' works only if either both arguments are strings or both are a number ]]
	do
		local distance = max[i].point[i] - min[i].point[i]
		if
			distance
			> maxDistance --[[ ROBLOX CHECK: operator '>' works only if either both arguments are strings or both are a number ]]
		then
			maxDistance = distance
			indexMax = i
		end
		i += 1
	end
	local v0 = min[indexMax]
	local v1 = max[indexMax] -- the next vertex is the one farthest to the line formed by `v0` and `v1`
	maxDistance = 0
	i = 0
	while
		i
		< #self.vertices --[[ ROBLOX CHECK: operator '<' works only if either both arguments are strings or both are a number ]]
	do
		local vertex = self.vertices[i]
		if vertex ~= v0 and vertex ~= v1 then
			local distance = pointLineDistance(vertex.point, v0.point, v1.point)
			if
				distance
				> maxDistance --[[ ROBLOX CHECK: operator '>' works only if either both arguments are strings or both are a number ]]
			then
				maxDistance = distance
				v2 = vertex
			end
		end
		i += 1
	end -- the next vertes is the one farthest to the plane `v0`, `v1`, `v2`
	-- normalize((v2 - v1) x (v0 - v1))
	local normal = getPlaneNormal({}, v0.point, v1.point, v2.point) -- distance from the origin to the plane
	local distPO = dot(v0.point, normal)
	maxDistance = -1
	i = 0
	while
		i
		< #self.vertices --[[ ROBLOX CHECK: operator '<' works only if either both arguments are strings or both are a number ]]
	do
		local vertex = self.vertices[i]
		if vertex ~= v0 and vertex ~= v1 and vertex ~= v2 then
			local distance = math.abs(dot(normal, vertex.point) - distPO)
			if
				distance
				> maxDistance --[[ ROBLOX CHECK: operator '>' works only if either both arguments are strings or both are a number ]]
			then
				maxDistance = distance
				v3 = vertex
			end
		end
		i += 1
	end -- initial simplex
	-- Taken from http://everything2.com/title/How+to+paint+a+tetrahedron
	--
	--                              v2
	--                             ,|,
	--                           ,7``\'VA,
	--                         ,7`   |, `'VA,
	--                       ,7`     `\    `'VA,
	--                     ,7`        |,      `'VA,
	--                   ,7`          `\         `'VA,
	--                 ,7`             |,           `'VA,
	--               ,7`               `\       ,..ooOOTK` v3
	--             ,7`                  |,.ooOOT''`    AV
	--           ,7`            ,..ooOOT`\`           /7
	--         ,7`      ,..ooOOT''`      |,          AV
	--        ,T,..ooOOT''`              `\         /7
	--     v0 `'TTs.,                     |,       AV
	--            `'TTs.,                 `\      /7
	--                 `'TTs.,             |,    AV
	--                      `'TTs.,        `\   /7
	--                           `'TTs.,    |, AV
	--                                `'TTs.,\/7
	--                                     `'T`
	--                                       v1
	--
	local faces = {}
	if
		dot(v3.point, normal) - distPO
		< 0 --[[ ROBLOX CHECK: operator '<' works only if either both arguments are strings or both are a number ]]
	then
		-- the face is not able to see the point so `planeNormal`
		-- is pointing outside the tetrahedron
		Array.concat(faces, {
			Face:createTriangle(v0, v1, v2),
			Face:createTriangle(v3, v1, v0),
			Face:createTriangle(v3, v2, v1),
			Face:createTriangle(v3, v0, v2),
		}) --[[ ROBLOX CHECK: check if 'faces' is an Array ]] -- set the opposite edge
		i = 0
		while
			i
			< 3 --[[ ROBLOX CHECK: operator '<' works only if either both arguments are strings or both are a number ]]
		do
			j = (i + 1) % 3 -- join face[i] i > 0, with the first face
			faces[(i + 1)]:getEdge(2):setOpposite(faces[
				1 --[[ ROBLOX adaptation: added 1 to array index ]]
			]:getEdge(j)) -- join face[i] with face[i + 1], 1 <= i <= 3
			faces[(i + 1)]:getEdge(1):setOpposite(faces[(j + 1)]:getEdge(0))
			i += 1
		end
	else
		-- the face is able to see the point so `planeNormal`
		-- is pointing inside the tetrahedron
		Array.concat(faces, {
			Face:createTriangle(v0, v2, v1),
			Face:createTriangle(v3, v0, v1),
			Face:createTriangle(v3, v1, v2),
			Face:createTriangle(v3, v2, v0),
		}) --[[ ROBLOX CHECK: check if 'faces' is an Array ]] -- set the opposite edge
		i = 0
		while
			i
			< 3 --[[ ROBLOX CHECK: operator '<' works only if either both arguments are strings or both are a number ]]
		do
			j = (i + 1) % 3 -- join face[i] i > 0, with the first face
			faces[(i + 1)]:getEdge(2):setOpposite(faces[
				1 --[[ ROBLOX adaptation: added 1 to array index ]]
			]:getEdge((3 - i) % 3)) -- join face[i] with face[i + 1]
			faces[(i + 1)]:getEdge(0):setOpposite(faces[(j + 1)]:getEdge(1))
			i += 1
		end
	end -- the initial hull is the tetrahedron
	i = 0
	while
		i < 4 --[[ ROBLOX CHECK: operator '<' works only if either both arguments are strings or both are a number ]]
	do
		table.insert(self.faces, faces[i]) --[[ ROBLOX CHECK: check if 'this.faces' is an Array ]]
		i += 1
	end -- initial assignment of vertices to the faces of the tetrahedron
	i = 0
	while
		i
		< #vertices --[[ ROBLOX CHECK: operator '<' works only if either both arguments are strings or both are a number ]]
	do
		local vertex = vertices[i]
		if vertex ~= v0 and vertex ~= v1 and vertex ~= v2 and vertex ~= v3 then
			maxDistance = self.tolerance
			local maxFace
			j = 0
			while
				j
				< 4 --[[ ROBLOX CHECK: operator '<' works only if either both arguments are strings or both are a number ]]
			do
				local distance = faces[j]:distanceToPlane(vertex.point)
				if
					distance
					> maxDistance --[[ ROBLOX CHECK: operator '>' works only if either both arguments are strings or both are a number ]]
				then
					maxDistance = distance
					maxFace = faces[j]
				end
				j += 1
			end
			if Boolean.toJSBoolean(maxFace) then
				self:addVertexToFace(vertex, maxFace)
			end
		end
		i += 1
	end
end
function QuickHull:reindexFaceAndVertices()
	-- remove inactive faces
	local activeFaces = {}
	do
		local i = 0
		while
			i
			< #self.faces --[[ ROBLOX CHECK: operator '<' works only if either both arguments are strings or both are a number ]]
		do
			local face = self.faces[i]
			if face.mark == VISIBLE then
				table.insert(activeFaces, face) --[[ ROBLOX CHECK: check if 'activeFaces' is an Array ]]
			end
			i += 1
		end
	end
	self.faces = activeFaces
end
function QuickHull:collectFaces(skipTriangulation)
	local faceIndices = {}
	do
		local i = 0
		while
			i
			< #self.faces --[[ ROBLOX CHECK: operator '<' works only if either both arguments are strings or both are a number ]]
		do
			if self.faces[i].mark ~= VISIBLE then
				error(Error.new("attempt to include a destroyed face in the hull"))
			end
			local indices = self.faces[i]:collectIndices()
			if Boolean.toJSBoolean(skipTriangulation) then
				table.insert(faceIndices, indices) --[[ ROBLOX CHECK: check if 'faceIndices' is an Array ]]
			else
				do
					local j = 0
					while
						j
						< #indices - 2 --[[ ROBLOX CHECK: operator '<' works only if either both arguments are strings or both are a number ]]
					do
						table.insert(faceIndices, {
							indices[
								1 --[[ ROBLOX adaptation: added 1 to array index ]]
							],
							indices[(j + 1)],
							indices[(j + 2)],
						}) --[[ ROBLOX CHECK: check if 'faceIndices' is an Array ]]
						j += 1
					end
				end
			end
			i += 1
		end
	end
	return faceIndices
end
function QuickHull:nextVertexToAdd()
	if not Boolean.toJSBoolean(self.claimed:isEmpty()) then
		local eyeVertex, vertex
		local maxDistance = 0
		local eyeFace = self.claimed:first().face
		vertex = eyeFace.outside
		while if Boolean.toJSBoolean(vertex) then vertex.face == eyeFace else vertex do
			local distance = eyeFace:distanceToPlane(vertex.point)
			if
				distance
				> maxDistance --[[ ROBLOX CHECK: operator '>' works only if either both arguments are strings or both are a number ]]
			then
				maxDistance = distance
				eyeVertex = vertex
			end
			vertex = vertex.next
		end
		return eyeVertex
	end
	return
end
function QuickHull:computeHorizon(eyePoint, crossEdge, face, horizon)
	-- moves face's vertices to the `unclaimed` vertex list
	self:deleteFaceVertices(face)
	face.mark = DELETED
	local edge
	if not Boolean.toJSBoolean(crossEdge) then
		crossEdge = face:getEdge(0)
		edge = crossEdge
	else
		-- start from the next edge since `crossEdge` was already analyzed
		-- (actually `crossEdge.opposite` was the face who called this method
		-- recursively)
		edge = crossEdge.next
	end -- All the faces that are able to see `eyeVertex` are defined as follows
	--
	--       v    /
	--           / <== visible face
	--          /
	--         |
	--         | <== not visible face
	--
	--  dot(v, visible face normal) - visible face offset > this.tolerance
	--
	repeat
		local oppositeEdge = edge.opposite
		local oppositeFace = oppositeEdge.face
		if oppositeFace.mark == VISIBLE then
			if
				oppositeFace:distanceToPlane(eyePoint)
				> self.tolerance --[[ ROBLOX CHECK: operator '>' works only if either both arguments are strings or both are a number ]]
			then
				self:computeHorizon(eyePoint, oppositeEdge, oppositeFace, horizon)
			else
				table.insert(horizon, edge) --[[ ROBLOX CHECK: check if 'horizon' is an Array ]]
			end
		end
		edge = edge.next
	until not (edge ~= crossEdge)
end
function QuickHull:addAdjoiningFace(eyeVertex, horizonEdge)
	-- all the half edges are created in ccw order thus the face is always
	-- pointing outside the hull
	-- edges:
	--
	--                  eyeVertex.point
	--                       / \
	--                      /   \
	--                  1  /     \  0
	--                    /       \
	--                   /         \
	--                  /           \
	--          horizon.tail --- horizon.head
	--                        2
	--
	local face = Face:createTriangle(eyeVertex, horizonEdge:tail(), horizonEdge:head())
	table.insert(self.faces, face) --[[ ROBLOX CHECK: check if 'this.faces' is an Array ]] -- join face.getEdge(-1) with the horizon's opposite edge
	-- face.getEdge(-1) = face.getEdge(2)
	face:getEdge(-1):setOpposite(horizonEdge.opposite)
	return face:getEdge(0)
end
function QuickHull:addNewFaces(eyeVertex, horizon)
	self.newFaces = {}
	local firstSideEdge, previousSideEdge
	do
		local i = 0
		while
			i
			< #horizon --[[ ROBLOX CHECK: operator '<' works only if either both arguments are strings or both are a number ]]
		do
			local horizonEdge = horizon[i] -- returns the right side edge
			local sideEdge = self:addAdjoiningFace(eyeVertex, horizonEdge)
			if not Boolean.toJSBoolean(firstSideEdge) then
				firstSideEdge = sideEdge
			else
				-- joins face.getEdge(1) with previousFace.getEdge(0)
				sideEdge.next:setOpposite(previousSideEdge)
			end
			table.insert(self.newFaces, sideEdge.face) --[[ ROBLOX CHECK: check if 'this.newFaces' is an Array ]]
			previousSideEdge = sideEdge
			i += 1
		end
	end
	firstSideEdge.next:setOpposite(previousSideEdge)
end
function QuickHull:oppositeFaceDistance(edge)
	return edge.face:distanceToPlane(edge.opposite.face.centroid)
end
function QuickHull:doAdjacentMerge(face, mergeType)
	local edge = face.edge
	local convex = true
	local it = 0
	repeat
		if
			it
			>= face.nVertices --[[ ROBLOX CHECK: operator '>=' works only if either both arguments are strings or both are a number ]]
		then
			error(Error.new("merge recursion limit exceeded"))
		end
		local oppositeFace = edge.opposite.face
		local merge = false -- Important notes about the algorithm to merge faces
		--
		-- - Given a vertex `eyeVertex` that will be added to the hull
		--   all the faces that cannot see `eyeVertex` are defined as follows
		--
		--      dot(v, not visible face normal) - not visible offset < tolerance
		--
		-- - Two faces can be merged when the centroid of one of these faces
		-- projected to the normal of the other face minus the other face offset
		-- is in the range [tolerance, -tolerance]
		-- - Since `face` (given in the input for this method) has passed the
		-- check above we only have to check the lower bound e.g.
		--
		--      dot(v, not visible face normal) - not visible offset > -tolerance
		--
		if mergeType == MERGE_NON_CONVEX then
			if
				self:oppositeFaceDistance(edge) > -self.tolerance --[[ ROBLOX CHECK: operator '>' works only if either both arguments are strings or both are a number ]]
				or self:oppositeFaceDistance(edge.opposite) > -self.tolerance --[[ ROBLOX CHECK: operator '>' works only if either both arguments are strings or both are a number ]]
			then
				merge = true
			end
		else
			if
				face.area
				> oppositeFace.area --[[ ROBLOX CHECK: operator '>' works only if either both arguments are strings or both are a number ]]
			then
				if
					self:oppositeFaceDistance(edge)
					> -self.tolerance --[[ ROBLOX CHECK: operator '>' works only if either both arguments are strings or both are a number ]]
				then
					merge = true
				elseif
					self:oppositeFaceDistance(edge.opposite)
					> -self.tolerance --[[ ROBLOX CHECK: operator '>' works only if either both arguments are strings or both are a number ]]
				then
					convex = false
				end
			else
				if
					self:oppositeFaceDistance(edge.opposite)
					> -self.tolerance --[[ ROBLOX CHECK: operator '>' works only if either both arguments are strings or both are a number ]]
				then
					merge = true
				elseif
					self:oppositeFaceDistance(edge)
					> -self.tolerance --[[ ROBLOX CHECK: operator '>' works only if either both arguments are strings or both are a number ]]
				then
					convex = false
				end
			end
		end
		if Boolean.toJSBoolean(merge) then
			-- when two faces are merged it might be possible that redundant faces
			-- are destroyed, in that case move all the visible vertices from the
			-- destroyed faces to the `unclaimed` vertex list
			local discardedFaces = face:mergeAdjacentFaces(edge, {})
			do
				local i = 0
				while
					i
					< #discardedFaces --[[ ROBLOX CHECK: operator '<' works only if either both arguments are strings or both are a number ]]
				do
					self:deleteFaceVertices(discardedFaces[i], face)
					i += 1
				end
			end
			return true
		end
		edge = edge.next
		it += 1
	until not (edge ~= face.edge)
	if not Boolean.toJSBoolean(convex) then
		face.mark = NON_CONVEX
	end
	return false
end
function QuickHull:addVertexToHull(eyeVertex)
	local horizon = {}
	self.unclaimed:clear() -- remove `eyeVertex` from `eyeVertex.face` so that it can't be added to the
	-- `unclaimed` vertex list
	self:removeVertexFromFace(eyeVertex, eyeVertex.face)
	self:computeHorizon(eyeVertex.point, nil, eyeVertex.face, horizon)
	self:addNewFaces(eyeVertex, horizon) -- first merge pass
	-- Do the merge with respect to the larger face
	do
		local i = 0
		while
			i
			< #self.newFaces --[[ ROBLOX CHECK: operator '<' works only if either both arguments are strings or both are a number ]]
		do
			local face = self.newFaces[i]
			if face.mark == VISIBLE then
				while Boolean.toJSBoolean(self:doAdjacentMerge(face, MERGE_NON_CONVEX_WRT_LARGER_FACE)) do
				end -- eslint-disable-line no-empty
			end
			i += 1
		end
	end -- second merge pass
	-- Do the merge on non convex faces (a face is marked as non convex in the
	-- first pass)
	do
		local i = 0
		while
			i
			< #self.newFaces --[[ ROBLOX CHECK: operator '<' works only if either both arguments are strings or both are a number ]]
		do
			local face = self.newFaces[i]
			if face.mark == NON_CONVEX then
				face.mark = VISIBLE
				while Boolean.toJSBoolean(self:doAdjacentMerge(face, MERGE_NON_CONVEX)) do
				end -- eslint-disable-line no-empty
			end
			i += 1
		end
	end -- reassign `unclaimed` vertices to the new faces
	self:resolveUnclaimedPoints(self.newFaces)
end
function QuickHull:build()
	local eyeVertex
	self:createInitialSimplex()
	while Boolean.toJSBoolean((function()
		eyeVertex = self:nextVertexToAdd()
		return eyeVertex
	end)()) do
		self:addVertexToHull(eyeVertex)
	end
	self:reindexFaceAndVertices()
end
return QuickHull
