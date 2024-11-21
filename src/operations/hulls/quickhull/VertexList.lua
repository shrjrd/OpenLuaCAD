-- ROBLOX NOTE: no upstream
--[[
 * Original source from quickhull3d (https://github.com/mauriciopoppe/quickhull3d)
 * Copyright (c) 2015 Mauricio Poppe
 *
 * Adapted to JSCAD by Jeff Gay
 ]]
local Packages = game.ReplicatedStorage.Packages
local LuauPolyfill = require(Packages.LuauPolyfill)
local Boolean = LuauPolyfill.Boolean
type VertexList = {
	clear: (self: VertexList) -> any,
	--[[*
   * Inserts a `node` before `target`, it's assumed that
   * `target` belongs to this doubly linked list
   *
   * @param {*} target
   * @param {*} node
   ]]
	insertBefore: (self: VertexList, target: any, node: any) -> any,
	--[[*
   * Inserts a `node` after `target`, it's assumed that
   * `target` belongs to this doubly linked list
   *
   * @param {Vertex} target
   * @param {Vertex} node
   ]]
	insertAfter: (self: VertexList, target: any, node: any) -> any,
	--[[*
   * Appends a `node` to the end of this doubly linked list
   * Note: `node.next` will be unlinked from `node`
   * Note: if `node` is part of another linked list call `addAll` instead
   *
   * @param {*} node
   ]]
	add: (self: VertexList, node: any) -> any,
	--[[*
   * Appends a chain of nodes where `node` is the head,
   * the difference with `add` is that it correctly sets the position
   * of the node list `tail` property
   *
   * @param {*} node
   ]]
	addAll: (self: VertexList, node: any) -> any,
	--[[*
   * Deletes a `node` from this linked list, it's assumed that `node` is a
   * member of this linked list
   *
   * @param {*} node
   ]]
	remove: (self: VertexList, node: any) -> any,
	--[[*
   * Removes a chain of nodes whose head is `a` and whose tail is `b`,
   * it's assumed that `a` and `b` belong to this list and also that `a`
   * comes before `b` in the linked list
   *
   * @param {*} a
   * @param {*} b
   ]]
	removeChain: (self: VertexList, a: any, b: any) -> any,
	first: (self: VertexList) -> any,
	isEmpty: (self: VertexList) -> any,
}
type VertexList_statics = { new: () -> VertexList }
local VertexList = {} :: VertexList & VertexList_statics;
(VertexList :: any).__index = VertexList
function VertexList.new(): VertexList
	local self = setmetatable({}, VertexList)
	self.head = nil
	self.tail = nil
	return (self :: any) :: VertexList
end
function VertexList:clear()
	self.tail = nil
	self.head = self.tail
end
function VertexList:insertBefore(target, node)
	node.prev = target.prev
	node.next = target
	if not Boolean.toJSBoolean(node.prev) then
		self.head = node
	else
		node.prev.next = node
	end
	target.prev = node
end
function VertexList:insertAfter(target, node)
	node.prev = target
	node.next = target.next
	if not Boolean.toJSBoolean(node.next) then
		self.tail = node
	else
		node.next.prev = node
	end
	target.next = node
end
function VertexList:add(node)
	if not Boolean.toJSBoolean(self.head) then
		self.head = node
	else
		self.tail.next = node
	end
	node.prev = self.tail -- since node is the new end it doesn't have a next node
	node.next = nil
	self.tail = node
end
function VertexList:addAll(node)
	if not Boolean.toJSBoolean(self.head) then
		self.head = node
	else
		self.tail.next = node
	end
	node.prev = self.tail -- find the end of the list
	while Boolean.toJSBoolean(node.next) do
		node = node.next
	end
	self.tail = node
end
function VertexList:remove(node)
	if not Boolean.toJSBoolean(node.prev) then
		self.head = node.next
	else
		node.prev.next = node.next
	end
	if not Boolean.toJSBoolean(node.next) then
		self.tail = node.prev
	else
		node.next.prev = node.prev
	end
end
function VertexList:removeChain(a, b)
	if not Boolean.toJSBoolean(a.prev) then
		self.head = b.next
	else
		a.prev.next = b.next
	end
	if not Boolean.toJSBoolean(b.next) then
		self.tail = a.prev
	else
		b.next.prev = a.prev
	end
end
function VertexList:first()
	return self.head
end
function VertexList:isEmpty()
	return not Boolean.toJSBoolean(self.head)
end
return VertexList
