-- ROBLOX NOTE: no upstream
local Packages = game.ReplicatedStorage.Packages
local LuauPolyfill = require(Packages.LuauPolyfill)
local Array = LuauPolyfill.Array
local Boolean = LuauPolyfill.Boolean
local WeakMap = LuauPolyfill.WeakMap
local vec4 = require("../../maths/vec4")
local cache = WeakMap.new()
--[[*
 * Measure the bounding sphere of the given polygon.
 * @param {poly3} polygon - the polygon to measure
 * @returns {vec4} the computed bounding sphere; center point (3D) and radius
 * @alias module:modeling/geometries/poly3.measureBoundingSphere
 ]]
local function measureBoundingSphere(polygon)
	local boundingSphere = cache:get(polygon)
	if Boolean.toJSBoolean(boundingSphere) then
		return boundingSphere
	end
	local vertices = polygon.vertices
	local out = vec4.create()
	if #vertices == 0 then
		out[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		] = 0
		out[
			2 --[[ ROBLOX adaptation: added 1 to array index ]]
		] = 0
		out[
			3 --[[ ROBLOX adaptation: added 1 to array index ]]
		] = 0
		out[
			4 --[[ ROBLOX adaptation: added 1 to array index ]]
		] = 0
		return out
	end -- keep a list of min/max vertices by axis
	local minx = vertices[
		1 --[[ ROBLOX adaptation: added 1 to array index ]]
	]
	local miny = minx
	local minz = minx
	local maxx = minx
	local maxy = minx
	local maxz = minx
	Array.forEach(vertices, function(v)
		if
			minx[
				1 --[[ ROBLOX adaptation: added 1 to array index ]]
			]
			> v[
				1 --[[ ROBLOX adaptation: added 1 to array index ]]
			] --[[ ROBLOX CHECK: operator '>' works only if either both arguments are strings or both are a number ]]
		then
			minx = v
		end
		if
			miny[
				2 --[[ ROBLOX adaptation: added 1 to array index ]]
			]
			> v[
				2 --[[ ROBLOX adaptation: added 1 to array index ]]
			] --[[ ROBLOX CHECK: operator '>' works only if either both arguments are strings or both are a number ]]
		then
			miny = v
		end
		if
			minz[
				3 --[[ ROBLOX adaptation: added 1 to array index ]]
			]
			> v[
				3 --[[ ROBLOX adaptation: added 1 to array index ]]
			] --[[ ROBLOX CHECK: operator '>' works only if either both arguments are strings or both are a number ]]
		then
			minz = v
		end
		if
			maxx[
				1 --[[ ROBLOX adaptation: added 1 to array index ]]
			]
			< v[
				1 --[[ ROBLOX adaptation: added 1 to array index ]]
			] --[[ ROBLOX CHECK: operator '<' works only if either both arguments are strings or both are a number ]]
		then
			maxx = v
		end
		if
			maxy[
				2 --[[ ROBLOX adaptation: added 1 to array index ]]
			]
			< v[
				2 --[[ ROBLOX adaptation: added 1 to array index ]]
			] --[[ ROBLOX CHECK: operator '<' works only if either both arguments are strings or both are a number ]]
		then
			maxy = v
		end
		if
			maxz[
				3 --[[ ROBLOX adaptation: added 1 to array index ]]
			]
			< v[
				3 --[[ ROBLOX adaptation: added 1 to array index ]]
			] --[[ ROBLOX CHECK: operator '<' works only if either both arguments are strings or both are a number ]]
		then
			maxz = v
		end
	end) --[[ ROBLOX CHECK: check if 'vertices' is an Array ]]
	out[
		1 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = (
		minx[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		] + maxx[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		]
	) * 0.5 -- center of sphere
	out[
		2 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = (
		miny[
			2 --[[ ROBLOX adaptation: added 1 to array index ]]
		] + maxy[
			2 --[[ ROBLOX adaptation: added 1 to array index ]]
		]
	) * 0.5
	out[
		3 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = (
		minz[
			3 --[[ ROBLOX adaptation: added 1 to array index ]]
		] + maxz[
			3 --[[ ROBLOX adaptation: added 1 to array index ]]
		]
	) * 0.5
	local x = out[
		1 --[[ ROBLOX adaptation: added 1 to array index ]]
	] - maxx[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		]
	local y = out[
		2 --[[ ROBLOX adaptation: added 1 to array index ]]
	] - maxy[
			2 --[[ ROBLOX adaptation: added 1 to array index ]]
		]
	local z = out[
		3 --[[ ROBLOX adaptation: added 1 to array index ]]
	] - maxz[
			3 --[[ ROBLOX adaptation: added 1 to array index ]]
		]
	out[
		4 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = math.sqrt(x * x + y * y + z * z) -- radius of sphere
	cache:set(polygon, out)
	return out
end
return measureBoundingSphere
