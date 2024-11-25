-- ROBLOX NOTE: no upstream

local LuauPolyfill = require("@Packages/LuauPolyfill")
local Array = LuauPolyfill.Array
local Boolean = LuauPolyfill.Boolean
local Error = LuauPolyfill.Error
local Map = LuauPolyfill.Map
local Number = LuauPolyfill.Number
local poly3 = require("../poly3")
local isA = require("./isA")
--[[
 * Check manifold edge condition: Every edge is in exactly 2 faces
 ]]
local function validateManifold(object)
	-- count of each edge
	local edgeCount = Map.new()
	Array.forEach(object.polygons, function(ref0)
		local vertices = ref0.vertices
		Array.forEach(vertices, function(v, i)
			local v1 = ("%s"):format(tostring(v))
			local v2 = ("%s"):format(tostring(vertices[((i + 1) % #vertices)])) -- sort for undirected edge
			local edge = ("%s/%s"):format(tostring(v1), tostring(v2))
			local count = if Boolean.toJSBoolean(edgeCount:has(edge)) then edgeCount:get(edge) else 0
			edgeCount:set(edge, count + 1)
		end) --[[ ROBLOX CHECK: check if 'vertices' is an Array ]]
	end) --[[ ROBLOX CHECK: check if 'object.polygons' is an Array ]] -- check that edges are always matched
	local nonManifold = {}
	Array.forEach(edgeCount, function(count, edge)
		local complementEdge =
			Array.join(Array.reverse(edge:split("/")), --[[ ROBLOX CHECK: check if 'edge.split('/')' is an Array ]] "/")
		local complementCount = edgeCount:get(complementEdge)
		if count ~= complementCount then
			table.insert(nonManifold, edge:replace("/", " -> ")) --[[ ROBLOX CHECK: check if 'nonManifold' is an Array ]]
		end
	end) --[[ ROBLOX CHECK: check if 'edgeCount' is an Array ]]
	if
		#nonManifold
		> 0 --[[ ROBLOX CHECK: operator '>' works only if either both arguments are strings or both are a number ]]
	then
		error(
			Error.new(
				("non-manifold edges %s\n%s"):format(
					tostring(#nonManifold),
					tostring(Array.join(nonManifold, "\n") --[[ ROBLOX CHECK: check if 'nonManifold' is an Array ]])
				)
			)
		)
	end
end
--[[*
 * Determine if the given object is a valid 3D geometry.
 * Checks for valid data structure, convex polygon faces, and manifold edges.
 *
 * **If the geometry is not valid, an exception will be thrown with details of the geometry error.**
 *
 * @param {Object} object - the object to interrogate
 * @throws {Error} error if the geometry is not valid
 * @alias module:modeling/geometries/geom3.validate
 ]]
local function validate(object)
	if not Boolean.toJSBoolean(isA(object)) then
		error(Error.new("invalid geom3 structure"))
	end -- check polygons
	Array.forEach(object.polygons, poly3.validate) --[[ ROBLOX CHECK: check if 'object.polygons' is an Array ]]
	validateManifold(object) -- check transforms
	if
		not Boolean.toJSBoolean(
			Array.every(object.transforms, Number.isFinite) --[[ ROBLOX CHECK: check if 'object.transforms' is an Array ]]
		)
	then
		error(Error.new(("geom3 invalid transforms %s"):format(tostring(object.transforms))))
	end -- TODO: check for self-intersecting
end

return validate
