-- ROBLOX NOTE: no upstream

local LuauPolyfill = require("@Packages/LuauPolyfill")
local Array = LuauPolyfill.Array
local Boolean = LuauPolyfill.Boolean
local Error = LuauPolyfill.Error
local fromPoints = require("./fromPoints")
local toPoints = require("./toPoints")
local equals = require("../../maths/vec2").equals
--[=[*
 * Concatenate the given paths.
 *
 * If both contain the same point at the junction, merge it into one.
 * A concatenation of zero paths is an empty, open path.
 * A concatenation of one closed path to a series of open paths produces a closed path.
 * A concatenation of a path to a closed path is an error.
 * @param {...path2} paths - the paths to concatenate
 * @returns {path2} a new path
 * @alias module:modeling/geometries/path2.concat
 *
 * @example
 * let newpath = concat(fromPoints({}, [[1, 2]]), fromPoints({}, [[3, 4]]))
 ]=]
local function concat(
	...: any --[[ ROBLOX CHECK: check correct type of elements. ]]
)
	local paths = { ... }
	-- Only the last path can be closed, producing a closed path.
	local isClosed = false
	local newpoints = {}
	Array.forEach(paths, function(path, i)
		local tmp = Array.slice(toPoints(path)) --[[ ROBLOX CHECK: check if 'toPoints(path)' is an Array ]]
		if
			Boolean.toJSBoolean(
				#newpoints > 0 --[[ ROBLOX CHECK: operator '>' works only if either both arguments are strings or both are a number ]]
					and #tmp > 0 --[[ ROBLOX CHECK: operator '>' works only if either both arguments are strings or both are a number ]]
					and equals(
						tmp[
							1 --[[ ROBLOX adaptation: added 1 to array index ]]
						],
						newpoints[(#newpoints - 1)]
					)
			)
		then
			table.remove(tmp, 1) --[[ ROBLOX CHECK: check if 'tmp' is an Array ]]
		end
		if
			Boolean.toJSBoolean(
				#tmp > 0 --[[ ROBLOX CHECK: operator '>' works only if either both arguments are strings or both are a number ]]
					and isClosed
			)
		then
			error(Error.new(("Cannot concatenate to a closed path; check the %sth path"):format(tostring(i))))
		end
		isClosed = path.isClosed
		newpoints = Array.concat(newpoints, tmp) --[[ ROBLOX CHECK: check if 'newpoints' is an Array ]]
	end) --[[ ROBLOX CHECK: check if 'paths' is an Array ]]
	return fromPoints({ closed = isClosed }, newpoints)
end
return concat
