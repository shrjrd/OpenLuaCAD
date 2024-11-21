-- ROBLOX NOTE: no upstream
local mat4 = require("./mat4")
local vec2 = require("./vec2")
local vec3 = require("./vec3")
--[[
 * Class OrthoNormalBasis
 * Reprojects points on a 3D plane onto a 2D plane
 * or from a 2D plane back onto the 3D plane
 * @param  {plane} plane
 * @param  {vec3} rightvector
 ]]
local OrthoNormalBasis = {}
local OrthoNormalBasisMetatable = { __index = OrthoNormalBasis }
function OrthoNormalBasis.new(plane, rightvector)
	if
		--arguments.length < 2 --[[ ROBLOX CHECK: operator '<' works only if either both arguments are strings or both are a number ]]
		plane and not rightvector
	then
		-- choose an arbitrary right hand vector, making sure it is somewhat orthogonal to the plane normal:
		rightvector = vec3.orthogonal(vec3.create(), plane)
	end
	local self = {}
	self.v = vec3.normalize(vec3.create(), vec3.cross(vec3.create(), plane, rightvector))
	self.u = vec3.cross(vec3.create(), self.v, plane)
	self.plane = plane
	self.planeorigin = vec3.scale(
		vec3.create(),
		plane,
		plane[
			4 --[[ ROBLOX adaptation: added 1 to array index ]]
		]
	)
	return setmetatable(self, OrthoNormalBasisMetatable)
end
OrthoNormalBasis.prototype = {
	getProjectionMatrix = function(self)
		return mat4.fromValues(
			self.u[
				1 --[[ ROBLOX adaptation: added 1 to array index ]]
			],
			self.v[
				1 --[[ ROBLOX adaptation: added 1 to array index ]]
			],
			self.plane[
				1 --[[ ROBLOX adaptation: added 1 to array index ]]
			],
			0,
			self.u[
				2 --[[ ROBLOX adaptation: added 1 to array index ]]
			],
			self.v[
				2 --[[ ROBLOX adaptation: added 1 to array index ]]
			],
			self.plane[
				2 --[[ ROBLOX adaptation: added 1 to array index ]]
			],
			0,
			self.u[
				3 --[[ ROBLOX adaptation: added 1 to array index ]]
			],
			self.v[
				3 --[[ ROBLOX adaptation: added 1 to array index ]]
			],
			self.plane[
				3 --[[ ROBLOX adaptation: added 1 to array index ]]
			],
			0,
			0,
			0,
			-self.plane[
				4 --[[ ROBLOX adaptation: added 1 to array index ]]
			],
			1
		)
	end,
	getInverseProjectionMatrix = function(self)
		local p = vec3.scale(
			vec3.create(),
			self.plane,
			self.plane[
				4 --[[ ROBLOX adaptation: added 1 to array index ]]
			]
		)
		return mat4.fromValues(
			self.u[
				1 --[[ ROBLOX adaptation: added 1 to array index ]]
			],
			self.u[
				2 --[[ ROBLOX adaptation: added 1 to array index ]]
			],
			self.u[
				3 --[[ ROBLOX adaptation: added 1 to array index ]]
			],
			0,
			self.v[
				1 --[[ ROBLOX adaptation: added 1 to array index ]]
			],
			self.v[
				2 --[[ ROBLOX adaptation: added 1 to array index ]]
			],
			self.v[
				3 --[[ ROBLOX adaptation: added 1 to array index ]]
			],
			0,
			self.plane[
				1 --[[ ROBLOX adaptation: added 1 to array index ]]
			],
			self.plane[
				2 --[[ ROBLOX adaptation: added 1 to array index ]]
			],
			self.plane[
				3 --[[ ROBLOX adaptation: added 1 to array index ]]
			],
			0,
			p[
				1 --[[ ROBLOX adaptation: added 1 to array index ]]
			],
			p[
				2 --[[ ROBLOX adaptation: added 1 to array index ]]
			],
			p[
				3 --[[ ROBLOX adaptation: added 1 to array index ]]
			],
			1
		)
	end,
	to2D = function(self, point)
		return vec2:fromValues(vec3.dot(point, self.u), vec3.dot(point, self.v))
	end,
	to3D = function(self, point)
		local v1 = vec3.scale(
			vec3.create(),
			self.u,
			point[
				1 --[[ ROBLOX adaptation: added 1 to array index ]]
			]
		)
		local v2 = vec3.scale(
			vec3.create(),
			self.v,
			point[
				2 --[[ ROBLOX adaptation: added 1 to array index ]]
			]
		)
		local v3 = vec3.add(v1, v1, self.planeorigin)
		local v4 = vec3.add(v2, v2, v3)
		return v4
	end,
}
setmetatable(OrthoNormalBasis, { __index = OrthoNormalBasis.prototype })
return OrthoNormalBasis
