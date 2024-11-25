-- ROBLOX NOTE: no upstream

local LuauPolyfill = require("@Packages/LuauPolyfill")
local Array = LuauPolyfill.Array
local Boolean = LuauPolyfill.Boolean
local Error = LuauPolyfill.Error
local Object = LuauPolyfill.Object
local geom3 = require("../geometries/geom3")
local poly3 = require("../geometries/poly3")
local isNumberArray = require("./commonChecks").isNumberArray
--[=[*
 * Construct an axis-aligned solid cuboid in three dimensional space.
 * @param {Object} [options] - options for construction
 * @param {Array} [options.center=[0,0,0]] - center of cuboid
 * @param {Array} [options.size=[2,2,2]] - dimensions of cuboid; width, depth, height
 * @returns {geom3} new 3D geometry
 * @alias module:modeling/primitives.cuboid
 *
 * @example
 * let myshape = cuboid({size: [5, 10, 5]})
 ]=]
local function cuboid(options)
	local defaults = { center = { 0, 0, 0 }, size = { 2, 2, 2 } }
	local center, size
	do
		local ref = Object.assign({}, defaults, options)
		center, size = ref.center, ref.size
	end
	if not Boolean.toJSBoolean(isNumberArray(center, 3)) then
		error(Error.new("center must be an array of X, Y and Z values"))
	end
	if not Boolean.toJSBoolean(isNumberArray(size, 3)) then
		error(Error.new("size must be an array of width, depth and height values"))
	end
	if
		not Boolean.toJSBoolean(Array.every(size, function(n)
			return n >= 0 --[[ ROBLOX CHECK: operator '>=' works only if either both arguments are strings or both are a number ]]
		end) --[[ ROBLOX CHECK: check if 'size' is an Array ]])
	then
		error(Error.new("size values must be positive"))
	end -- if any size is zero return empty geometry
	if
		size[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		] == 0
		or size[
			2 --[[ ROBLOX adaptation: added 1 to array index ]]
		] == 0
		or size[
			3 --[[ ROBLOX adaptation: added 1 to array index ]]
		] == 0
	then
		return geom3.create()
	end
	local result = geom3.create( -- adjust a basic shape to size
		Array.map({
			{ { 0, 4, 6, 2 }, { -1, 0, 0 } },
			{ { 1, 3, 7, 5 }, { tonumber(1), 0, 0 } },
			{ { 0, 1, 5, 4 }, { 0, -1, 0 } },
			{ { 2, 6, 7, 3 }, { 0, tonumber(1), 0 } },
			{ { 0, 2, 3, 1 }, { 0, 0, -1 } },
			{ { 4, 5, 7, 6 }, { 0, 0, tonumber(1) } },
		}, function(info)
			local points = Array.map(
				info[
					1 --[[ ROBLOX adaptation: added 1 to array index ]]
				],
				function(i)
					local pos = {
						center[
							1 --[[ ROBLOX adaptation: added 1 to array index ]]
						]
							+ size[
									1 --[[ ROBLOX adaptation: added 1 to array index ]]
								]
								/ 2
								* (
									2
										* (
											(
													not not Boolean.toJSBoolean(
														bit32.band(i, 1) --[[ ROBLOX CHECK: `bit32.band` clamps arguments and result to [0,2^32 - 1] ]]
													)
												)
												and 1
											or 0
										)
									- 1
								),
						center[
							2 --[[ ROBLOX adaptation: added 1 to array index ]]
						]
							+ size[
									2 --[[ ROBLOX adaptation: added 1 to array index ]]
								]
								/ 2
								* (
									2
										* (
											(
													not not Boolean.toJSBoolean(
														bit32.band(i, 2) --[[ ROBLOX CHECK: `bit32.band` clamps arguments and result to [0,2^32 - 1] ]]
													)
												)
												and 1
											or 0
										)
									- 1
								),
						center[
							3 --[[ ROBLOX adaptation: added 1 to array index ]]
						]
							+ size[
									3 --[[ ROBLOX adaptation: added 1 to array index ]]
								]
								/ 2
								* (
									2
										* (
											(
													not not Boolean.toJSBoolean(
														bit32.band(i, 4) --[[ ROBLOX CHECK: `bit32.band` clamps arguments and result to [0,2^32 - 1] ]]
													)
												)
												and 1
											or 0
										)
									- 1
								),
					}
					return pos
				end
			) --[[ ROBLOX CHECK: check if 'info[0]' is an Array ]]
			return poly3.create(points)
		end)
	)
	return result
end
return cuboid
