-- ROBLOX NOTE: no upstream
local Packages = game.ReplicatedStorage.Packages
local LuauPolyfill = require(Packages.LuauPolyfill)
local Array = LuauPolyfill.Array
local Boolean = LuauPolyfill.Boolean
local Map = LuauPolyfill.Map
local console = LuauPolyfill.console
local geom2 = require("../../../geometries/geom2")
local plane = require("../../../maths/plane")
local vec2 = require("../../../maths/vec2")
local vec3 = require("../../../maths/vec3")
local calculatePlane = require("../slice/calculatePlane")
local assignHoles = require("./assignHoles")
--[[
 * Constructs a polygon hierarchy which associates holes with their outer solids.
 * This class maps a 3D polygon onto a 2D space using an orthonormal basis.
 * It tracks the mapping so that points can be reversed back to 3D losslessly.
 ]]
type PolygonHierarchy = { --[[
   * project a 3D point onto the 2D plane
   ]]
	to2D: (self: PolygonHierarchy, vector3: any) -> any,
	--[[
   * un-project a 2D point back into 3D
   ]]
	to3D: (self: PolygonHierarchy, vector2: any) -> any,
}
type PolygonHierarchy_statics = { new: (slice: any) -> PolygonHierarchy }
local PolygonHierarchy = {} :: PolygonHierarchy & PolygonHierarchy_statics;
(PolygonHierarchy :: any).__index = PolygonHierarchy
function PolygonHierarchy.new(slice): PolygonHierarchy
	local self = setmetatable({}, PolygonHierarchy)
	self.plane = calculatePlane(slice) -- create an orthonormal basis
	-- choose an arbitrary right hand vector, making sure it is somewhat orthogonal to the plane normal
	local rightvector = vec3.orthogonal(vec3.create(), self.plane)
	local perp = vec3.cross(vec3.create(), self.plane, rightvector)
	self.v = vec3.normalize(perp, perp)
	self.u = vec3.cross(vec3.create(), self.v, self.plane) -- map from 2D to original 3D points
	self.basisMap = Map.new() -- project slice onto 2D plane
	local projected = Array.map(slice.edges, function(e)
		return Array.map(e, function(v)
			return self:to2D(v)
		end) --[[ ROBLOX CHECK: check if 'e' is an Array ]]
	end) --[[ ROBLOX CHECK: check if 'slice.edges' is an Array ]] -- compute polygon hierarchies, assign holes to solids
	local geometry = geom2.create(projected)
	self.roots = assignHoles(geometry)
	return (self :: any) :: PolygonHierarchy
end
function PolygonHierarchy:to2D(vector3)
	local vector2 = vec2.fromValues(vec3.dot(vector3, self.u), vec3.dot(vector3, self.v))
	self.basisMap:set(vector2, vector3)
	return vector2
end
function PolygonHierarchy:to3D(vector2)
	-- use a map to get the original 3D, no floating point error
	local original = self.basisMap:get(vector2)
	if Boolean.toJSBoolean(original) then
		return original
	else
		console.log("Warning: point not in original slice")
		local v1 = vec3.scale(
			vec3.create(),
			self.u,
			vector2[
				1 --[[ ROBLOX adaptation: added 1 to array index ]]
			]
		)
		local v2 = vec3.scale(
			vec3.create(),
			self.v,
			vector2[
				2 --[[ ROBLOX adaptation: added 1 to array index ]]
			]
		)
		local planeOrigin = vec3.scale(
			vec3.create(),
			plane,
			plane[
				4 --[[ ROBLOX adaptation: added 1 to array index ]]
			]
		)
		local v3 = vec3.add(v1, v1, planeOrigin)
		return vec3.add(v2, v2, v3)
	end
end
return PolygonHierarchy
