-- ROBLOX NOTE: no upstream

local LuauPolyfill = require("@Packages/LuauPolyfill")
local Array = LuauPolyfill.Array
local Boolean = LuauPolyfill.Boolean
local Error = LuauPolyfill.Error
local plane = require("../../../maths/plane")
local vec3 = require("../../../maths/vec3")
--[[*
 * Calculate the plane of the given slice.
 * NOTE: The slice (and all points) are assumed to be planar from the beginning.
 * @param {slice} slice - the slice
 * @returns {plane} the plane of the slice
 * @alias module:modeling/extrusions/slice.calculatePlane
 *
 * @example
 * let myplane = calculatePlane(slice)
 ]]
local function calculatePlane(slice)
	local edges = slice.edges
	if
		#edges
		< 3 --[[ ROBLOX CHECK: operator '<' works only if either both arguments are strings or both are a number ]]
	then
		error(Error.new("slices must have 3 or more edges to calculate a plane"))
	end -- find the midpoint of the slice, which will lie on the plane by definition
	local midpoint = Array.reduce(edges, function(point, edge)
		return vec3.add(
			vec3.create(),
			point,
			edge[
				1 --[[ ROBLOX adaptation: added 1 to array index ]]
			]
		)
	end, vec3.create()) --[[ ROBLOX CHECK: check if 'edges' is an Array ]]
	vec3.scale(midpoint, midpoint, 1 / #edges) -- find the farthest edge from the midpoint, which will be on an outside edge
	local farthestEdge
	local distance = 0
	Array.forEach(edges, function(edge)
		-- Make sure that the farthest edge is not a self-edge
		if
			not Boolean.toJSBoolean(vec3.equals(
				edge[
					1 --[[ ROBLOX adaptation: added 1 to array index ]]
				],
				edge[
					2 --[[ ROBLOX adaptation: added 1 to array index ]]
				]
			))
		then
			local d = vec3.squaredDistance(
				midpoint,
				edge[
					1 --[[ ROBLOX adaptation: added 1 to array index ]]
				]
			)
			if
				d
				> distance --[[ ROBLOX CHECK: operator '>' works only if either both arguments are strings or both are a number ]]
			then
				farthestEdge = edge
				distance = d
			end
		end
	end) --[[ ROBLOX CHECK: check if 'edges' is an Array ]] -- find the before edge
	local beforeEdge = Array.find(edges, function(edge)
		return vec3.equals(
			edge[
				2 --[[ ROBLOX adaptation: added 1 to array index ]]
			],
			farthestEdge[
				1 --[[ ROBLOX adaptation: added 1 to array index ]]
			]
		)
	end) --[[ ROBLOX CHECK: check if 'edges' is an Array ]]
	return plane.fromPoints(
		plane.create(),
		beforeEdge[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		],
		farthestEdge[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		],
		farthestEdge[
			2 --[[ ROBLOX adaptation: added 1 to array index ]]
		]
	)
end
return calculatePlane
