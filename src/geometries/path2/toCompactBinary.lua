-- ROBLOX NOTE: no upstream

local LuauPolyfill = require("@Packages/LuauPolyfill")
local Boolean = LuauPolyfill.Boolean
--[[*
 * Produce a compact binary representation from the given path.
 * @param {path2} geometry - the path geometry
 * @returns {TypedArray} compact binary representation
 * @alias module:modeling/geometries/path2.toCompactBinary
 ]]
local function toCompactBinary(geometry)
	local points = geometry.points
	local transforms = geometry.transforms
	local color = { -1, -1, -1, -1 }
	if Boolean.toJSBoolean(geometry.color) then
		color = geometry.color
	end -- FIXME why Float32Array?
	local compacted = table.create(1 + 16 + 1 + 4 + #points * 2) -- type + transforms + isClosed + color + points data
	compacted[
		1 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = 2 -- type code: 0 => geom2, 1 => geom3 , 2 => path2
	compacted[
		2 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = transforms[
		1 --[[ ROBLOX adaptation: added 1 to array index ]]
	]
	compacted[
		3 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = transforms[
		2 --[[ ROBLOX adaptation: added 1 to array index ]]
	]
	compacted[
		4 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = transforms[
		3 --[[ ROBLOX adaptation: added 1 to array index ]]
	]
	compacted[
		5 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = transforms[
		4 --[[ ROBLOX adaptation: added 1 to array index ]]
	]
	compacted[
		6 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = transforms[
		5 --[[ ROBLOX adaptation: added 1 to array index ]]
	]
	compacted[
		7 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = transforms[
		6 --[[ ROBLOX adaptation: added 1 to array index ]]
	]
	compacted[
		8 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = transforms[
		7 --[[ ROBLOX adaptation: added 1 to array index ]]
	]
	compacted[
		9 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = transforms[
		8 --[[ ROBLOX adaptation: added 1 to array index ]]
	]
	compacted[
		10 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = transforms[
		9 --[[ ROBLOX adaptation: added 1 to array index ]]
	]
	compacted[
		11 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = transforms[
		10 --[[ ROBLOX adaptation: added 1 to array index ]]
	]
	compacted[
		12 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = transforms[
		11 --[[ ROBLOX adaptation: added 1 to array index ]]
	]
	compacted[
		13 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = transforms[
		12 --[[ ROBLOX adaptation: added 1 to array index ]]
	]
	compacted[
		14 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = transforms[
		13 --[[ ROBLOX adaptation: added 1 to array index ]]
	]
	compacted[
		15 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = transforms[
		14 --[[ ROBLOX adaptation: added 1 to array index ]]
	]
	compacted[
		16 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = transforms[
		15 --[[ ROBLOX adaptation: added 1 to array index ]]
	]
	compacted[
		17 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = transforms[
		16 --[[ ROBLOX adaptation: added 1 to array index ]]
	]
	compacted[
		18 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = if Boolean.toJSBoolean(geometry.isClosed)
		then 1
		else 0
	compacted[
		19 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = color[
		1 --[[ ROBLOX adaptation: added 1 to array index ]]
	]
	compacted[
		20 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = color[
		2 --[[ ROBLOX adaptation: added 1 to array index ]]
	]
	compacted[
		21 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = color[
		3 --[[ ROBLOX adaptation: added 1 to array index ]]
	]
	compacted[
		22 --[[ ROBLOX adaptation: added 1 to array index ]]
	] = color[
		4 --[[ ROBLOX adaptation: added 1 to array index ]]
	]
	do
		local j = 0
		while
			j
			< #points --[[ ROBLOX CHECK: operator '<' works only if either both arguments are strings or both are a number ]]
		do
			local ci = j * 2 + 22
			local point = points[j]
			compacted[ci] = point[
				1 --[[ ROBLOX adaptation: added 1 to array index ]]
			]
			compacted[(ci + 1)] = point[
				2 --[[ ROBLOX adaptation: added 1 to array index ]]
			]
			j += 1
		end
	end -- TODO: how about custom properties or fields ?
	return compacted
end
return toCompactBinary
