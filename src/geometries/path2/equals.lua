-- ROBLOX NOTE: no upstream

local LuauPolyfill = require("@Packages/LuauPolyfill")
local Boolean = LuauPolyfill.Boolean
local vec2 = require("../../maths/vec2")
local toPoints = require("./toPoints")
--[[*
  * Determine if the given paths are equal.
  * For closed paths, this includes equality under point order rotation.
  * @param {path2} a - the first path to compare
  * @param {path2} b - the second path to compare
  * @returns {Boolean}
  * @alias module:modeling/geometries/path2.equals
  ]]
local function equals(a, b)
	if a.isClosed ~= b.isClosed then
		return false
	end
	if #a.points ~= #b.points then
		return false
	end
	local apoints = toPoints(a)
	local bpoints = toPoints(b) -- closed paths might be equal under graph rotation
	-- so try comparison by rotating across all points
	local length = #apoints
	local offset = 0
	repeat
		local unequal = false
		do
			local i = 0
			while
				i
				< length --[[ ROBLOX CHECK: operator '<' works only if either both arguments are strings or both are a number ]]
			do
				if not Boolean.toJSBoolean(vec2.equals(apoints[i], bpoints[((i + offset) % length)])) then
					unequal = true
					break
				end
				i += 1
			end
		end
		if unequal == false then
			return true
		end -- unequal open paths should only be compared once, never rotated
		if not Boolean.toJSBoolean(a.isClosed) then
			return false
		end
	until not (
			(function()
				offset += 1
				return offset
			end)()
			< length --[[ ROBLOX CHECK: operator '<' works only if either both arguments are strings or both are a number ]]
		)
	return false
end
return equals
