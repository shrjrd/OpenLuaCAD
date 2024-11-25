-- ROBLOX NOTE: no upstream

local LuauPolyfill = require("@Packages/LuauPolyfill")
local Boolean = LuauPolyfill.Boolean
local distance = require("../../../maths/vec3/distance")
local squaredDistance = require("../../../maths/vec3/squaredDistance")
--[[
 * Original source from quickhull3d (https://github.com/mauriciopoppe/quickhull3d)
 * Copyright (c) 2015 Mauricio Poppe
 *
 * Adapted to JSCAD by Jeff Gay
 ]]
type HalfEdge = {
	head: (self: HalfEdge) -> any,
	tail: (self: HalfEdge) -> any,
	length: (self: HalfEdge) -> any,
	lengthSquared: (self: HalfEdge) -> any,
	setOpposite: (self: HalfEdge, edge: any) -> any,
}
type HalfEdge_statics = { new: (vertex: any, face: any) -> HalfEdge }
local HalfEdge = {} :: HalfEdge & HalfEdge_statics;
(HalfEdge :: any).__index = HalfEdge
function HalfEdge.new(vertex, face): HalfEdge
	local self = setmetatable({}, HalfEdge)
	self.vertex = vertex
	self.face = face
	self.next = nil
	self.prev = nil
	self.opposite = nil
	return (self :: any) :: HalfEdge
end
function HalfEdge:head()
	return self.vertex
end
function HalfEdge:tail()
	return if Boolean.toJSBoolean(self.prev) then self.prev.vertex else nil
end
function HalfEdge:length()
	if Boolean.toJSBoolean(self:tail()) then
		return distance(self:tail().point, self:head().point)
	end
	return -1
end
function HalfEdge:lengthSquared()
	if Boolean.toJSBoolean(self:tail()) then
		return squaredDistance(self:tail().point, self:head().point)
	end
	return -1
end
function HalfEdge:setOpposite(edge)
	self.opposite = edge
	edge.opposite = self
end
return HalfEdge
