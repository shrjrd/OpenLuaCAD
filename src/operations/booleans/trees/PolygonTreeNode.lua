-- ROBLOX NOTE: no upstream
local Packages = game.ReplicatedStorage.Packages
local LuauPolyfill = require(Packages.LuauPolyfill)
local Array = LuauPolyfill.Array
local Boolean = LuauPolyfill.Boolean
local Error = LuauPolyfill.Error
local EPS = require("../../../maths/constants").EPS
local vec3 = require("../../../maths/vec3")
local poly3 = require("../../../geometries/poly3")
local splitPolygonByPlane = require("./splitPolygonByPlane") -- # class PolygonTreeNode
-- This class manages hierarchical splits of polygons.
-- At the top is a root node which does not hold a polygon, only child PolygonTreeNodes.
-- Below that are zero or more 'top' nodes; each holds a polygon.
-- The polygons can be in different planes.
-- splitByPlane() splits a node by a plane. If the plane intersects the polygon, two new child nodes
-- are created holding the splitted polygon.
-- getPolygons() retrieves the polygons from the tree. If for PolygonTreeNode the polygon is split but
-- the two split parts (child nodes) are still intact, then the unsplit polygon is returned.
-- This ensures that we can safely split a polygon into many fragments. If the fragments are untouched,
-- getPolygons() will return the original unsplit polygon instead of the fragments.
-- remove() removes a polygon from the tree. Once a polygon is removed, the parent polygons are invalidated
-- since they are no longer intact.
type PolygonTreeNode = { -- always be a derivate (split) of the parent node.
	addPolygons: (self: PolygonTreeNode, polygons: any) -> any, -- remove a node
	-- - the siblings become toplevel nodes
	-- - the parent is removed recursively
	remove: (self: PolygonTreeNode) -> any,
	isRemoved: (self: PolygonTreeNode) -> any,
	isRootNode: (self: PolygonTreeNode) -> any, -- invert all polygons in the tree. Call on the root node
	invert: (self: PolygonTreeNode) -> any,
	getPolygon: (self: PolygonTreeNode) -> any,
	getPolygons: (self: PolygonTreeNode, result: any) -> any, -- split the node by a plane; add the resulting nodes to the frontnodes and backnodes array
	-- If the plane doesn't intersect the polygon, the 'this' object is added to one of the arrays
	-- If the plane does intersect the polygon, two new child nodes are created for the front and back fragments,
	--  and added to both arrays.
	splitByPlane: (
		self: PolygonTreeNode,
		plane: any,
		coplanarfrontnodes: any,
		coplanarbacknodes: any,
		frontnodes: any,
		backnodes: any
	) -> any, -- only to be called for nodes with no children
	_splitByPlane: (
		self: PolygonTreeNode,
		splane: any,
		coplanarfrontnodes: any,
		coplanarbacknodes: any,
		frontnodes: any,
		backnodes: any
	) -> any, -- PRIVATE methods from here:
	-- add child to a node
	-- this should be called whenever the polygon is split
	-- a child should be created for every fragment of the split polygon
	-- returns the newly created child
	addChild: (self: PolygonTreeNode, polygon: any) -> any,
	invertSub: (self: PolygonTreeNode) -> any, -- private method
	-- remove the polygon from the node, and all parent nodes above it
	-- called to invalidate parents of removed nodes
	recursivelyInvalidatePolygon: (self: PolygonTreeNode) -> any,
	clear: (self: PolygonTreeNode) -> any,
	toString: (self: PolygonTreeNode) -> any,
}
type PolygonTreeNode_statics = { new: (parent: any, polygon: any) -> PolygonTreeNode }
local PolygonTreeNode = {} :: PolygonTreeNode & PolygonTreeNode_statics;
(PolygonTreeNode :: any).__index = PolygonTreeNode
-- constructor creates the root node
function PolygonTreeNode.new(parent, polygon): PolygonTreeNode
	local self = setmetatable({}, PolygonTreeNode)
	self.parent = parent
	self.children = {}
	self.polygon = polygon
	self.removed = false -- state of branch or leaf
	return (self :: any) :: PolygonTreeNode
end -- fill the tree with polygons. Should be called on the root node only; child nodes must
function PolygonTreeNode:addPolygons(polygons)
	-- new polygons can only be added to root node; children can only be splitted polygons
	if not Boolean.toJSBoolean(self:isRootNode()) then
		error(Error.new("Assertion failed"))
	end
	local _this = self
	Array.forEach(polygons, function(polygon)
		_this:addChild(polygon)
	end) --[[ ROBLOX CHECK: check if 'polygons' is an Array ]]
end
function PolygonTreeNode:remove()
	if not Boolean.toJSBoolean(self.removed) then
		self.removed = true
		self.polygon = nil -- remove ourselves from the parent's children list:
		local parentschildren = self.parent.children
		local i = Array.indexOf(parentschildren, self) --[[ ROBLOX CHECK: check if 'parentschildren' is an Array ]]
		if
			i
			< 0 --[[ ROBLOX CHECK: operator '<' works only if either both arguments are strings or both are a number ]]
		then
			error(Error.new("Assertion failed"))
		end
		Array.splice(parentschildren, i, 1) --[[ ROBLOX CHECK: check if 'parentschildren' is an Array ]] -- invalidate the parent's polygon, and of all parents above it:
		self.parent:recursivelyInvalidatePolygon()
	end
end
function PolygonTreeNode:isRemoved()
	return self.removed
end
function PolygonTreeNode:isRootNode()
	return not Boolean.toJSBoolean(self.parent)
end
function PolygonTreeNode:invert()
	if not Boolean.toJSBoolean(self:isRootNode()) then
		error(Error.new("Assertion failed"))
	end -- can only call this on the root node
	self:invertSub()
end
function PolygonTreeNode:getPolygon()
	if not Boolean.toJSBoolean(self.polygon) then
		error(Error.new("Assertion failed"))
	end -- doesn't have a polygon, which means that it has been broken down
	return self.polygon
end
function PolygonTreeNode:getPolygons(result)
	local children = { self }
	local queue = { children }
	local i, j, l, node
	i = 0
	while
		i
		< #queue --[[ ROBLOX CHECK: operator '<' works only if either both arguments are strings or both are a number ]]
	do
		-- queue size can change in loop, don't cache length
		children = queue[i]
		j = 0
		l = #children
		while
			j
			< l --[[ ROBLOX CHECK: operator '<' works only if either both arguments are strings or both are a number ]]
		do
			-- ok to cache length
			node = children[j]
			if Boolean.toJSBoolean(node.polygon) then
				-- the polygon hasn't been broken yet. We can ignore the children and return our polygon:
				table.insert(result, node.polygon) --[[ ROBLOX CHECK: check if 'result' is an Array ]]
			else
				-- our polygon has been split up and broken, so gather all subpolygons from the children
				if
					#node.children
					> 0 --[[ ROBLOX CHECK: operator '>' works only if either both arguments are strings or both are a number ]]
				then
					table.insert(queue, node.children) --[[ ROBLOX CHECK: check if 'queue' is an Array ]]
				end
			end
			j += 1
		end
		i += 1
	end
end
function PolygonTreeNode:splitByPlane(plane, coplanarfrontnodes, coplanarbacknodes, frontnodes, backnodes)
	if Boolean.toJSBoolean(#self.children) then
		local queue = { self.children }
		local i
		local j
		local l
		local node
		local nodes
		i = 0
		while
			i
			< #queue --[[ ROBLOX CHECK: operator '<' works only if either both arguments are strings or both are a number ]]
		do
			-- #queue can increase, do not cache
			nodes = queue[i]
			j = 0
			l = #nodes
			while
				j
				< l --[[ ROBLOX CHECK: operator '<' works only if either both arguments are strings or both are a number ]]
			do
				-- ok to cache length
				node = nodes[j]
				if
					#node.children
					> 0 --[[ ROBLOX CHECK: operator '>' works only if either both arguments are strings or both are a number ]]
				then
					table.insert(queue, node.children) --[[ ROBLOX CHECK: check if 'queue' is an Array ]]
				else
					-- no children. Split the polygon:
					node:_splitByPlane(plane, coplanarfrontnodes, coplanarbacknodes, frontnodes, backnodes)
				end
				j += 1
			end
			i += 1
		end
	else
		self:_splitByPlane(plane, coplanarfrontnodes, coplanarbacknodes, frontnodes, backnodes)
	end
end
function PolygonTreeNode:_splitByPlane(splane, coplanarfrontnodes, coplanarbacknodes, frontnodes, backnodes)
	local polygon = self.polygon
	if Boolean.toJSBoolean(polygon) then
		local bound = poly3.measureBoundingSphere(polygon)
		local sphereradius = bound[
			4 --[[ ROBLOX adaptation: added 1 to array index ]]
		] + EPS -- ensure radius is LARGER then polygon
		local spherecenter = bound
		local d = vec3.dot(splane, spherecenter) - splane[
			4 --[[ ROBLOX adaptation: added 1 to array index ]]
		]
		if
			d
			> sphereradius --[[ ROBLOX CHECK: operator '>' works only if either both arguments are strings or both are a number ]]
		then
			table.insert(frontnodes, self) --[[ ROBLOX CHECK: check if 'frontnodes' is an Array ]]
		elseif
			d
			< -sphereradius --[[ ROBLOX CHECK: operator '<' works only if either both arguments are strings or both are a number ]]
		then
			table.insert(backnodes, self) --[[ ROBLOX CHECK: check if 'backnodes' is an Array ]]
		else
			local splitresult = splitPolygonByPlane(splane, polygon)
			local condition_ = splitresult.type
			if condition_ == 0 then
				-- coplanar front:
				table.insert(coplanarfrontnodes, self) --[[ ROBLOX CHECK: check if 'coplanarfrontnodes' is an Array ]]
			elseif condition_ == 1 then
				-- coplanar back:
				table.insert(coplanarbacknodes, self) --[[ ROBLOX CHECK: check if 'coplanarbacknodes' is an Array ]]
			elseif condition_ == 2 then
				-- front:
				table.insert(frontnodes, self) --[[ ROBLOX CHECK: check if 'frontnodes' is an Array ]]
			elseif condition_ == 3 then
				-- back:
				table.insert(backnodes, self) --[[ ROBLOX CHECK: check if 'backnodes' is an Array ]]
			elseif condition_ == 4 then
				-- spanning:
				if Boolean.toJSBoolean(splitresult.front) then
					local frontnode = self:addChild(splitresult.front)
					table.insert(frontnodes, frontnode) --[[ ROBLOX CHECK: check if 'frontnodes' is an Array ]]
				end
				if Boolean.toJSBoolean(splitresult.back) then
					local backnode = self:addChild(splitresult.back)
					table.insert(backnodes, backnode) --[[ ROBLOX CHECK: check if 'backnodes' is an Array ]]
				end
			end
		end
	end
end
function PolygonTreeNode:addChild(polygon)
	local newchild = PolygonTreeNode.new(self, polygon)
	table.insert(self.children, newchild) --[[ ROBLOX CHECK: check if 'this.children' is an Array ]]
	return newchild
end
function PolygonTreeNode:invertSub()
	local children = { self }
	local queue = { children }
	local i, j, l, node
	i = 0
	while
		i
		< #queue --[[ ROBLOX CHECK: operator '<' works only if either both arguments are strings or both are a number ]]
	do
		children = queue[i]
		j = 0
		l = #children
		while
			j
			< l --[[ ROBLOX CHECK: operator '<' works only if either both arguments are strings or both are a number ]]
		do
			node = children[j]
			if Boolean.toJSBoolean(node.polygon) then
				node.polygon = poly3.invert(node.polygon)
			end
			if
				#node.children
				> 0 --[[ ROBLOX CHECK: operator '>' works only if either both arguments are strings or both are a number ]]
			then
				table.insert(queue, node.children) --[[ ROBLOX CHECK: check if 'queue' is an Array ]]
			end
			j += 1
		end
		i += 1
	end
end
function PolygonTreeNode:recursivelyInvalidatePolygon()
	self.polygon = nil
	if Boolean.toJSBoolean(self.parent) then
		self.parent:recursivelyInvalidatePolygon()
	end
end
function PolygonTreeNode:clear()
	local children = { self }
	local queue = { children }
	do
		local i = 0
		while
			i
			< #queue --[[ ROBLOX CHECK: operator '<' works only if either both arguments are strings or both are a number ]]
		do
			-- queue size can change in loop, don't cache length
			children = queue[i]
			local l = #children
			do
				local j = 0
				while
					j
					< l --[[ ROBLOX CHECK: operator '<' works only if either both arguments are strings or both are a number ]]
				do
					local node = children[j]
					if Boolean.toJSBoolean(node.polygon) then
						node.polygon = nil
					end
					if Boolean.toJSBoolean(node.parent) then
						node.parent = nil
					end
					if
						#node.children
						> 0 --[[ ROBLOX CHECK: operator '>' works only if either both arguments are strings or both are a number ]]
					then
						table.insert(queue, node.children) --[[ ROBLOX CHECK: check if 'queue' is an Array ]]
					end
					node.children = {}
					j += 1
				end
			end
			i += 1
		end
	end
end
function PolygonTreeNode:toString()
	local result = ""
	local children = { self }
	local queue = { children }
	local i, j, l, node
	i = 0
	while
		i
		< #queue --[[ ROBLOX CHECK: operator '<' works only if either both arguments are strings or both are a number ]]
	do
		-- queue size can change in loop, don't cache length
		children = queue[i]
		local prefix = string.rep(" ", i)
		j = 0
		l = #children
		while
			j
			< l --[[ ROBLOX CHECK: operator '<' works only if either both arguments are strings or both are a number ]]
		do
			-- ok to cache length
			node = children[j]
			result ..= ("%sPolygonTreeNode (%s): %s"):format(
				tostring(prefix),
				tostring(node:isRootNode()),
				tostring(#node.children)
			)
			if Boolean.toJSBoolean(node.polygon) then
				result ..= ("\n %spolygon: %s\n"):format(tostring(prefix), tostring(node.polygon.vertices))
			else
				result ..= "\n"
			end
			if
				#node.children
				> 0 --[[ ROBLOX CHECK: operator '>' works only if either both arguments are strings or both are a number ]]
			then
				table.insert(queue, node.children) --[[ ROBLOX CHECK: check if 'queue' is an Array ]]
			end
			j += 1
		end
		i += 1
	end
	return result
end
return PolygonTreeNode
