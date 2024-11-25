-- ROBLOX NOTE: no upstream

local LuauPolyfill = require("@Packages/LuauPolyfill")
local Boolean = LuauPolyfill.Boolean
local Node = require("./Node")
local PolygonTreeNode = require("./PolygonTreeNode") -- # class Tree
-- This is the root of a BSP tree.
-- This separate class for the root of the tree in order to hold the PolygonTreeNode root.
-- The actual tree is kept in this.rootnode
type Tree = {
	invert: (self: Tree) -> any, -- Remove all polygons in this BSP tree that are inside the other BSP tree
	-- `tree`.
	clipTo: (self: Tree, tree: any, alsoRemovecoplanarFront_: boolean?) -> any,
	allPolygons: (self: Tree) -> any,
	addPolygons: (self: Tree, polygons: any) -> any,
	clear: (self: Tree) -> any,
	toString: (self: Tree) -> any,
}
type Tree_statics = { new: (polygons: any) -> Tree }
local Tree = {} :: Tree & Tree_statics;
(Tree :: any).__index = Tree
function Tree.new(polygons): Tree
	local self = setmetatable({}, Tree)
	self.polygonTree = PolygonTreeNode.new()
	self.rootnode = Node.new(nil)
	if Boolean.toJSBoolean(polygons) then
		self:addPolygons(polygons)
	end
	return (self :: any) :: Tree
end
function Tree:invert()
	self.polygonTree:invert()
	self.rootnode:invert()
end
function Tree:clipTo(tree, alsoRemovecoplanarFront_: boolean?)
	local alsoRemovecoplanarFront: boolean = if alsoRemovecoplanarFront_ ~= nil then alsoRemovecoplanarFront_ else false
	self.rootnode:clipTo(tree, alsoRemovecoplanarFront)
end
function Tree:allPolygons()
	local result = {}
	self.polygonTree:getPolygons(result)
	return result
end
function Tree:addPolygons(polygons)
	local polygontreenodes = table.create(#polygons)
	do
		local i = 0
		while
			i
			< #polygons --[[ ROBLOX CHECK: operator '<' works only if either both arguments are strings or both are a number ]]
		do
			polygontreenodes[i] = self.polygonTree:addChild(polygons[i])
			i += 1
		end
	end
	self.rootnode:addPolygonTreeNodes(polygontreenodes)
end
function Tree:clear()
	self.polygonTree:clear()
end
function Tree:toString()
	local result = "Tree: " .. tostring(self.polygonTree:toString(""))
	return result
end
return Tree
