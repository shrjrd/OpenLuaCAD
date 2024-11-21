-- ROBLOX NOTE: no upstream
--[[
 * Original source from quickhull3d (https://github.com/mauriciopoppe/quickhull3d)
 * Copyright (c) 2015 Mauricio Poppe
 *
 * Adapted to JSCAD by Jeff Gay
 ]]
type Vertex = {}
type Vertex_statics = { new: (point: any, index: any) -> Vertex }
local Vertex = {} :: Vertex & Vertex_statics;
(Vertex :: any).__index = Vertex
function Vertex.new(point, index): Vertex
	local self = setmetatable({}, Vertex)
	self.point = point -- index in the input array
	self.index = index -- vertex is a double linked list node
	self.next = nil
	self.prev = nil -- the face that is able to see this point
	self.face = nil
	return (self :: any) :: Vertex
end
return Vertex
