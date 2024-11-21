-- ROBLOX NOTE: no upstream
local Packages = game.ReplicatedStorage.Packages
local LuauPolyfill = require(Packages.LuauPolyfill)
local Boolean = LuauPolyfill.Boolean
local EPS = require("../../maths/constants").EPS
local vec2 = require("../../maths/vec2")
local clone = require("./clone")
--[[*
 * Close the given geometry.
 * @param {path2} geometry - the path to close
 * @returns {path2} a new path
 * @alias module:modeling/geometries/path2.close
 ]]
local function close(geometry)
	if Boolean.toJSBoolean(geometry.isClosed) then
		return geometry
	end
	local cloned = clone(geometry)
	cloned.isClosed = true
	if
		#cloned.points
		> 1 --[[ ROBLOX CHECK: operator '>' works only if either both arguments are strings or both are a number ]]
	then
		-- make sure the paths are formed properly
		local points = cloned.points
		local p0 = points[
			1 --[[ ROBLOX adaptation: added 1 to array index ]]
		]
		local pn = points[(#points - 1)]
		while
			vec2.distance(p0, pn)
			< EPS * EPS --[[ ROBLOX CHECK: operator '<' works only if either both arguments are strings or both are a number ]]
		do
			table.remove(points) --[[ ROBLOX CHECK: check if 'points' is an Array ]]
			if #points == 1 then
				break
			end
			pn = points[(#points - 1)]
		end
	end
	return cloned
end
return close
