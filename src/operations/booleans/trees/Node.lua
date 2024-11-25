-- ROBLOX NOTE: no upstream

local LuauPolyfill = require("@Packages/LuauPolyfill")
local Boolean = LuauPolyfill.Boolean
local plane = require("../../../maths/plane")
local poly3 = require("../../../geometries/poly3") -- # class Node
-- Holds a node in a BSP tree.
-- A BSP tree is built from a collection of polygons by picking a polygon to split along.
-- Polygons are not stored directly in the tree, but in PolygonTreeNodes, stored in this.polygontreenodes.
-- Those PolygonTreeNodes are children of the owning Tree.polygonTree.
-- This is not a leafy BSP tree since there is no distinction between internal and leaf nodes.
type Node = {
	invert: (self: Node) -> any, -- clip polygontreenodes to our plane
	-- calls remove() for all clipped PolygonTreeNodes
	clipPolygons: (self: Node, polygontreenodes: any, alsoRemovecoplanarFront: any) -> any, -- Remove all polygons in this BSP tree that are inside the other BSP tree
	-- `tree`.
	clipTo: (self: Node, tree: any, alsoRemovecoplanarFront: any) -> any,
	addPolygonTreeNodes: (self: Node, newpolygontreenodes: any) -> any,
}
type Node_statics = { new: (parent: any) -> Node }
local Node = {} :: Node & Node_statics;
(Node :: any).__index = Node
function Node.new(parent): Node
	local self = setmetatable({}, Node)
	self.plane = nil
	self.front = nil
	self.back = nil
	self.polygontreenodes = {}
	self.parent = parent
	return (self :: any) :: Node
end -- Convert solid space to empty space and empty space to solid space.
function Node:invert()
	local queue = { self }
	local node
	do
		local i = 0
		while
			i
			< #queue --[[ ROBLOX CHECK: operator '<' works only if either both arguments are strings or both are a number ]]
		do
			node = queue[i]
			if Boolean.toJSBoolean(node.plane) then
				node.plane = plane.flip(plane.create(), node.plane)
			end
			if Boolean.toJSBoolean(node.front) then
				table.insert(queue, node.front) --[[ ROBLOX CHECK: check if 'queue' is an Array ]]
			end
			if Boolean.toJSBoolean(node.back) then
				table.insert(queue, node.back) --[[ ROBLOX CHECK: check if 'queue' is an Array ]]
			end
			local temp = node.front
			node.front = node.back
			node.back = temp
			i += 1
		end
	end
end
function Node:clipPolygons(polygontreenodes, alsoRemovecoplanarFront)
	local current = { node = self, polygontreenodes = polygontreenodes }
	local node
	local stack = {}
	repeat
		node = current.node
		polygontreenodes = current.polygontreenodes
		if Boolean.toJSBoolean(node.plane) then
			local plane = node.plane
			local backnodes = {}
			local frontnodes = {}
			local coplanarfrontnodes = if Boolean.toJSBoolean(alsoRemovecoplanarFront) then backnodes else frontnodes
			local numpolygontreenodes = #polygontreenodes
			do
				local i = 0
				while
					i
					< numpolygontreenodes --[[ ROBLOX CHECK: operator '<' works only if either both arguments are strings or both are a number ]]
				do
					local treenode = polygontreenodes[i]
					if not Boolean.toJSBoolean(treenode:isRemoved()) then
						-- split this polygon tree node using the plane
						-- NOTE: children are added to the tree if there are spanning polygons
						treenode:splitByPlane(plane, coplanarfrontnodes, backnodes, frontnodes, backnodes)
					end
					i += 1
				end
			end
			if
				Boolean.toJSBoolean(if Boolean.toJSBoolean(node.front)
					then #frontnodes
						> 0 --[[ ROBLOX CHECK: operator '>' works only if either both arguments are strings or both are a number ]]
					else node.front)
			then
				-- add front node for further splitting
				table.insert(stack, { node = node.front, polygontreenodes = frontnodes }) --[[ ROBLOX CHECK: check if 'stack' is an Array ]]
			end
			local numbacknodes = #backnodes
			if
				Boolean.toJSBoolean(if Boolean.toJSBoolean(node.back)
					then numbacknodes
						> 0 --[[ ROBLOX CHECK: operator '>' works only if either both arguments are strings or both are a number ]]
					else node.back)
			then
				-- add back node for further splitting
				table.insert(stack, { node = node.back, polygontreenodes = backnodes }) --[[ ROBLOX CHECK: check if 'stack' is an Array ]]
			else
				-- remove all back nodes from processing
				do
					local i = 0
					while
						i
						< numbacknodes --[[ ROBLOX CHECK: operator '<' works only if either both arguments are strings or both are a number ]]
					do
						backnodes[i]:remove()
						i += 1
					end
				end
			end
		end
		local last = #stack
		current = stack[last]
		table.remove(stack, last) --[[ ROBLOX CHECK: check if 'stack' is an Array ]]
	until not (current ~= nil)
end
function Node:clipTo(tree, alsoRemovecoplanarFront)
	local node = self
	local stack = {}
	repeat
		if
			#node.polygontreenodes
			> 0 --[[ ROBLOX CHECK: operator '>' works only if either both arguments are strings or both are a number ]]
		then
			tree.rootnode:clipPolygons(node.polygontreenodes, alsoRemovecoplanarFront)
		end
		if Boolean.toJSBoolean(node.front) then
			table.insert(stack, node.front) --[[ ROBLOX CHECK: check if 'stack' is an Array ]]
		end
		if Boolean.toJSBoolean(node.back) then
			table.insert(stack, node.back) --[[ ROBLOX CHECK: check if 'stack' is an Array ]]
		end
		node = table.remove(stack) --[[ ROBLOX CHECK: check if 'stack' is an Array ]]
	until not (node ~= nil)
end
function Node:addPolygonTreeNodes(newpolygontreenodes)
	local current = { node = self, polygontreenodes = newpolygontreenodes }
	local stack = {}
	repeat
		local node = current.node
		local polygontreenodes = current.polygontreenodes
		if #polygontreenodes == 0 then
			local last = #stack
			current = stack[last]
			table.remove(stack, last) --[[ ROBLOX CHECK: check if 'stack' is an Array ]]
			continue
		end
		if not Boolean.toJSBoolean(node.plane) then
			local index = 0 -- default
			index = math.floor(#polygontreenodes / 2) -- index = #polygontreenodes >> 1
			-- index = Math.floor(Math.random()*#polygontreenodes)
			local bestpoly = polygontreenodes[index]:getPolygon()
			node.plane = poly3.plane(bestpoly)
		end
		local frontnodes = {}
		local backnodes = {}
		local n = #polygontreenodes
		do
			local i = 0
			while
				i
				< n --[[ ROBLOX CHECK: operator '<' works only if either both arguments are strings or both are a number ]]
			do
				polygontreenodes[i]:splitByPlane(node.plane, node.polygontreenodes, backnodes, frontnodes, backnodes)
				i += 1
			end
		end
		if
			#frontnodes
			> 0 --[[ ROBLOX CHECK: operator '>' works only if either both arguments are strings or both are a number ]]
		then
			if not Boolean.toJSBoolean(node.front) then
				node.front = Node.new(node)
			end -- unable to split by any of the current nodes
			local stopCondition = n == #frontnodes and #backnodes == 0
			if Boolean.toJSBoolean(stopCondition) then
				node.front.polygontreenodes = frontnodes
			else
				table.insert(stack, { node = node.front, polygontreenodes = frontnodes }) --[[ ROBLOX CHECK: check if 'stack' is an Array ]]
			end
		end
		if
			#backnodes
			> 0 --[[ ROBLOX CHECK: operator '>' works only if either both arguments are strings or both are a number ]]
		then
			if not Boolean.toJSBoolean(node.back) then
				node.back = Node.new(node)
			end -- unable to split by any of the current nodes
			local stopCondition = n == #backnodes and #frontnodes == 0
			if Boolean.toJSBoolean(stopCondition) then
				node.back.polygontreenodes = backnodes
			else
				table.insert(stack, { node = node.back, polygontreenodes = backnodes }) --[[ ROBLOX CHECK: check if 'stack' is an Array ]]
			end
		end
		local last = #stack
		current = stack[last]
		table.remove(stack, last) --[[ ROBLOX CHECK: check if 'stack' is an Array ]]
	until not (current ~= nil)
end
return Node
