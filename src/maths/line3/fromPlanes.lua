-- ROBLOX NOTE: no upstream
local Packages = game.ReplicatedStorage.Packages
local LuauPolyfill = require(Packages.LuauPolyfill)
local Error = LuauPolyfill.Error
local vec3 = require("../vec3")
local solve2Linear = require("../utils").solve2Linear
local EPS = require("../constants").EPS
local fromPointAndDirection = require("./fromPointAndDirection")
--[[*
 * Create a line the intersection of the given planes.
 *
 * @param {line3} out - receiving line
 * @param {plane} plane1 - first plane of reference
 * @param {plane} plane2 - second plane of reference
 * @returns {line3} out
 * @alias module:modeling/maths/line3.fromPlanes
 ]]
local function fromPlanes(out, plane1, plane2)
	local direction = vec3.cross(vec3.create(), plane1, plane2)
	local length = vec3.length(direction)
	if
		length
		< EPS --[[ ROBLOX CHECK: operator '<' works only if either both arguments are strings or both are a number ]]
	then
		error(Error.new("parallel planes do not intersect"))
	end
	length = 1.0 / length
	direction = vec3.scale(direction, direction, length)
	local absx = math.abs(direction[
		1 --[[ ROBLOX adaptation: added 1 to array index ]]
	])
	local absy = math.abs(direction[
		2 --[[ ROBLOX adaptation: added 1 to array index ]]
	])
	local absz = math.abs(direction[
		3 --[[ ROBLOX adaptation: added 1 to array index ]]
	])
	local origin
	local r
	if
		absx >= absy --[[ ROBLOX CHECK: operator '>=' works only if either both arguments are strings or both are a number ]]
		and absx >= absz --[[ ROBLOX CHECK: operator '>=' works only if either both arguments are strings or both are a number ]]
	then
		-- find a point p for which x is zero
		r = solve2Linear(
			plane1[
				2 --[[ ROBLOX adaptation: added 1 to array index ]]
			],
			plane1[
				3 --[[ ROBLOX adaptation: added 1 to array index ]]
			],
			plane2[
				2 --[[ ROBLOX adaptation: added 1 to array index ]]
			],
			plane2[
				3 --[[ ROBLOX adaptation: added 1 to array index ]]
			],
			plane1[
				4 --[[ ROBLOX adaptation: added 1 to array index ]]
			],
			plane2[
				4 --[[ ROBLOX adaptation: added 1 to array index ]]
			]
		)
		origin = vec3.fromValues(
			0,
			r[
				1 --[[ ROBLOX adaptation: added 1 to array index ]]
			],
			r[
				2 --[[ ROBLOX adaptation: added 1 to array index ]]
			]
		)
	elseif
		absy >= absx --[[ ROBLOX CHECK: operator '>=' works only if either both arguments are strings or both are a number ]]
		and absy >= absz --[[ ROBLOX CHECK: operator '>=' works only if either both arguments are strings or both are a number ]]
	then
		-- find a point p for which y is zero
		r = solve2Linear(
			plane1[
				1 --[[ ROBLOX adaptation: added 1 to array index ]]
			],
			plane1[
				3 --[[ ROBLOX adaptation: added 1 to array index ]]
			],
			plane2[
				1 --[[ ROBLOX adaptation: added 1 to array index ]]
			],
			plane2[
				3 --[[ ROBLOX adaptation: added 1 to array index ]]
			],
			plane1[
				4 --[[ ROBLOX adaptation: added 1 to array index ]]
			],
			plane2[
				4 --[[ ROBLOX adaptation: added 1 to array index ]]
			]
		)
		origin = vec3.fromValues(
			r[
				1 --[[ ROBLOX adaptation: added 1 to array index ]]
			],
			0,
			r[
				2 --[[ ROBLOX adaptation: added 1 to array index ]]
			]
		)
	else
		-- find a point p for which z is zero
		r = solve2Linear(
			plane1[
				1 --[[ ROBLOX adaptation: added 1 to array index ]]
			],
			plane1[
				2 --[[ ROBLOX adaptation: added 1 to array index ]]
			],
			plane2[
				1 --[[ ROBLOX adaptation: added 1 to array index ]]
			],
			plane2[
				2 --[[ ROBLOX adaptation: added 1 to array index ]]
			],
			plane1[
				4 --[[ ROBLOX adaptation: added 1 to array index ]]
			],
			plane2[
				4 --[[ ROBLOX adaptation: added 1 to array index ]]
			]
		)
		origin = vec3.fromValues(
			r[
				1 --[[ ROBLOX adaptation: added 1 to array index ]]
			],
			r[
				2 --[[ ROBLOX adaptation: added 1 to array index ]]
			],
			0
		)
	end
	return fromPointAndDirection(out, origin, direction)
end
return fromPlanes
