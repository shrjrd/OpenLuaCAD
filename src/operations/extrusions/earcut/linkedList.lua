-- ROBLOX NOTE: no upstream
local Packages = game.ReplicatedStorage.Packages
local LuauPolyfill = require(Packages.LuauPolyfill)
local Boolean = LuauPolyfill.Boolean
local sortLinked = require("./linkedListSort")
type Node = {}
type Node_statics = { new: (i: any, x: any, y: any) -> Node }
local Node = {} :: Node & Node_statics;
(Node :: any).__index = Node
function Node.new(i, x, y): Node
	local self = setmetatable({}, Node)
	-- vertex index in coordinates array
	self.i = i -- vertex coordinates
	self.x = x
	self.y = y -- previous and next vertex nodes in a polygon ring
	self.prev = nil
	self.next = nil -- z-order curve value
	self.z = nil -- previous and next nodes in z-order
	self.prevZ = nil
	self.nextZ = nil -- indicates whether this is a steiner point
	self.steiner = false
	return (self :: any) :: Node
end
--[[
 * create a node and optionally link it with previous one (in a circular doubly linked list)
 ]]
local function insertNode(i, x, y, last)
	local p = Node.new(i, x, y)
	if not Boolean.toJSBoolean(last) then
		p.prev = p
		p.next = p
	else
		p.next = last.next
		p.prev = last
		last.next.prev = p
		last.next = p
	end
	return p
end
--[[
 * remove a node and join prev with next nodes
 ]]
local function removeNode(p)
	p.next.prev = p.prev
	p.prev.next = p.next
	if Boolean.toJSBoolean(p.prevZ) then
		p.prevZ.nextZ = p.nextZ
	end
	if Boolean.toJSBoolean(p.nextZ) then
		p.nextZ.prevZ = p.prevZ
	end
end
return { Node = Node, insertNode = insertNode, removeNode = removeNode, sortLinked = sortLinked }
